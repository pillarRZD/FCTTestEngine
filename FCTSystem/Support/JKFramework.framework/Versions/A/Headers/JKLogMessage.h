//
//  WorkMessage.h
//  SA-Button_Test
//
//  Created by Jack.MT on 16/2/17.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(Byte, MessageLevel)
{
    MSG_NORMAl,
    MSG_WARNING,
    MSG_ERROR
};

@interface JKLogMessage : NSObject
{
    NSString *_message;
    MessageLevel _level;
}

@property(readonly) MessageLevel level;
@property(readonly) NSString *message;
/**
 return an instance of JKLogMessage. Message Level is MSG_NORMAL    */
+ (instancetype) msgWithInfo:(NSString *) info;
/**
 return an instance of JKLogMessage. Message level assigned be level.   */
+ (instancetype) msgWithInfo:(NSString *) info withLevel:(MessageLevel) level;
- (instancetype) initWithMessage:(NSString *) message;
- (instancetype) initWithMessage:(NSString *) message withLevel:(MessageLevel) level;

@end
