//
//  JKTestMacro.h
//  JKFramework
//
//  Created by a on 12/12/16.
//  Copyright © 2016 Jack.MT. All rights reserved.
//

#ifndef JKTestMacro_h
#define JKTestMacro_h

#define kPASS_VALUE    @"PassValue"
#define kFAIL_VALUE    @"FailValue"

/** Test Result */
typedef NS_ENUM(NSInteger, JKTRESULT)
{
    TR_FAIL,
    TR_PASS,
    TR_TESTING,
    TR_COMM_ERR,
    TR_FATAL_ERR,
    TR_ABORT4FAIL,
    TR_ABORT4OP,
    TR_NONE = NSIntegerMax
};

////  Device Macro
#define kDEVICE_NAME        @"DeviceName"
#define kDEVICE_CLASS       @"ClassName"
#define kDEVICE_BUNDLE      @"BundleName"
#define kDEVICE_REFDEVICE   @"RefDevice"

#define JKFUNCTION_DONE       @"FUNCTION_DONE"


typedef NSString* ENDACTION;
//// ACTION Macro
/**continue*/
#define ENDACTION_NONE                 @"N/A"
/**wait for confirm whether the result is pass or fail*/
#define ENDACTION_CONFIRM              @"Confirm"
/**confirm while the result is fail*/
#define ENDACTION_FAILURECONFIRM       @"Failure_Confirm"
/**stop while the result is fail*/
#define ENDACTION_FAILURESTOP          @"Failure_Stop"

//// ParamDictionary Key defination
#define JKPDKEY_DUTINDEX            @"DUTIndex"
#define JKPDKEY_SN                  @"SN"
#define JKPDKEY_ITEMSET             @"ItemSet"
#define JKPDKEY_CURRENTRESULT       @"CurrentResult"
#define JKPDKEY_PDCADEVICE          @"PDCADevice"
#define JKPDKEY_ITEM                @"Item"
#define JKPDKEY_OPERATION           @"Operation"
#define JKPDKEY_COMMACTION          @"CommAction"
#define JKPDKEY_PROCLOGPATH         @"ProcessLogPath"
#define JKPDKEY_LOGDIR              @"LogDirectory"
#define JKPDKEY_DBOBSERVER          @"DebugObserver"
#define JKPDKEY_TESTOBSERVER        @"TestObserver"
#define JKPDKEY_CURRENTDEVICE       @"CurrentDevice"

///Item Property KeyPaths
#define kITEM_ID                    @"ID"
#define kITEM_NAME                  @"ItemName"
#define kITEM_CATEGORY              @"Category"
#define kITEM_OPERATIONS            @"Operations"
#define kITEM_DATACOLLECTION        @"DataCollection"
#define kITEM_SUBITEMS              @"SubItems"
#define kITEM_DESCRIPTION           @"Description"
#define kITEM_TESTCONTROL           @"TestControl"

///DataCollection Property KeyPaths
#define kDC_DATASOURCE_INDEX        @"DataSourceIndex"
#define kDC_PDCA_ITEMNAME           @"ItemNameOnPDCA"
#define kDC_PDCA_ATTRIBUTENAME      @"AttrNameOnPDCA"

///TestControl Property KeyPaths
#define kTC_ENABLED                 @"Enabled"
#define kTC_RETESTCOUNT             @"RetestCount"
#define kTC_ENDACTION               @"EndAction"

///Operation Property KeyPaths
#define kOP_NAME                    @"Name"
#define kOP_DEVICE                  @"Device"
#define kOP_VALUEREPLACEMENT        @"ValueReplacement"
#define kOP_COMMACTION              @"CommAction"
#define kOP_VALUEPROCESSOR          @"ValueProcessor"
#define kOP_SPEC                    @"Spec"
#define kOP_BUFFERNAME              @"BufferName"
#define kOP_TESTCONTROL             @"TestControl"

///CommAction Property KeyPaths
#define kCOMMACTION_FUNC_NAME       @"Function.Name"
#define kCOMMACTION_FUNC_ARGS       @"Function.Args"
#define kCOMMACTION_CMD_ACTIONTYPE  @"ActionType"
#define kCOMMACTION_CMD_COMMAND     @"Command"
#define kCOMMACTION_CMD_ENDMARK     @"ReadControl.EndMark"
#define kCOMMACTION_CMD_TIMEOUT     @"ReadControl.Timeout"
#define kCOMMACTION_CMD_RW_INTERVAL @"IntervalBetweenRW"
#define kCOMMACTION_BUFFER_KEY      @"BufferKey"

#define kSKIPValueIdentifier            @"SKIP"


#define SuppressPerformSelectorLeakWarning(retValue, Method) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    retValue = Method; \
    _Pragma("clang diagnostic pop") \
} while (0)  




#endif /* JKTestMacro_h */
