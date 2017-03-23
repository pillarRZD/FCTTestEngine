//
//  RPCResponder.h
//  FCTSystem
//
//  Created by Jack.MT on 2017/3/18.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocol.h"

@interface RPCResponder : NSObject

- (instancetype)initWithIdentifier:(NSString *)identifier endpoint:(NSString *)endpoint;

- (void)startListen4Caller:(id<MessageHandlerProtocol>) caller;

- (void)close;

@end
