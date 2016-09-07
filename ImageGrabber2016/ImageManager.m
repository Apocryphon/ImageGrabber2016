//
//  ImageManager.m
//  ImageGrabber2016
//
//  Created by Richard Yeh on 9/5/16.
//  Copyright © 2016 Situation Excellent. All rights reserved.
//
//  Original Version Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "ImageManager.h"
#import "ImageInfo.h"
#import "ZipArchive.h"
#import "AFURLSessionManager.h"

@implementation ImageManager

- (void)processZip:(NSData *)data sourceURL:(NSURL *)sourceURL {
    
    NSLog(@"Processing zip file...");
    
    // Write file to disk
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directories objectAtIndex:0];
    NSString *zipFilePath = [documentDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
    [data writeToFile:zipFilePath atomically:YES];
    NSLog(@"Wrote to: %@", zipFilePath);
    
    // Unzip
    NSString *zipDirName = [sourceURL.lastPathComponent substringWithRange:NSMakeRange(0, sourceURL.lastPathComponent.length - sourceURL.pathExtension.length - 1)];
    NSString *zipDirPath = [documentDirectory stringByAppendingPathComponent:zipDirName];
    NSLog(@"Unzipping to %@", zipDirPath);
    
    NSError *error = nil;
    BOOL success = [SSZipArchive unzipFileAtPath:zipFilePath toDestination:zipDirPath overwrite:YES password:nil error:&error];
    if (!success) {
        NSLog(@"Failed to unzip zip");
        return;
    }
    
    // Enumerate directory
    NSArray * items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:zipDirPath error:&error];
    if (error) {
        NSLog(@"Could not enumerate %@", zipDirPath);
        return;
    }
    
    NSMutableArray *imageInfos = [NSMutableArray array];
    for (NSString *file in items) {
        if ([file.pathExtension compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
            [file.pathExtension compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            
            NSString *imagePath = [zipDirPath stringByAppendingPathComponent:file];
            UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
            NSLog(@"Found image in zip: %@", file);
            
            ImageInfo *info = [[ImageInfo alloc] initWithSourceURL:sourceURL imageName:file image:image];
            [imageInfos addObject:info];
        }
    }
    
    pendingZips--;
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.delegate imageInfosAvailable:imageInfos done:(pendingZips==0)];
    });    
}

- (void)retrieveZip:(NSURL *)sourceURL {
    
    NSLog(@"Getting %@...", sourceURL);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:sourceURL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error downloading zip file: %@", error.localizedDescription);
        } else {
            NSLog(@"Zip file downloaded.");
            NSData *data = responseObject;
            dispatch_async(self.backgroundQueue, ^(void){
                [self processZip:data sourceURL:sourceURL];
            });
        }
    }];
    [dataTask resume];

}

- (void)processHtml {
    
    NSLog(@"Processing HTML...");
    
    // Simple regex to search for links
    NSError *error = nil;
    NSString *pattern = @"(href|src)=\"([\\w:\\/\\.-]*)";
    NSLog(@"Searching HTML with pattern: %@", pattern);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return;
    }
    
    // Search for links and add to set
    NSMutableSet *linkURLs = [NSMutableSet set];
    [regex enumerateMatchesInString:self.html options:0 range:NSMakeRange(0, self.html.length-1) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSString *link = [self.html substringWithRange:[result rangeAtIndex:2]];
        NSURL *linkURL = [NSURL URLWithString:link];
        if ([linkURL.pathExtension compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
            [linkURL.pathExtension compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
            [linkURL.pathExtension compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            if ([linkURL.path length] > 0) {            // filter out blank paths with empty strings

                // add Internet Archive prefix
                NSString *archivePrefix = @"https://web.archive.org";
                NSURL *archivedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", archivePrefix, linkURL.path]];
                [linkURLs addObject:archivedURL];
            }
        }
        
    }];
    
    // Create an image info for each link (except zip)
    NSMutableArray * imageInfos = [NSMutableArray array];
    for(NSURL *linkURL in linkURLs) {
        if ([linkURL.pathExtension compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            [self retrieveZip:linkURL];
            pendingZips++;
        } else {
            ImageInfo *info = [[ImageInfo alloc] initWithSourceURL:linkURL];
            [imageInfos addObject:info];
        }
    }
    
    // Notify delegate in main thread that new image infos available
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.delegate imageInfosAvailable:imageInfos done:(pendingZips==0)];
    });
    
}

- (void)process {

    dispatch_async(self.backgroundQueue, ^(void) {
        [self processHtml];
    });

}

- (id)initWithHTML:(NSString *)html delegate:(id<ImageManagerDelegate>)imgDelegate {
    
    if (self = [super init]) {
        self.html = html;
        self.delegate = imgDelegate;
    }
    self.backgroundQueue = dispatch_queue_create("net.situationexcell.imagegrabber2016.bgqueue", NULL);
    return self;
}

@end
