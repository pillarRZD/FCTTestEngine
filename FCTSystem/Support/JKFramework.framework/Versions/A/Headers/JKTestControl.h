//
//  TestControl.h
//  Test
//
//  Created by Jack.MT on 16/7/7.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef JKTestMacro_h
#import "JKTestMacro.h"
#endif

@interface JKTestControl : NSObject

@property(readonly) BOOL            enabled;
@property(readonly) int             retestCount;

@property(readonly) ENDACTION       endAction;

@property NSArray<NSString *>                       *supportedRunModes;

@property(readonly) NSArray<ENDACTION>              *selectableEndActionSet;

- (instancetype)initWithParamDic:(NSDictionary *)paramDic;

@end
