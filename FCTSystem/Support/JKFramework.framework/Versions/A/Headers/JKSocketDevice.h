//
//  JKSocketDevice.h
//  JKFramework
//
//  Created by Jack.MT on 11/16/16.
//  Copyright © 2016 Jack.MT. All rights reserved.
//

#import <JKFramework/JKFramework.h>
#import "JKCommAction.h"

@protocol DAQProcessorDelegate <NSObject>

- (void)processData:(NSData *)daqDatas;

@end

#define kServerIPKey        @"ServerIP"
#define kServerPortKey      @"ServerPort"

@interface JKSocketDevice : JKBaseDevice<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket      *_asyncSocket;
    
    JKCommAction        *_currentAction;
    NSString            *_retValue;
    
    BOOL                _daqFlag;
    NSMutableData       *_daqDataBuffer;
    NSArray             *_daqCmdSet;
    
    NSUInteger      _tagCounter;    //消息计数器
    NSLock          *_synchLock;    //读写同步锁
    
    BOOL            _connected;     //连接标志
}

- (BOOL)isDAQCommand:(NSString *)command;

@property id<DAQProcessorDelegate>  daqDelegate;

/**
 the ip of the server.
 (you must add a node named "ServerIP" for this property in the config of the corresponding device)*/
@property NSString          *serverIP;
/**
 the port on the server.
 (you must add a node named "ServerPort" for this property in the config of the corresponding device)*/
@property NSInteger         serverPort;
/**
 the suffix of the command.
 (default value is nil, you can add a node named "CommandSuffix" for this property in the config of the corresponding device)*/
@property NSString          *commandSuffix;

@end
