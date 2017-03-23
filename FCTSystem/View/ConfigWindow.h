//
//  ConfigWindow.h
//  FCT(B282)
//
//  Created by Jack.MT on 16/7/19.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ConfigWindow : NSWindowController<NSWindowDelegate, NSComboBoxDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property(readonly) BOOL        appConfigChanged;
@property(readonly) BOOL        testConfigChanged;

@end
