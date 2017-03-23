//
//  DevCategoryStateView.m
//  FCT(B431)
//
//  Created by Jack.MT on 2/7/17.
//  Copyright © 2017 Jack.MT. All rights reserved.
//

#import "DevCategoryStateView.h"

#import <Cocoa/Cocoa.h>
#import <JKFramework/JKFramework.h>

#import "AppConfig.h"

@interface DevCategoryStateView ()
{
    IBOutlet NSBox          *_categoryBox;
    IBOutlet NSView         *_devPanel;
    
    NSMutableDictionary     *_ledSet;
}

@end

@implementation DevCategoryStateView

- (instancetype)init
{
    return [self initWithCategory:@""];
}

- (instancetype)initWithCategory:(NSString *)category
{
    return [self initWithCategory:category andPanelWidth:NSWidth(self.view.frame)];
}

- (instancetype)initWithCategory:(NSString *)category andPanelWidth:(CGFloat)panelWidth
{
    self = [super init];
    if(self)
    {
        [[NSBundle mainBundle] loadNibNamed:self.className owner:self topLevelObjects:nil];
        self.devCategory = category;
        self.view.frame = NSMakeRect(NSMinX(self.view.frame), NSMinY(self.view.frame), panelWidth, NSHeight(self.view.frame));
        
        [self commInit];
    }
    
    return self;
}

- (void)commInit
{
//    _ledSet = [NSMutableDictionary dictionary];
//    
//    NSArray *nameSet = [[[JKDeviceManager sharedManager] deviceNamesWithPrefix:self.devCategory] sortedArrayUsingComparator:[JKUtility stringComparator]];
//    if(nameSet.count > 1)
//    {
//        LedWithLabel *tmpLed = [[LedWithLabel alloc] init];
//        
//        CGFloat yStartPos = (NSHeight(_devPanel.frame) - NSHeight(tmpLed.view.frame)) / 2;
//        CGFloat stepWidth = (NSWidth(_devPanel.frame)) / nameSet.count;
//        CGFloat xStartPos = (stepWidth-NSWidth(tmpLed.view.frame)) / 2;
//        CGFloat yPos = yStartPos, xPos = xStartPos;
//        
//        int idx = 1;
//        for(NSString *devName in nameSet)
//        {
//            NSString *label = [NSString stringWithFormat:@"%d", idx++];
//            LedWithLabel *led = [[LedWithLabel alloc] initWithLabel:label];
//            led.view.frame = NSMakeRect(xPos, yPos, NSWidth(led.view.frame), NSHeight(led.view.frame));
//            
//            [_devPanel addSubview:led.view];
//            [_ledSet setObject:led forKey:devName];
//            
//            xPos += stepWidth;
//        }
//    }
//    else if(nameSet.count == 1)
//    {
//        LedWithLabel *led = [[LedWithLabel alloc] init];
//        CGFloat xPos = (NSWidth(_devPanel.frame) - NSWidth(led.view.frame)) / 2;
//        CGFloat yPos = (NSHeight(_devPanel.frame) - NSHeight(led.view.frame)) / 2;;
//        led.view.frame = NSMakeRect(xPos, yPos, NSWidth(led.view.frame), NSHeight(led.view.frame));
//        
//        [_devPanel addSubview:led.view];
//        [_ledSet setObject:led forKey:self.devCategory];
//    }
}

- (void)checkStatus
{
//    NSArray *devSet = [[JKDeviceManager sharedManager] devicesWithNamePrefix:self.devCategory];
//    if(devSet.count > 0)
//    {
//        for(JKBaseDevice *dev in devSet)
//        {
//            LedWithLabel *led = [_ledSet objectForKey:dev.configName];
//            led.exsit = dev.exist;
//        }
//    }
}

- (void)setDevCategory:(NSString *)devCategory
{
    _categoryBox.title = devCategory;
}

- (NSString *)devCategory
{
    return _categoryBox.title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
