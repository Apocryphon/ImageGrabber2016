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

@implementation ImageInfo

- (void)getImage {
    NSLog(@"Getting %@...", self.sourceURL);
    
    NSData *data = [NSData dataWithContentsOfURL:self.sourceURL];   // blocking approach
    if (!data) {
        NSLog(@"Error retrieving %@", self.sourceURL);
        return;
    }
    
    self.image = [[UIImage alloc] initWithData:data];
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
