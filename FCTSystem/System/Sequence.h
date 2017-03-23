//
//  TestPlan.h
//  FCT(N121)
//
//  Created by Jack.MT on 2017/3/16.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sequence : NSObject

+ (instancetype)sharedSequence;

- (BOOL)loadSequence:(NSString *)sequencePath;
- (void)reset;

@property(readonly) NSString            *originSequencePath;
@property(readonly) NSString            *currentSequenePath;
@property(nonatomic, readonly) NSArray  *items;


@end
