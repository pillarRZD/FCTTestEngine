//
//  JKCustomDevice.h
//  JKFramework
//
//  Created by Jack.MT on 2/22/17.
//  Copyright © 2017 Jack.MT. All rights reserved.
//
#import "JKBaseDevice.h"

//@interface  JKParams: NSObject
//
////@property NSArray cmdParams;
////@property 
//
//@end

#define JKPDKEY_COMMANDPARAMS   @"CommandParams"


@interface JKVirtualDevice : JKBaseDevice
{
    NSString        *_retValue;
}

@end
