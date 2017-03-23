//
//  TestItem.m
//  FCT(N121)
//
//  Created by Jack.MT on 2017/3/17.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import "TestItem.h"

@implementation TestItem

- (instancetype)initWithConfig:(NSDictionary *)config
{
    self = [super init];
    if(self)
    {
        _group      = [config objectForKey:kGROUP_KEY];
        _tid        = [config objectForKey:kTID_KEY];
        _desc       = [config objectForKey:kDESCRIPTION_KEY];
        
        _low        = [config objectForKey:kLOW_KEY];
        _high       = [config objectForKey:kHIGH_KEY];
        _unit       = [config objectForKey:kUNIT_KEY];
        
        _value = @"";
        _result = RST_NONE;
        
        _enabled = YES;
        _cycleTime = -1;
    }
    
    return self;
}

@end
