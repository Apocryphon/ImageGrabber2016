//
//  ImageListViewController.h
//  ImageGrabber2016
//
//  Created by Richard Yeh on 9/5/16.
//  Copyright © 2016 Situation Excellent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageManager.h"
#import "ImageInfo.h"
#import "ImageDetailViewController.h"

@interface ImageListViewController : UITableViewController <ImageManagerDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSMutableArray *imageInfos;
@property (nonatomic, strong) ImageManager *imageManager;
@property (nonatomic, strong) NSString *html;
@property (nonatomic, strong) ImageDetailViewController *imageDetailViewController;
@end
