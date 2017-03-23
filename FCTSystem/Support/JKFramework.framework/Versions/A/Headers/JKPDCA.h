//
//  JKPDCA.h
//  JKFramework
//
//  Created by Jack.MT on 16/7/27.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InstantPudding_API.h"

typedef enum IP_PASSFAILRESULT          IP_TESTRESULT;

typedef enum IP_ENUM_GHSTATIONINFO      IP_ENUM_GHSTATIONINFO;
typedef enum IP_MSG_CLASS               IP_MSG_CLASS;
typedef enum IP_MSG_NUMBER              IP_MSG_NUMBER;


typedef NS_ENUM(Byte, AMIOKError)
{
    NO_ERROR = 0,
    ERROR_FERRET,
    ERROR_NO_ETHERNET,
    ERROR_NO_NETWORK,
    ERROR_BAD_SN,
    ERROR_BOBCAT_OUTPROCESS
};

@interface JKPDCA : NSObject
{
@protected
    IP_UUTHandle                UID;
    IP_API_Reply                reply;
    IP_TestSpecHandle           testSpec;
    IP_TestResultHandle         testResult;
    
    NSString* _blobDirPath;
//    NSString* blobPath;
}

@property(readonly, copy) NSString      *LastErrorStr;
@property(readwrite) int                SubLevel;
@property(readwrite) NSString           *blobDirPath;

/**
 start a PDCA session.*/
- (BOOL)startWithTime:(time_t) startTime;
/**
 cancel a PDCA session.*/
- (void)cancel;
/**
 end a PDCA session.*/
- (BOOL)stopWithTime:(time_t) stopTime;
- (NSString*)GHStationInfo:(IP_ENUM_GHSTATIONINFO) eGHStationInfo;
/**
 add serial number. it will check sn at first.  */
- (BOOL)addSerialNumber:(NSString*)sn;
/**
 check pdca state including ethernet,network,bad sn,bobcat out of process etc. it cann't be called until addSerialNumber has runned.    */
- (BOOL)amIOKay:(NSString *)sn;
/***/
- (BOOL)addBlobWithFileName:(NSString*)fileName fromLocalFilePath:(NSString*)localFilePath;

/**
 add a attribute named attrName with value attrValue;   */
- (BOOL)addAttribute:(NSString*)attrName withValue:(NSString*)attrValue;

/**
 add a test item named itemName without limits. */
- (BOOL)addItem:(NSString *)itemName
          value:(NSString *)tValue
         result:(IP_TESTRESULT)tResult
          error:(NSString *)errorInfo
       priority:(NSString *)prior;
/**
 add a test item name itemName with limits. */
- (BOOL)addItem:(NSString *)itemName
      lowerLimit:(double )lower
      upperLimit:(double )upper
           unit:(NSString *)unit
          value:(NSString *)value
         result:(IP_TESTRESULT )result
          error:(NSString *)errorInfo
       priority:(NSString *)prior;

/**
 add a test item which has no limits and contains sub-items.  */
- (BOOL)addItem:(NSString *)itemName
       subItems:(NSArray *)items
         values:(NSArray *)values
        results:(NSArray *)results
         errors:(NSArray *)errorInfoes
     priorities:(NSArray *)priorities;
/**
 add a test item which has limits and contains sub-items*/
- (BOOL) addItem:(NSString *)itemName
        subItems:(NSArray *)items
     lowerLimits:(NSArray *)lowerLimits
     upperLimits:(NSArray *)upperLimits
           units:(NSArray *)units
          values:(NSArray *)values
         results:(NSArray *)results
          errors:(NSArray *)errorInfoes
      priorities:(NSArray *)priorities;



@end
