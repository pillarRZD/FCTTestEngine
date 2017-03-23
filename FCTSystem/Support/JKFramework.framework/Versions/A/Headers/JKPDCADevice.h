//
//  JKPDCADevice.h
//  JKFramework
//
//  Created by Jack.MT on 16/8/5.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//
#import "JKVirtualDevice.h"

#define kHelpCommand                @"HELP"
#define kCheckStateCommand          @"CHECKSTATE"

@interface JKPDCADevice : JKVirtualDevice

- (BOOL)startWithSN:(NSString *) sn andTime:(time_t) startTime;
- (BOOL) endWithTime:(time_t) endTime;
- (BOOL)checkStateWithSN:(NSString *)sn;
- (void)addItem:(JKTestItem *)item withParams:(NSDictionary *) paramDic;
- (void)cancel;

@end
