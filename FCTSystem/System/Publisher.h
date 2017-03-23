//
//  Publisher.h
//  FCTSystem
//
//  Created by Jack.MT on 2017/3/18.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocol.h"


@interface Publisher : NSObject

- (instancetype)initWithIdentifier:(NSString *)identifier endpoint:(NSString *)endpoint;

- (void)publish:(NSString *)info;
- (void)publish:(NSString *)info level:(PublisherLevel)level;
- (void)publish:(NSString *)info idPostfix:(NSString *)id_postfix level:(PublisherLevel)level;

- (void)close;

@property(readonly) NSString            *identifier;

@end
