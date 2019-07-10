//
// Created by Dmitry on 14/03/2017.
// Copyright (c) 2017 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlickrObject;

@interface FlickrApi : NSObject

+ (void)fetchPhotosWithPageNumber:(int)pageNumber andCompletion:(nullable void (^)(NSArray <NSDictionary *>*_Nullable, NSArray <FlickrObject *>*_Nullable, NSError *_Nullable))completion;

@end
