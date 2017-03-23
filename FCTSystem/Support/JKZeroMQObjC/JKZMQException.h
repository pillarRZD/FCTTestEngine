//
//  JKZQMException.h
//  JKZeroMQObjC
//
//  Created by Jack.MT on 2017/3/8.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKZMQException : NSObject
{
    @private int _error_code;
}

- (id)initWithCode: (NSString *)aReason code:(int)errorCode;
- (void) setErrorCode:(int) error_code;
- (int) getErrorCode;

@end

