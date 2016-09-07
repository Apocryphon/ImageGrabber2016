//
//  ImageManager.h
//  ImageGrabber2016
//
//  Created by Richard Yeh on 9/5/16.
//  Copyright © 2016 Situation Excellent. All rights reserved.
//
//  Original Version Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

@protocol ImageManagerDelegate <NSObject>
- (void)imageInfosAvailable:(NSArray *)imageInfos done:(BOOL)done;
@end

@interface ImageManager : NSObject {
    int pendingZips;
}

@property (nonatomic, strong) NSString *html;
@property (nonatomic, weak) id<ImageManagerDelegate> delegate;
@property (nonatomic, strong) dispatch_queue_t backgroundQueue;

- (id)initWithHTML:(NSString *)html delegate:(id<ImageManagerDelegate>)imgDelegate;
- (void)process;


@end
