//
// Created by Dmitry on 14/03/2017.
// Copyright (c) 2017 company. All rights reserved.
//

#import "FlickrApi.h"
#import <UIKit/UIKit.h>
#import <FlickrKit/FlickrKit.h>

@implementation FlickrApi

+ (void)fetchPhotosWithPageNumber:(int)pageNumber andCompletion:(void (^)(NSArray <NSDictionary *>*, NSError *))completion {
    FlickrKit *fk = [FlickrKit sharedFlickrKit];

    [fk initializeWithAPIKey:@"92111faaf0ac50706da05a1df2e85d82" sharedSecret:@"89ded1035d7ceb3a"];

    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    interesting.per_page = @"10";
    interesting.page = [NSString stringWithFormat:@"%d", pageNumber];
    
    [fk call:interesting completion:^(NSDictionary *response, NSError *error) {
        NSMutableArray *photoURLs = nil;
        NSMutableArray *titles = nil;
        NSMutableArray *photoDataArray = nil;
        if (response) {
            titles = [response valueForKeyPath:@"photos.photo.title"];
            photoURLs = [NSMutableArray array];
            photoDataArray = [NSMutableArray array];
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {
                NSURL *url = [fk photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoData];
                NSMutableDictionary *localPhotoData = [photoData mutableCopy];
                if (url) {
                    [localPhotoData setObject:url forKey:@"url"];
                    [photoDataArray addObject:[localPhotoData copy]];
                    [photoURLs addObject:url];
                }
            }
        }
        if (completion) {
            completion([photoDataArray copy], error);
        }
    }];
}

@end
