//
// Created by Dmitry on 14/03/2017.
// Copyright (c) 2017 company. All rights reserved.
//

#import "FlickrApi.h"
#import <UIKit/UIKit.h>
#import <FlickrKit/FlickrKit.h>
#import "JodelChallenge-Swift.h"

@implementation FlickrApi

// I have deliberately not implemented this in Swift.
// I did a crash course in obj c and decided that it would be a good way to get a little bit
// of obj c knowledge this way
+ (void)fetchPhotosWithPageNumber:(int)pageNumber andCompletion:(void (^)(NSArray <NSDictionary *>*, NSArray <FlickrObject *>*, NSError *))completion {
    FlickrKit *fk = [FlickrKit sharedFlickrKit];

    [fk initializeWithAPIKey:@"92111faaf0ac50706da05a1df2e85d82" sharedSecret:@"89ded1035d7ceb3a"];

    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    interesting.per_page = @"10";
    interesting.page = [NSString stringWithFormat:@"%d", pageNumber];
    
    [fk call:interesting completion:^(NSDictionary *response, NSError *error) {
        NSMutableArray *flickrObjectArray = nil;
        NSMutableArray *photoDataArray = nil;
        if (response) {
            flickrObjectArray = [NSMutableArray array];
            photoDataArray = [NSMutableArray array];
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {
                NSURL *url = [fk photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoData];
                NSMutableDictionary *localPhotoData = [photoData mutableCopy];
                [localPhotoData setObject:url forKey:@"url"];
                [photoDataArray addObject:[localPhotoData copy]];
                FlickrObject *myObject = [[FlickrObject alloc] initWith:localPhotoData];
                if (myObject != nil) {
                    [flickrObjectArray addObject:myObject];
                }            
            }
        }
        if (completion) {
            completion([photoDataArray copy], [flickrObjectArray copy], error);
        }
    }];
}

@end
