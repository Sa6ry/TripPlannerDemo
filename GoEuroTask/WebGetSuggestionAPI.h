//
//  ReviewAPI.h
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "WebBaseAPI.h"
#import "Place.h"

@interface WebGetSuggestionAPI : WebBaseAPI

@property (nonatomic,readonly) NSUInteger totalSuggestions;
@property (nonatomic,readonly) NSArray<Place*> * _Nonnull suggestions;

- (instancetype _Nullable) init __attribute__((unavailable("Must use initWithCount: instead.")));

- (instancetype _Nullable) initWithText:(NSString* _Nonnull)text location:(CLLocation* _Nullable) userLocation;

- (void) runWithCompletion:(void ( ^ _Nonnull )(WebGetSuggestionAPI * _Nullable getRequest))completion;

@end
