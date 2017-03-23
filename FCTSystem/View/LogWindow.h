//
//  LogWindow.h
//  FCT(B282)
//
//  Created by Jack.MT on 16/8/3.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import JKFramework;

@interface LogWindow : NSWindowController

-(void)showLog:(JKLogMessage *) logMessage;
- (void)clear;

@end
