//
//  UARTDevice.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/8/13.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "DUTDevice.h"
#import "AppConfig.h"

#import "WaveDisplay.h"

@implementation DUTDevice
{
    NSString        *_prompt;
}

-(instancetype)initWithConfig:(NSDictionary *)paramDic
{
    self = [super initWithConfig:paramDic];
    
    if(self)
    {
        _prompt         = [paramDic valueForKey:@"Prompt"];
    }
    
    return self;
}

- (BOOL)open
{
    BOOL isOpen = self.opened;
    if(!isOpen)
    {
        BOOL isOpen = [super open];
        if(isOpen)
        {
            [_serialPort writeString:self.cmdSuffix];
            [NSThread sleepForTimeInterval:0.01];
            [_serialPort readExsiting];
        }
    }
    
    return isOpen;
}

- (NSString *)diags:(NSArray *)args
{
    NSString *retValue = @"";
    if([self open])
    {
        retValue = [self sendCommand:args[0] withParamDic:nil];
    }
    else
    {
        retValue = @"--FAIL--cannot connect to dut";
    }
    
    return retValue;
}

- (NSString *)detect:(NSArray *)args
{
    return @"--PASS--";
}

- (NSString *)bklt:(NSArray *)args
{
    return @"--PASS--";
}

/**
 ##Value-Processor函数
 抓取FOD数据中的最小值.
 */
- (NSString *)adcMin:(NSDictionary *)paramDic
{
    NSString *orgData = [paramDic valueForKeyPath:@"VALUE"];
    NSString *procValue = orgData;
    NSError *err = nil;
    
    if(orgData)
    {
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"^[0-9]+$" options:NSRegularExpressionAnchorsMatchLines error:&err];
        NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:orgData options:0 range:NSMakeRange(0, orgData.length)];
        if(matches.count > 0)
        {
            double tmpValue;
            double minValue = [[orgData substringWithRange:matches[0].range] doubleValue];
            for(int i=1; i<matches.count; i++)
            {
                tmpValue = [[orgData substringWithRange:matches[i].range] doubleValue];
                if(tmpValue < minValue)
                {
                    minValue = tmpValue;;
                }
            }
            
            procValue = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:minValue]];
        }
    }
    
    return procValue;
}

- (void)cbWrite:(NSDictionary *)paramDic
{
    
}

@end
