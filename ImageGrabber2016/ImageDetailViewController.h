//
//  ImageDetailViewController.h
//  ImageGrabber2016
//
//  Created by Richard Yeh on 9/5/16.
//  Copyright © 2016 Situation Excellent. All rights reserved.
//
//  Original Version Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageInfo.h"

@interface ImageDetailViewController : UIViewController

@property (nonatomic, strong) ImageInfo *info;
@property (nonatomic, strong) UIImageView *imageView;

@end
