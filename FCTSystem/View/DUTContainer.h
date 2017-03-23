//
//  DUTListView.h
//  FCT(B282)
//
//  Created by Jack.MT on 16/7/18.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DUTView.h"

typedef NS_ENUM(NSInteger, REFRESH_TYPE)
{
    UI_SCRIPT,
    UI_SCRIPT_DEVICE,
};

@interface DUTContainer : NSViewController<NSSplitViewDelegate>

-(void)resizeView;

- (void)disableControl;
- (void)enableControl;
- (void)runWithSnSet:(NSDictionary *)snDic;
- (void)abortTest;


- (void)selectDUTAtSite:(NSInteger) dutIndex;
/**
 the index is 1-base*/
- (void)setSerialNumber:(NSString *) serialNumber forSite:(NSInteger)site;

@property int testedDUTCount;
@property int passDUTCount;
@property int loopTimes;

@property int           enabledChangeFlag;

/**
 1-base*/
@property(nonatomic, readonly) NSArray<__kindof NSNumber *> *enabledSites;
/**
 1-base*/
@property(nonatomic, readonly) NSArray<__kindof NSNumber *> *availableDUTIndexSet;

@end
