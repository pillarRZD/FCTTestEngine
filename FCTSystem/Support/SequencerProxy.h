//
//  SequencerProxy.h
//  FCTSystem
//
//  Created by Jack.MT on 2017/3/21.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SequencerProxy : NSObject

- (instancetype)initWithSite:(NSInteger)site;

- (void)launchSequencerAtPath:(NSString *)sequencerPath continueOnFail:(BOOL) continueOnFail;
- (void)exit;

@end
