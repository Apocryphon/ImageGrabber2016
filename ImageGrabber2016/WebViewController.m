//
//  WebViewController.m
//  ImageGrabber2016
//
//  Created by Richard Yeh on 9/5/16.
//  Copyright © 2016 Situation Excellent. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"Image Grabber 2016";
    NSURL *url = [NSURL URLWithString:@"https://web.archive.org/web/20110925181822/http://www.vickiwenderlich.com/2011/06/game-art-pack-monkey-platformer/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.grabButton.enabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    numLoads++;
    self.grabButton.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    numLoads--;
    if (numLoads > 0) {
        self.grabButton.enabled = YES;
    }
}

- (IBAction)grabTapped:(id)sender {
    
    // fetch HTML from webview
    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
    // give HTML to list view for retrieval and display
    if (self.imageListViewController == nil) {
        self.imageListViewController = [[ImageListViewController alloc] init];
    }

    self.imageListViewController.html = html;
    [self.navigationController pushViewController:self.imageListViewController animated:YES];

}

@end
