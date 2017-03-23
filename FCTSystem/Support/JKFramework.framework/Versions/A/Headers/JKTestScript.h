//
//  TestScript.h
//  FCT
//
//  Created by Jack.MT on 16/7/5.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKTestItem.h"

@interface JKTestScript : NSObject

@property(readonly) NSString                        *scriptPath;
/** Array of JKTestItem */
@property(readonly) NSArray                         *itemSet;

/**
 initialize the default script named 'TestScript.json'*/
- (instancetype)init;
/**
 initialize a script with name(scriptName)*/
- (instancetype) initWithScriptName:(NSString *) scriptName;

/**
 return default script named 'TestScript.json'*/
+ (instancetype) script;
/**
 return a script with name(scriptName)*/
+ (instancetype) scriptWithName:(NSString *)scripteName;

+ (JKTRESULT)runTestWithItems:(NSArray *)itemSet;

@end
