//
//  JKLog.h
//  JKFramework
//
//  Created by Jack.MT on 15/7/22.
//  Copyright (c) 2015年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKLog : NSObject
{
    NSString *mFilePath;
    
    NSFileHandle *mFileHandle;
}

/** init a JKLog object and indicate the path of log */
- (instancetype) initWithPath:(NSString *)filePath;
/** write normal string message */
- (BOOL)writeMessage:(NSString *) message;
/** record the message for a exception obj. */
- (BOOL)writeException:(NSException *) ex;

+ (instancetype)logWithPath:(NSString *)filePath;

+ (BOOL)writeMessage:(NSString *)message toFile:(NSString *)filePath;

@end

@interface NSException (JKException)

/** a external method for NSException used in the method named "writeException:ex" of JKException */
- (NSString *)simpleInformation;

@end
