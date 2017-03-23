//
//  JKSystem.h
//  JKFramework
//
//  Created by Jack.MT on 9/27/16.
//  Copyright © 2016 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void* sighandler_t;

@interface JKSystem : NSObject

+(int) pox_system:(const char *)command;

@end
