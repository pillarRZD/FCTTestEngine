//
//  RPCServer.h
//  FCTSystem
//
//  Created by Jack.MT on 2017/3/18.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPCRequester : NSObject

- (instancetype)initWithIdentifier:(NSString *)identifier endpoint:(NSString *)endpoint;

- (void)send:(NSString *)method;
- (void)send:(NSString *)method args:(NSArray *)args;
- (void)send:(NSString *)method args:(NSArray *)args kwArgs:(NSArray *)kwArgs;
- (NSString *)receive;
- (NSString *)receiveWithFlags:(int)flags;

- (void)close;

- (NSString *)state;

@end
