//
//  JKSysLogViewController.h
//  JKFramework
//
//  Created by Jack.MT on 16/8/18.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JKLogMessage.h"

@interface JKMessageViewController : NSObject
{
        IBOutlet NSTextView     *_logShower;
}

- (void)showLogMessage:(JKLogMessage *) logMessage;
- (void)showNormalMessage:(NSString *)message;

- (void)setColor:(NSColor *)color forLevel:(MessageLevel)level;
- (NSColor *)colorOfLevel:(MessageLevel)level;

@end
