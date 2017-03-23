//
//  SumaryLogPlugin.h
//  X2AX2B
//
//  Created by hotabbit on 14-8-5.
//  Copyright (c) 2014年 hotabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
@import JKFramework;

#define DIR_DATA_LOG @"/vault/FCT(MT)/Data_Log";

@interface CSVLogDevice : JKBaseDevice
//- (void)initializeWithParameters:(NSArray *)parameters;

-(void)storageDataWithParams:(NSDictionary *) paramDic;
-(void)cancel;
@end
