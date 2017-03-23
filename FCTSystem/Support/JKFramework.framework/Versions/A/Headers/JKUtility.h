//
//  JKUtility.h
//  JKFramework
//
//  Created by Jack.MT on 16/7/16.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Collaboration/Collaboration.h>

@interface JKUtility : NSObject

/**
 系统的所有用户(Array of CBIdentity)*/
+(NSArray *)allSystemUsers;
/**
 当前系统用户的登录名 */
+(NSString *)currentUserName;
/**
 当前系统用户的全名 */
+(NSString *)currentFullUserName;

+(BOOL)captureScreenWithBounds:(NSRect) bounds toPath:(NSString *)savePath;

/**
 字符串比较器*/
+(NSComparator)stringComparator;


/**************** 排序 ****************/
/**
 归并排序
 */
+ (void)mergeSortData:(double *)datas withLength:(NSUInteger)dataLength;

@end
