//
//  WebBaseAPI.h
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebBaseAPI : NSObject

@property (nonatomic,retain) NSString* _Nonnull jsonEndPoint;

-(void) getASyncWithCompletion:(void ( ^ _Nonnull )(id _Nullable data, NSError * _Nullable error))completion;

@end
