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
+ (void)fetchPhotosWithPageNumber:(int)pageNumber andCompletion:(void (^)(NSArray <FlickrObject *>*, NSError *))completion {
    FlickrKit *fk = [FlickrKit sharedFlickrKit];

    [fk initializeWithAPIKey:@"92111faaf0ac50706da05a1df2e85d82" sharedSecret:@"89ded1035d7ceb3a"];

    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    interesting.per_page = @"10";
    interesting.page = [NSString stringWithFormat:@"%d", pageNumber];
    
    [fk call:interesting completion:^(NSDictionary *response, NSError *error) {
        NSMutableArray *flickrObjectArray = nil;
        if (response) {
            flickrObjectArray = [NSMutableArray array];
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {
                // Mutable dict copy to create FlickrObject from
                NSMutableDictionary *localPhotoData = [photoData mutableCopy];
                NSURL *url = [fk photoURLForSize:FKPhotoSizeMedium640 fromPhotoDictionary:photoData];
                [localPhotoData setObject:url forKey:@"url"];
                // Create FlickrObject
                FlickrObject *myObject = [[FlickrObject alloc] initWith:localPhotoData];
                if (myObject != nil) { // If not nil add to return array
                    [flickrObjectArray addObject:myObject];
                }            
            }
        }
        if (completion) {
            completion([flickrObjectArray copy], error);
        }
    }];
}

@end
