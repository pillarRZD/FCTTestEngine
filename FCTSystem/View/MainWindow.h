//
//  MainWindow.h
//  FCT(B282)
//
//  Created by Jack.MT on 16/7/18.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import JKFramework;
#import "DUTContainer.h"

/**
 Refresh Type
 */
typedef NS_OPTIONS(NSInteger, RefreshType)
{
    RunModeChanged          = 1<<0,
    ScriptChanged           = 1<<1,
    ConfigChanged           = 1<<2
};

@interface MainWindow : NSObject<NSWindowDelegate>

-(void)refresh:(RefreshType)type;
-(void)checkSystemState;

-(void)appDidLaunching;

@property JKLogMessage          *logMessage;

@end
