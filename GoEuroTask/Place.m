//
//  PlaceSuggestion.m
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "Place.h"

@interface Place()
@property (nonatomic,retain) NSDictionary* data;
@end

@implementation Place

-(id) initWithDictionary:(NSDictionary*)data
{
    self = [super init];
    if(self)
    {
        self.data = data;
    }
    return self;
}

-(NSString*) fullName
{
    return self.data[@"fullName"];
}

// fullName is being represnted as comma sperated City, Country. return the city part
-(NSString*) fullNameFirstPart
{
    return  [[self.fullName componentsSeparatedByString:@","].firstObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

// fullName is being represnted as comma sperated City, Country. return the country part
-(NSString*) fullNameLastPart
{
    return  [[self.fullName componentsSeparatedByString:@","].lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


-(CLLocationCoordinate2D) GeoPosition
{
    CLLocationCoordinate2D res = { [self.data[@"geo_position"][@"latitude"] doubleValue],
        [self.data[@"geo_position"][@"longitude"] doubleValue]};
    return res;
}

-(CLLocation*) location
{
    return [[CLLocation alloc] initWithLatitude:self.GeoPosition.latitude longitude:self.GeoPosition.longitude];
}

-(NSNumber*) distanceFromLocation:(CLLocation*) location
{
    return @([self.location distanceFromLocation:location]);
}

-(NSString*) description
{
    return [self.data description];
}
@end
