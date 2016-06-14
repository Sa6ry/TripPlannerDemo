//
//  WebBaseAPI.m
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "WebBaseAPI.h"

@interface WebBaseAPI()
@property (nonatomic,readonly) NSURL* queryURL;
@end

@implementation WebBaseAPI

-(NSURL*) queryURL
{
    // Build the query string
    NSURLComponents *components = [NSURLComponents componentsWithString:self.jsonEndPoint];
    return components.URL;
}

-(void) getASyncWithCompletion:(void ( ^ _Nonnull )(id _Nullable data, NSError * _Nullable error))completion
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.queryURL];
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        id result = data ?[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]:nil;
        
        completion(result,error);
        
    }];
    
    [dataTask resume];
}

@end
