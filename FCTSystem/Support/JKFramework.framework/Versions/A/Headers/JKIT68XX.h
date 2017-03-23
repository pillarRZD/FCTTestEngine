//
//  IT68XX.h
//  JKFramework
//
//  Created by Jack.MT on 15/7/14.
//  Copyright (c) 2015年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKSerialPort.h"

#ifndef IT_SYSCHHEADER
#define IT_SYNCHHEADER 0xAA
#endif

#ifndef CMDWORD_SIZE
#define CMDWORD_SIZE 26
#endif

typedef NS_ENUM(NSInteger, IT68XXCmdWord)
{
    CW_SET_POWER_MODE = 0x20,
    CW_SET_OUT_STATE = 0x21,
    CW_SET_VOLTAGE_LIMIT = 0x22,
    CW_SET_VOLTAGE_OUT = 0x23,
    CW_SET_CURRENT_OUT = 0x24,
    CW_SET_POWER_ADDR = 0x25,
    CW_READ_ALL_STATE = 0x26,
    CW_SET_CALIB_PROTECT_STATE = 0x27,
    CW_READ_CALIB_PROTECT_STATE = 0x28,
    CW_CALIB_VOLTAGE = 0x29,
    CW_READ_VOLTAGE = 0x2A,
    CW_CALIB_CURRENT = 0x2B,
    CW_READ_CURRENT = 0x2C,
    CW_SAVE_EEPROM = 0x2D,
    CW_SET_CALIB_INFO = 0x2E,
    CW_READ_CALIB_INFO = 0x2F,
    CW_READ_PRODUCT_INFO = 0x31,
    CW_RESET_CALIB = 0x32,
    CW_SET_LOCAL_KEY = 0x37,
    CW_CHECK = 0x12
};

//电源模式
typedef NS_ENUM(Byte, PowerMode)
{
    PM_PANEL = 0,
    PM_REMOTE = 1
};

//输出状态
typedef NS_ENUM(Byte, OutState)
{
    OS_OFF = 0,
    OS_On = 1
};

//Local键使能状态
typedef NS_ENUM(Byte, LocalKeyState)
{
    LK_ENABLE = 1,
    LK_DISABLE = 0
};

//电压校准点
typedef NS_ENUM(Byte, VoltageCalibPoint)
{
    VCP_ONE = 1,
    VCP_TWO = 2,
    VCP_THREE = 3
};

//电流校准点
typedef NS_ENUM(Byte, CurrentCalibPoint)
{
    CCP_ONE = 1,
    CCP_TWO = 2
};

/** the state of current、voltage and power output */
typedef struct
{
    /** actual output current */
    double actualCurrentOut;
    /** actual output voltage */
    double actualVoltageOut;
    /** power output enable state */
    bool isOutputEnabled;
    /** power is overheated */
    bool isOverheated;
    /** output mode (1 mean CV mode， 2 means CC mode， 3 means Unregmode) */
    Byte outputMode;
    /** the speed level of fan in power(0 means that the fan doesn't work, 5 is the max level) */
    Byte speedLevelOfFan;
    /** control mode of power( 0 means panel control mode, 1 means remote control mode) */
    Byte operatonMode;
    /** setting value of output current */
    double settedCurrent;
    /** setting value of max voltage */
    double settedMaxVoltage;
    /** setting value of output voltage */
    double settedVoltageOut;
}PowerState;

/** product infomation consist of product model、 softeware version and product SN */
@interface ProductInfo : NSObject
{
    /** product model */
    NSString *mProductModel;
    /** software version */
    NSString *mSoftWareVersion;
    /** serial number of product */
    NSString *mProductSN;
};

@property NSString *productModel, *softwareVersion, *productSN;

@end


@interface JKIT68XX : NSObject
{
    JKSerialPort *mPort;
    Byte mCmdWord[26];
}

- (instancetype)initWithPortName:(NSString *) portName;
- (instancetype)initWithPortName:(NSString *) portName andPowerAddr:(Byte) powerAddr;
- (instancetype)initWithPortName:(NSString *) portName andBaudRate:(JKBaudRate) baudRate;
- (instancetype)initWithPortName:(NSString *) portName andBaudRate:(JKBaudRate) baudRate andPowerAddr:(Byte) powerAddr;

/** set control mode of power (PM_PANNEL表示面板操作模式，PM_REMOTE表示远程操作模式) */
- (void)setPowerMode:(PowerMode) mode;
/** set output state of Power(OS_OFF表示不输出， OS_ON表示输出）*/
- (void)setOutState:(OutState) state;
/** set the voltage limit */
- (void)setVoltageLimit:(double)voltageLimit;
/** set the voltage to output */
- (void)setVoltageOut:(double) voltageOut;
/** set the current to output */
- (void)setCurrentOut:(double) currentOut;
/** set new power address */
- (void)setPowerAddr:(Byte) newAddr;
/** read the state of voltage、current、power */
- (PowerState)readAllState;
/** set protection state of calibration */
- (void)protectCalibration:(bool)enabled;
/** read protectoiin state of calibration */
- (bool)isCalibrationProtected;
/** calibrate voltage */
- (void)CalibVoltage:(VoltageCalibPoint) calibPoint;
/** read output voltage(it seems to have no effect) */
- (double)readVoltageOut;
/** calibrate current */
- (void)CalibCurrent:(CurrentCalibPoint) calibPoint;
/** read current output */
- (double)readCurrentOut;
/** save the calibration data to EEPROM */
- (void)saveCalibDataToEEPROM;
/** set the calibration infomatoin of power */
- (void)setPowerCalibInfo:(Byte [])infos;
/** read the calibration infomation of power */
- (void)readPowerCalibInfo:(Byte *) infos;
/** read product infomation(Product SN, Product Model, SoftWare version) */
- (ProductInfo *)readProductInfo;
/** reset the calibration data by initial value */
- (void)resetCalibData;
/** set Local Key state */
- (void)setLocalKeyState:(LocalKeyState) lkState;
/** check Power */
- (Byte)checkPower;

- (void)close;

@end
