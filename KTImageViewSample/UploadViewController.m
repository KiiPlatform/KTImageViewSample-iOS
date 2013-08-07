//
//
// Copyright 2013 Kii Corporation
// http://kii.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//

#import "UploadViewController.h"

#import "KiiToolkit.h"

#import <KiiSDK/Kii.h>
#import <QuartzCore/QuartzCore.h>

@interface UploadViewController () {
    UILabel *_imageLabel;
}

@end

@implementation UploadViewController

@synthesize imageLabel = _imageLabel;

- (IBAction)generateNewImage:(id)sender
{
    // update the background color for the label
    _imageLabel.backgroundColor = [UIColor randomColor];
    _imageLabel.text =  [[NSDate date] description];
}

- (IBAction)uploadNewImage:(id)sender
{
    // show a loader
    [KTLoader showLoader:@"Uploading image..." animated:TRUE];
    
    // export the label view as an image
    UIGraphicsBeginImageContext(_imageLabel.frame.size);
    [_imageLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *exportedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // upload the image
    KiiFileBucket *bucket = [[KiiUser currentUser] fileBucketWithName:FILE_BUCKET_NAME];
    KiiFile *file = [bucket fileWithData:UIImagePNGRepresentation(exportedImage)];
    [file saveFileWithProgressBlock:^(KiiFile *file, double progress) { }
                 andCompletionBlock:^(KiiFile *file, NSError *error) {
                     
                     // hide the loader
                     [KTLoader hideLoader:TRUE];
                     
                     // the image was uploaded successfully
                     if(error == nil) {
                         
                         [KTAlert showAlert:KTAlertTypeBar
                                withMessage:@"Image uploaded!"
                                andDuration:KTAlertDurationLong];
                         
                     }
                     
                     // something bad happened...
                     else {

                         [KTAlert showAlert:KTAlertTypeBar
                                withMessage:@"Image uploaded!"
                                andDuration:KTAlertDurationLong];
                     }
                     
                 }];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    if(![KiiUser loggedIn]) {
        KTLoginViewController *lvc = [[KTLoginViewController alloc] init];
        [self presentViewController:lvc animated:TRUE completion:nil];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Upload";
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
