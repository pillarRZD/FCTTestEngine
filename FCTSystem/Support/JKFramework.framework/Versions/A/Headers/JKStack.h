//
//  JKStack.h
//  JKFramework
//
//  Created by Jack.MT on 5/7/16.
//  Copyright © 2016 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKStack : NSObject

/**
 对象入栈*/
-(void)push:(id) object;
/**
 最后入栈的对象出栈*/
-(id)pop;

@end
