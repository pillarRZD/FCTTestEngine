//
//  DevStateView.m
//  FCT(B431)
//
//  Created by Jack.MT on 2/7/17.
//  Copyright © 2017 Jack.MT. All rights reserved.
//

#import "DevStateView.h"
#import <Cocoa/Cocoa.h>

#import "DevCategoryStateView.h"

@implementation DevStateView
{
    IBOutlet NSScrollView       *_scrollView;
    IBOutlet NSView             *_mainView;
    
    NSMutableDictionary         *_categorySet;
    
    float           _yLimit;
}

- (void)awakeFromNib
{
    _categorySet = [NSMutableDictionary dictionary];
    
    DevCategoryStateView *tmpView = [[DevCategoryStateView alloc] init];
    NSArray *categorySet = @[@"MainBoard", @"Fixture"];
    _mainView.frame = NSMakeRect(0, 0, NSWidth(_mainView.frame), NSHeight(tmpView.view.frame)*categorySet.count);
    _yLimit = NSHeight(_mainView.frame);
    
    for(NSString *category in categorySet)
    {
        [self loadCategory:category];
    }
}


- (void)loadCategory:(NSString *)category
{
    DevCategoryStateView *categoryView = [[DevCategoryStateView alloc] initWithCategory:category andPanelWidth:NSWidth(_mainView.frame)];
    categoryView.view.frame = NSMakeRect(0, _yLimit-NSHeight(categoryView.view.frame), NSWidth(categoryView.view.frame), NSHeight(categoryView.view.frame));
    [_mainView addSubview:categoryView.view];
    
    [_categorySet setObject:categoryView forKey:category];
    
    _yLimit -= NSHeight(categoryView.view.frame);
}

- (void)startCheck
{
    while([NSThread mainThread].isExecuting)
    {
        for(DevCategoryStateView *categoryView in _categorySet.allValues)
        {
            [categoryView checkStatus];
        }
        
        [NSThread sleepForTimeInterval:0.5];
    }
}

- (void)checkTask
{
    
}

@end
