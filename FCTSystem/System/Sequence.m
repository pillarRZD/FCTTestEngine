//
//  TestPlan.m
//  FCT(N121)
//
//  Created by Jack.MT on 2017/3/16.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import "Sequence.h"
#import "TestItem.h"

@implementation Sequence
{
    NSArray                 *_keys;
    NSMutableArray          *_items;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _items = [NSMutableArray array];
    }
    
    return self;
}

static Sequence     *instance;
+ (instancetype)sharedSequence
{
    @synchronized (self) {
        if(!instance)
        {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (NSArray *)items
{
    return _items;
}

- (BOOL)loadSequence:(NSString *)sequencePath
{
    NSError *err = nil;
    
    NSString *absPath = [NSString stringWithFormat:@"%@/testerconfig/%@", NSHomeDirectory(), sequencePath];
    NSString *seqData = [NSString stringWithContentsOfFile:absPath encoding:NSUTF8StringEncoding error:&err];
    if(err)
    {
        return NO;
    }
    
    _originSequencePath = absPath;
    NSArray<NSString *> *commaDatas = [seqData componentsSeparatedByString:@"\r\n"];
    NSArray *keys = [commaDatas[0] componentsSeparatedByString:@","];
    _keys = [keys copy];
    
    NSDictionary *config = nil;
    for(int i=1; i<commaDatas.count; i++)
    {
        NSMutableArray *values = [[commaDatas[i] componentsSeparatedByString:@","] mutableCopy];
        
        if(values.count != keys.count)
        {
            NSMutableArray *newValues = [NSMutableArray array];
            int startIndex=-1;
            for(int i=0; i<values.count; i++)
            {
                if([values[i] containsString:@"\""])
                {
                    if([values[i] hasPrefix:@"\""])
                    {
                        startIndex = i;
                    }
                    else
                    {
                        NSMutableString *newValue = [NSMutableString string];
                        for(int subIdx=startIndex; subIdx<i; subIdx++)
                        {
                            [newValue appendString:values[subIdx]];
                            [newValue appendString:@","];
                        }
                        [newValue appendString:values[i]];
                        [newValues addObject:newValue];
                    }
                }
                else
                {
                    [newValues addObject:values[i]];
                }
            }
            if(newValues.count == keys.count)
            {
                config = [NSDictionary dictionaryWithObjects:[newValues copy] forKeys:_keys];
            }
        }else
        {
            config = [NSDictionary dictionaryWithObjects:values forKeys:_keys];
        }
        
        TestItem *newItem = [[TestItem alloc] initWithConfig:config];
        newItem.index = i;
        [_items addObject:newItem];
    }
    return YES;
}

- (NSString *)currentSequencePath
{
    NSString *sqPath = [NSString stringWithFormat:@"/tmp/0_%@", [self.originSequencePath lastPathComponent]];
    for(TestItem *item in _items)
    {
        
    }
    
    return sqPath;
}

- (void)reset
{
    for(TestItem *item in _items)
    {
        item.value = @"";
        item.result = RST_NONE;
        item.cycleTime = -1;
    }
}

@end
