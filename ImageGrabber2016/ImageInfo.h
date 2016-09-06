//
//  ImageInfo.h
//  ImageGrabber2016
//
//  Created by Richard Yeh on 9/5/16.
//  Copyright © 2016 Situation Excellent. All rights reserved.
//
//  Original Version Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageInfo : NSObject

- (id)initWithSourceURL:(NSURL *)url;
- (id)initWithSourceURL:(NSURL *)url imageName:(NSString *)name image:(UIImage *)img;

@property (nonatomic, strong) NSURL *sourceURL;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIImage *image;

@end
