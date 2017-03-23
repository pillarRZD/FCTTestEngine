//
//  JKTimer.h
//  JKFramework
//
//  Created by Jack.MT on 15/7/22.
//  Copyright (c) 2015年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/time.h>
#import <time.h>

typedef void (^loop_block)(id);

/** An timer.*/
@interface JKTimer : NSObject
{
    struct timeval tv;
    uint64_t tStart;
    uint64_t tEnd;
}

/**
 return an instance of JKTimer;*/
+(instancetype)timer;

/** start to time. Actually, it just do that set current time as the start-time;*/
-(void) start;
/** duration from start-time.*/
-(double) durationInSecond;

@end
