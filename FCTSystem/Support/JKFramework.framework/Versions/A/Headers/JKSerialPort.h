//
//  JKSerialPort.h
//  JKFramework
//
//  Created by Jack.MT on 15/7/20.
//  Copyright (c) 2015年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <termios.h>
#import <sys/ioctl.h>
#import <IOKit/usb/USB.h>

@protocol JKSerialPortConnectionChangedCallBack <NSObject>

- (void)port:(nonnull NSString *)port connected:(BOOL)connected;

@end

#define SERIALPORT_MAX_BUFFER_SIZE     8196UL

/** Bardrate */
typedef NS_ENUM(NSInteger, JKBaudRate)
{
    JKBR_50 = B50,
    JKBR_75 = B75,
    JKBR_110 = B110,
    JKBR_134 = B134,
    JKBR_150 = B150,
    JKBR_300 = B300,
    JKBR_600 = B600,
    JKBR_1200 = B1200,
    JKBR_1800 = B1800,
    JKBR_2400 = B2400,
    JKBR_4800 = B4800,
    JKBR_9600 = B9600,
    JKBR_19200 = B19200,
    JKBR_38400 = B38400,
#if !defined(_POSIX_C_SOURCE) || defined(_DARWIN_C_SOURCE)
    JKBR_7200 = B7200,
    JKBR_14400 = B14400,
    JKBR_28800 = B28800,
    JKBR_57600 = B57600,
    JKBR_76800 = B76800,
    JKBR_115200 = B115200,
    JKBR_230400 = B230400,
    /*Custom*/
    JKBR_128000 = 128000,
    JKBR_256000 = 256000,
    JKBR_460800 = 460800,
    JKBR_921600 = 921600,
    JKBR_1250000 = 1250000,
    JKBR_1382400 = 1382400
#endif  /* (!_POSIX_C_SOURCE || _DARWIN_C_SOURCE) */
};

/** Databits */
typedef NS_ENUM(NSInteger, JKDataBit)
{
    JKDB_5 = CS5,
    JKDB_6 = CS6,
    JKDB_7 = CS7,
    JKDB_8 = CS8
};

/** Parity */
typedef NS_ENUM(Byte, JKParity)
{
    JKPar_NONE = 0,
    JKPar_ODD = PARENB & PARODD,
    JKPar_EVEN = JKPar_ODD & ~PARODD
};
#define JKPARITY_MARK (PARENB & PARODD);

/** flow control of io */
typedef NS_ENUM(NSInteger, JKFlowControl)
{
    JKFC_HARDWARE,
    JKFC_SOFTWARE,
    JKFC_NONE
};

/** StopBit */
typedef NS_ENUM(NSInteger, JKStopBit)
{
    JKSB_ONE = 0,
    JKSB_TWO = CSTOPB
};

/** input mode */
typedef NS_ENUM(NSInteger, JKInputMode)
{
    /** line input mode(the input data will be put in a buffer until received character '\\r' or '\\n') */
    JKIM_LINE = ICANON | ECHO | ECHOE,
    /** origin input mode(the input data will be transmit immediately with no processing) */
    JKIM_ORIGIN = ~JKIM_LINE,
};
#define JKINPUTMODE_MARK JKIM_LINE

/** An class used to operate serial port */
@interface JKSerialPort : NSObject
{
    int mFileDesriptor;
    
    NSString *mDevicePath;
    JKBaudRate mBaudRate;
    JKDataBit mDataBit;
    JKStopBit mStopBit;
    JKParity mParity;
    JKFlowControl mFlowControl;
    
    JKInputMode mInputMode;
    
    double mTimeOut;
    
    char mBuffer[SERIALPORT_MAX_BUFFER_SIZE];
}

/** path in pc system to specify the device */
@property(nullable) NSString *devicePath;
/** baud rate to communicate with device */
@property JKBaudRate baudrate;
/** data bit for communication */
@property JKDataBit dataBit;
/** stop bit for communication */
@property JKStopBit stopBit;
/** parity for communication */
@property JKParity parity;
/** flow control for communication */
@property JKFlowControl flowControl;
/** input mode */
@property JKInputMode inputMode;

/** timeout setting for communication (in seconds) */
@property double timeout;

/** sign of newline **/
@property(nullable) NSString *signOfNewLine;

/** sign of opened **/
@property(readonly) BOOL opened;

/** error infomation **/
@property(readonly, nullable) NSString *errMessage;

/** 初始化串口，指定串口名，波特率、数据位、停止位、奇偶校验位、超时时间分别默认为JKBR_9600、JKDB_8、JKSB_ONE、JKPar_NONE、2秒 */
- (nonnull instancetype)initWithDevicePath:(nonnull NSString *) devPath;
/** 初始化串口，指定串口名和波特率，数据位、停止位、奇偶校验位分别默认为JKDB_8、JKSB_ONE、JKPar_NONE、2秒 */
- (nonnull instancetype)initWithDevicePath:(nonnull NSString *)devPath andBaudRate:(JKBaudRate)baudRate;
/** 初始化串口，指定串口名、波特率、数据位、停止位、奇偶校验位、超时时间 */
- (nonnull instancetype)initWithDevicePath:(nonnull NSString *)devPath andBaudRate:(JKBaudRate)baudRate andDataBit:(JKDataBit) dataBit andStopBit:(JKStopBit)stopBit andParity:(JKParity)parity andTimeout:(double) timeout;

/** 打开串口，根据初始化设定的参数打开串口 */
- (BOOL)open;
/** 打开串口，指定串口名称，其他参数使用初始化时设定的值 */
- (BOOL)openWithDevicePath:(nonnull NSString *)devPath;
/** 打开串口，串口名称使用初始化时指定的值，并指定波特率、数据位、停止位、奇偶校验位 */
- (BOOL)openWithBaudRate:(JKBaudRate)baudRate andDataBit:(JKDataBit) dataBit andStopBit:(JKStopBit)stopBit andParity:(JKParity)parity;
/** 打开串口，指定串口名称，波特率，数据位，停止位，奇偶校验位 */
- (BOOL)openWithDevicePath:(nonnull NSString *)devPath andBaudRate:(JKBaudRate)baudRate andDataBit:(JKDataBit) dataBit andStopBit:(JKStopBit)stopBit andParity:(JKParity)parity;

/** close the port */
- (void)close;

/** 读取所有数据，返回字符串，默认编码为NSUTF8StringEncoding */
- (nullable NSString *)readExsiting;
/** 读取所有数据，返回字符串，指定转换为字符串时的编码格式 */
- (nullable NSString *)readExsitingWithEncoding:(NSStringEncoding)encoding;
/** 读取一行数据，返回字符串表示的数据，默认编码为NSUTF8StringEncoding */
- (nullable NSString *)readLine;
/** 读取一行数据，返回字符串表示的数据，指定转换为字符串时的编码格式 */
- (nullable NSString *)readLineWithEncoding:(NSStringEncoding) encoding;
/** 读取数据到读到字符c为止，返回字符串表示的数据，默认编码为NSUTF8StringEncoding */
- (nullable NSString *)readToChar:(char) c;
/** 读取数据到读到字符c为止，返回字符串表示的数据，指定转换为字符串时的编码格式 */
- (nullable NSString *)readToChar:(char) c withEncoding:(NSStringEncoding) encoding;
/** 读取数据到读到字符串endStr为止，返回字符串表示的数据，默认编码为NSUTF8StringEncoding */
- (nullable NSString *)readToString:(nonnull NSString *) endStr;
/** 读取数据到读到字符串endStr为止，返回字符串表示的数据，指定转换为字符串时的编码格式 */
- (nullable NSString *)readToString:(nonnull NSString *) endStr withEncoding:(NSStringEncoding) encoding;
/** 读取指定字节数量的数据，从缓存中由旧往新读取 */
- (int)readBytesToArray:(nonnull Byte *)bytes withCount:(int) count;
/** 读取最新的指定字节数量的数据 */
- (int)readNewestBytesToArray:(nonnull Byte *)bytes withCount:(int) count;

/** 发送字符串数据，字符串转换为字节数组的编码默认为NSUTF8StringEncoding */
- (BOOL)writeString:(nonnull NSString *)strDataToSend;
/** 发送字符串数据，指定字符串转换为字节数组的编码 */
- (BOOL)writeString:(nonnull NSString *)strDataToSend withEncoding:(NSStringEncoding)encoding;
/** 发送NSData数据 */
- (BOOL)writeData:(nonnull NSData *)data;
/** 发送字节数组数据，指定数组长度 */
- (BOOL)writeBytes:(nonnull Byte *)bytes ofCount:(unsigned long) count;

/** 发送字符串数据并读取反馈值，读写间隔由intervalInSecond指定，数据转换编码默认为NSUTF8StringEncoding */
- (nullable NSString *)writeAndReadString:(nonnull NSString *) strDataToSend withInterval:(double) intervalInSeconds;
/** 发送字符串数据并读取反馈值，读写间隔由intervalInSecond指定，数据转换编码为encoding */
- (nullable NSString *)writeAndReadString:(nonnull NSString *) strDataToSend withEncoding:(NSStringEncoding) encoding withInterval:(double) intervalInSeconds;
/** 发送字符串数据并读取反馈值，读写间隔由intervalInSecond指定，数据转换编码为encoding */
- (nullable NSData *)writeAndReadBytes:(nonnull Byte *)bytes ofCount:(int)count withInterval:(double) intervalInSeconds;

/** 所有串口路径的集合 */
+ (nonnull NSArray *)portPaths;
/** 检测串口设备是否存在 **/
+ (BOOL)checkPath:(nonnull NSString *)path;

+ (void)monitorPort:(nonnull NSString *)port forObject:(nonnull id<JKSerialPortConnectionChangedCallBack>)notifyObject;
+ (void)stopMonitorPort:(nonnull NSString *)port forObject:(nullable id<JKSerialPortConnectionChangedCallBack>)notifyObject;
+ (void)stopMonitorPort:(nonnull NSString *)port;

@end
