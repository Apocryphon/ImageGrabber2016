//
//  WebViewController.h
//  ImageGrabber2016
//
//  Created by Richard Yeh on 9/5/16.
//  Copyright © 2016 Situation Excellent. All rights reserved.
//
//  Original Version Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageListViewController.h"

@interface WebViewController : UIViewController <UIWebViewDelegate> {
    int numLoads;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *grabButton;
- (IBAction)grabTapped:(id)sender;

@property (retain) ImageListViewController *imageListViewController;

@end

