//
//  JKQueue.h
//  JKFramework
//
//  Created by Jack.MT on 5/7/16.
//  Copyright © 2016 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKQueue : NSObject

/**
 object入队*/
-(void)enqueue:(id) object;
/**
 最早入队的对象出队*/
-(id)dequeue;
/**
 检测object是否在队列中 */
-(BOOL)containsObject:(id) object;
/**
 队列中对象的数量 */
-(NSInteger)count;

@end
