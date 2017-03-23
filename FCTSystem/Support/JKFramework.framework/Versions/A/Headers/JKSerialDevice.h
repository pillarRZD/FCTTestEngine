//
//  JKSerialDevice.h
//  JKFramework
//
//  Created by Jack.MT on 16/8/8.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <JKFramework/JKFramework.h>


#define kSerialPortPathKey              @"DevPath"
#define kSerialPortBaudRateKey          @"BaudRate"
#define kSerialPortCommandSuffixKey     @"CmdSuffix"

#define kCOMM_W_STRING          @"W_STRING"
#define kCOMM_W_BYTE            @"W_BYTE"
#define kCOMM_R_STRING          @"R_STRING"
#define kCOMM_R_BYTE            @"R_BYTE"


@interface JKSerialDevice : JKBaseDevice<JKSerialPortConnectionChangedCallBack>
{
@protected
    NSString        *_portPath;
    JKBaudRate      _portBaudRate;
    JKSerialPort    *_serialPort;
}

/**
 default @""*/
@property NSString  *cmdSuffix;

@end
