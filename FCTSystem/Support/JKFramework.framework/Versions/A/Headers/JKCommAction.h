//
//  CommAction.h
//  FCT
//
//  Created by Jack.MT on 16/7/5.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKLogMessage.h"
#import "JKTestMacro.h"

typedef NS_ENUM(NSInteger, JKACTION_TYPE)
{
    JKACTION_WRITE_AND_READ,
    JKACTION_WRITEONLY,
    JKACTION_READONLY,
    JKACTION_RW_BYTE,
    JKACTION_W_STRING_R_BYTE
};

@protocol JKTestObserverDelegate <NSObject>

- (void)showMessage:(JKLogMessage *)message;

@end

@interface JKCommAction : NSObject

///////
/**
 *function for communication.
 *the format must like "(NSString *)funcationName:(NSDictionary *)paramDic"
 */
@property(readonly) NSString              *function;
/**
 *function arguments for communication.
 *In function,the values of all funcArgs can be got by call [JKBaseDevice argForKey:(NSString *) inParamDic:(NSDictionary *)paramDic.
 */
@property(readonly) NSDictionary          *funcArgs;

/////////////
/**
* command for communication.
* if it contains string '<%bufferName>', the string will be replaced by the value with key bufferName in the buffer of AppConfig */
@property(readonly) NSString                *command;
/**
 command filled with buffer*/
@property(readonly) NSString                *realCommand;

////////////////
/**
 if the test data come from buffer, set it*/
@property(readonly) NSString              *bufferKey;

//////////////////////
/**
 Action Type of communication with command.*/
@property(readonly) JKACTION_TYPE               actionType;

- (NSString *)realCommandWithParam:(NSDictionary *) paramDic;

/**
 * parameter of read-control, indicate that read-op should stop when the endmark occured.
 * (if it starts with "Pattern:", it will be treated as a pattern for Regular-Expression)
 *if it contains string '<%bufferName>', the string will be replaced by the value with key bufferName in the buffer of AppConfig*/
@property(readonly) NSString              *endMark;
/**
 parameter of read-control, indicate timeout for op; default value is 5s;*/
@property(readonly) double                      timeout;
/**
 parameter of read-control, indicate how long after command sended; it is valid only the endMark is nil.*/
@property(readonly) double                      intervalBetweenRW;

- (instancetype)initWithParamDic:(NSDictionary *) paramDic;

- (NSString *)communicateWithDevice:(id) device withParamDic:(NSDictionary *) paramDic;

@end
