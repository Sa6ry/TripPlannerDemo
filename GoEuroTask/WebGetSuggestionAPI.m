//
//  ReviewAPI.m
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "WebGetSuggestionAPI.h"
#import "WebBaseAPI.h"
#import "Place.h"

@interface WebGetSuggestionAPI()
@property (nonatomic,retain) NSString* text;
@property (nonatomic,retain) CLLocation* userLocation;
@end

@implementation WebGetSuggestionAPI

@synthesize totalSuggestions = _totalSuggestions;
@synthesize suggestions = _suggestions;


-(instancetype _Nullable) initWithText:(NSString* _Nonnull)text location:(CLLocation* _Nullable) userLocation;
{
    self = [super init];
    if(self)
    {
        self.text = text;
        self.userLocation = userLocation;
        self.jsonEndPoint = [NSString stringWithFormat:@"https://api.goeuro.com/api/v2/position/suggest/%@/%@",[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode],text];
    }
    return self;
}

-(void) runWithCompletion:(void ( ^ _Nonnull )(WebGetSuggestionAPI * _Nullable getRequest))completion
{
    [self getASyncWithCompletion:^(id  _Nullable data, NSError * _Nullable error) {
        
        if(data && !error && [data isKindOfClass:[NSArray class]])
        {
            NSMutableArray* suggestedPlacesResult = [NSMutableArray array];
            
            // convert the result array into objects
            [data enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [suggestedPlacesResult addObject:[[Place alloc] initWithDictionary:obj]];
            }];
            
            _totalSuggestions = [data count];
            
            // We have to sort them using the user location
            _suggestions = [suggestedPlacesResult sortedArrayUsingComparator:^NSComparisonResult(Place*  _Nonnull obj1, Place*  _Nonnull obj2) {
                
                // Sort the suggestion based on current location
                return [[obj1 distanceFromLocation:self.userLocation] compare:[obj2 distanceFromLocation:self.userLocation]];
                
            }];
        }
        
        completion(self);
                   
    }];
}

@end
