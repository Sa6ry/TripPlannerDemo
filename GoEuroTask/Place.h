//
//  PlaceSuggestion.h
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface Place : NSObject

// Currently we are going to expose only the fullName and the location
// If any other information is needed it should be exposed by adding
// the corsponding property

@property (nonatomic,readonly) NSString* _Nonnull fullName;
@property (nonatomic,readonly) NSString* _Nonnull fullNameFirstPart;
@property (nonatomic,readonly) NSString* _Nonnull fullNameLastPart;
@property (nonatomic,readonly) CLLocationCoordinate2D GeoPosition;

@property (nonatomic,readonly) CLLocation* _Nonnull location;

-(NSNumber* _Nonnull) distanceFromLocation:(CLLocation* _Nullable) location;

- (instancetype _Nullable) init __attribute__((unavailable("Must use initWithDictionary: instead.")));
- (instancetype _Nullable) initWithDictionary:(NSDictionary* _Nonnull)data;

@end
