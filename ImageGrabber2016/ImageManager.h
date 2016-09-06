//
//  ImageManager.h
//  ImageGrabber2016
//
//  Created by Richard Yeh on 9/5/16.
//  Copyright © 2016 Situation Excellent. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageManagerDelegate <NSObject>
- (void)imageInfosAvailable:(NSArray *)imageInfos done:(BOOL)done;
@end

@interface ImageManager : NSObject {
    int pendingZips;
}

@property (nonatomic, strong) NSString *html;
@property (nonatomic, weak) id<ImageManagerDelegate> delegate;

- (id)initWithHTML:(NSString *)html delegate:(id<ImageManagerDelegate>)imgDelegate;
- (void)process;


@end
