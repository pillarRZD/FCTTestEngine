//
//  EngineerLogPlugin.h
//  X2AX2B
//
//  Created by hotabbit on 14-8-13.
//  Copyright (c) 2014年 hotabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
@import JKFramework;

@interface EngineerLogMudole : JKBaseDevice
{
    NSFileManager* _fileManager;
    NSString *_logPath;
}
@end
