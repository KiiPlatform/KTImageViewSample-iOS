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

#import "DownloadViewController.h"

#import <KiiSDK/Kii.h>
#import "KiiToolkit.h"

@interface DownloadViewController () {
    KTImageView *_firstImageView;
    KTImageView *_secondImageView;
}

@end

@implementation DownloadViewController

@synthesize firstImageView = _firstImageView;

- (void) showImages:(NSArray*)results
{
    
    // mix up the results so we get random-ish images each time
    NSMutableArray *shuffledResults = [NSMutableArray arrayWithArray:results];
    [shuffledResults shuffle];

    if(shuffledResults.count > 0) {
        
        // get the file object from the list
        KiiFile *file1 = [shuffledResults objectAtIndex:0];
        
        // attach the file to the KTImageView
        [_firstImageView setImageFile:file1];
        
        // start loading the image
        [_firstImageView show];
    }
    
    if(shuffledResults.count > 1) {
        
        // get the file object from the list
        KiiFile *file2 = [shuffledResults objectAtIndex:1];

        // attach the file to the KTImageView
        [_secondImageView setImageFile:file2];

        // start loading the image
        [_secondImageView show];
    }
    
}

- (IBAction)downloadNewImages:(id)sender {
    
    // clear out the current images
    _firstImageView.image = nil;
    _secondImageView.image = nil;
    
    // show a loader while we get the file list
    [KTLoader showLoader:@"Getting files..." animated:TRUE];
    
    KiiFileBucket *bucket = [[KiiUser currentUser] fileBucketWithName:FILE_BUCKET_NAME];
    
    // get new objects from the bucket
    KiiQuery *query = [KiiQuery queryWithClause:nil];
    [bucket executeQuery:query
               withBlock:^(KiiQuery *query, KiiFileBucket *bucket, NSArray *results, NSError *error) {
                   
                   // hide the loader
                   [KTLoader hideLoader:TRUE];
                   
                   // file list was received
                   if(error == nil) {
                       
                       // no objects yet
                       if(results.count == 0) {
                           
                           // tell the user they need to upload some
                           [KTAlert showAlert:KTAlertTypeBar
                                  withMessage:@"No images available yet"
                                  andDuration:KTAlertDurationLong];
                           
                       } else {
                           
                           // set up the images
                           [self showImages:results];
                       }
                       
                   }
                   
                   // an error occurred
                   else {
                       
                       // tell the user
                       [KTAlert showAlert:KTAlertTypeBar
                              withMessage:@"Error getting image list"
                              andDuration:KTAlertDurationLong];
                   }
                   
               }];
        
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Download";
        
        _secondImageView = [[KTImageView alloc] initWithFrame:CGRectMake(20, 178, 280, 150)];
        [self.view addSubview:_secondImageView];
        
    }
    return self;
}


- (void) viewDidAppear:(BOOL)animated {
    
    if(![KiiUser loggedIn]) {
        KTLoginViewController *lvc = [[KTLoginViewController alloc] init];
        [self presentViewController:lvc animated:TRUE completion:nil];
    }
    
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
