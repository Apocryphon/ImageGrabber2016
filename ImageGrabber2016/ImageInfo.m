//
//  ImageInfo.m
//  ImageGrabber2016
//
//  Created by Richard Yeh on 9/5/16.
//  Copyright © 2016 Situation Excellent. All rights reserved.
//
//  Original Version Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "ImageInfo.h"
#import "AFURLSessionManager.h"

@implementation ImageInfo

- (void)getImage {
    NSLog(@"Getting %@...", self.sourceURL);

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.sourceURL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error downloading image: %@", error.localizedDescription);

        } else {
            NSLog(@"%@ %@", response, responseObject);
            NSLog(@"Image downloaded.");
            self.image = [[UIImage alloc] initWithData:responseObject];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"net.situationexcell.imagegrabber2016.imageupdated"
                                                                object:self];
            
        }
    }];
    [dataTask resume];

}

- (id)initWithSourceURL:(NSURL *)url {
    if (self = [super init]) {
        self.sourceURL = url;
        self.imageName = [url lastPathComponent];
        [self getImage];
    }
    return self;
}

- (id)initWithSourceURL:(NSURL *)url imageName:(NSString *)name image:(UIImage *)img {
    if (self = [super init]) {
        self.sourceURL = url;
        self.imageName = name;
        self.image = img;
    }
    return self;
}

@end
