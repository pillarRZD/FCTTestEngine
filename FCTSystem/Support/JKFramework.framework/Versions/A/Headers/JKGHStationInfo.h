//
//  JKGHStationInfo.h
//  JKFramework
//
//  Created by Jack.MT on 16/6/29.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

/*** ghinfo node ***/
#define GH_KEYPATH_SITE                                     @"ghinfo.SITE"
#define GH_KEYPATH_PRODUCT                                  @"ghinfo.PRODUCT"
#define GH_KEYPATH_BUILD_STAGE                              @"ghinfo.BUILD_STAGE"
#define GH_KEYPATH_BUILD_SUBSTAGE                           @"ghinfo.BUILD_SUBSTAGE"
#define GH_KEYPATH_REMOTE_ADDR                              @"ghinfo.REMOTE_ADDR"
#define GH_KEYPATH_LOCATION                                 @"ghinfo.LOCATION"
#define GH_KEYPATH_LINE_NUMBER                              @"ghinfo.LINE_NUMBER"
#define GH_KEYPATH_LINE_ID                                  @"ghinfo.LINE_ID"
#define GH_KEYPATH_LINE_NAME                                @"ghinfo.LINE_NAME"
#define GH_KEYPATH_LINE_TYPE                                @"ghinfo.LINE_TYPE"
#define GH_KEYPATH_LINE_MANAGER_IP                          @"ghinfo.LINE_MANAGER_IP"
#define GH_KEYPATH_STATION_NUMBER                           @"ghinfo.STATION_NUMBER"
#define GH_KEYPATH_STATION_TYPE                             @"ghinfo.STATION_TYPE"
#define GH_KEYPATH_DEPARTMENT                               @"ghinfo.DEPARTMENT"
#define GH_KEYPATH_STATION_TYPE_DISPLAY                     @"ghinfo.STATION_TYPE_DISPLAY"
#define GH_KEYPATH_SCREEN_COLOR                             @"ghinfo.SCREEN_COLOR"
#define GH_KEYPATH_STATION_IP                               @"ghinfo.STATION_IP"
#define GH_KEYPATH_DCS_IP                                   @"ghinfo.DCS_IP"
#define GH_KEYPATH_PDCA_IP                                  @"ghinfo.PDCA_IP"
#define GH_KEYPATH_KOMODO_IP                                @"ghinfo.KOMODO_IP"
#define GH_KEYPATH_ACTIVATION_IP                            @"ghinfo.ACTIVATION_IP"
#define GH_KEYPATH_NTP_IP                                   @"ghinfo.NTP_IP"
#define GH_KEYPATH_SPIDERCAB_IP                             @"ghinfo.SPIDERCAB_IP"
#define GH_KEYPATH_FUSING_IP                                @"ghinfo.FUSING_IP"
#define GH_KEYPATH_DROPBOX_IP                               @"ghinfo.DROPBOX_IP"
#define GH_KEYPATH_DEMO_IP                                  @"ghinfo.DEMO_IP"
#define GH_KEYPATH_SFC_IP                                   @"ghinfo.SFC_IP"
#define GH_KEYPATH_SFC_URL                                  @"ghinfo.SFC_URL"
#define GH_KEYPATH_PROV_IP                                  @"ghinfo.PROV_IP"
#define GH_KEYPATH_RAT_IP                                   @"ghinfo.RAT_IP"
#define GH_KEYPATH_ALDER_IP                                 @"ghinfo.ALDER_IP"
#define GH_KEYPATH_JMETDS_IP                                @"ghinfo.JMETDS_IP"
#define GH_KEYPATH_MARINA_IP                                @"ghinfo.MARINA_IP"
#define GH_KEYPATH_LINECONTROLLER_IP                        @"ghinfo.LINECONTROLLER_IP"
#define GH_KEYPATH_MATCHMAKER_IP                            @"ghinfo.MATCHMAKER_IP"
#define GH_KEYPATH_DATE_TIME                                @"ghinfo.DATE_TIME"
#define GH_KEYPATH_TIMESTAMP                                @"ghinfo.TIMESTAMP"
#define GH_KEYPATH_STATION_ID                               @"ghinfo.STATION_ID"
#define GH_KEYPATH_URI_CONFIG_PATH                          @"ghinfo.URI_CONFIG_PATH"
#define GH_KEYPATH_GROUNDHOG_IP                             @"ghinfo.GROUNDHOG_IP"
#define GH_KEYPATH_MAC_ADDR                                 @"ghinfo.MAC"
#define GH_KEYPATH_GHLS_VERSION                             @"ghinfo.GHLS_VERSION"
#define GH_KEYPATH_SAVE_BRICKS_ENABLED                      @"ghinfo.SAVE_BRICKS"
#define GH_KEYPATH_LOCAL_CSV_ENABLED                        @"ghinfo.LOCAL_CSV"
#define GH_KEYPATH_REALTIME_PARAMETRIC_ENABLED              @"ghinfo.REALTIME_PARAMTRIC"
#define GH_KEYPATH_SINGLE_CSV_UUT_ENABLED                   @"ghinfo.SIGNLE_CSV_UUT"
#define GH_KEYPATH_BOBCAT_DIRECT_ENABLED                    @"ghinfo.BOBCAT_DIRECT"
#define GH_KEYPATH_RAT_DIRECT_ENABLED                       @"ghinfo.RAT_DIRECT"
#define GH_KEYPATH_FIREWALL_ENABLED                         @"ghinfo.FIREWALL"
#define GH_KEYPATH_RAFT_LINE_ENABLED                        @"ghinfo.RAFT_LINE"
#define GH_KEYPATH_USB_STORAGE_ENABLED                      @"ghinfo.USB_STORAGE"
#define GH_KEYPATH_GDADMIN_ENABLED                          @"ghinfo.GDADMIN"
#define GH_KEYPATH_CONTROL_RUN_ENABLED                      @"ghinfo.CONTROL_RUN"
#define GH_KEYPATH_CONTROL_RUN_CB_ENABLED                   @"ghinfo.CONTROL_RUN_CB"
#define GH_KEYPATH_SEND_BLOBS_ON_FAIL_ONLY                  @"ghinfo.SEND_BLOBS_ON_FAIL_ONLY"
#define GH_KEYPATH_SEND_BLOBS_ON                            @"ghinfo.SEND_BLOBS_ON"
#define GH_KEYPATH_SFC_QUERY_UNIT_ON_OFF                    @"ghinfo.SFC_QUERY_UNIT_ON_OFF"
#define GH_KEYPATH_STATION_SET_CONTROL_BIT_ON_OFF           @"ghinfo.STATION_SET_CONTROL_BIT_ON_OFF"
#define GH_KEYPATH_CONTROL_BITS_TO_CHECK_ON_OFF             @"ghinfo.CONTROL_BITS_TO_CHECK_ON_OFF"
#define GH_KEYPATH_FDR_TO_CHECK_ON_OFF                      @"ghinfo.FDR_TO_CHECK_ON_OFF"
#define GH_KEYPATH_CONTROL_BITS_TO_CLEAR_ON_PASS_ON_OFF     @"ghinfo.CONTROL_BITS_TO_CLEAR_ON_PASS_ON_OFF"
#define GH_KEYPATH_CONTROL_BITS_TO_CLEAR_ON_FAIL_ON_OFF     @"ghinfo.CONTROL_BITS_TO_CLEAR_ON_FAIL_ON_OFF"
#define GH_KEYPATH_SFC_TIMEOUT                              @"ghinfo.SFC_TIMEOUT"
#define GH_KEYPATH_FERRET_NOT_RUNNING_TIMEOUT               @"ghinfo.ERRET_NOT_RUNNING_TIMEOUT"
#define GH_KEYPATH_NETWORK_NOT_OK_TIMEOUT                   @"ghinfo.NETWORK_NOT_OK_TIMEOUT"
#define GH_KEYPATH_GHSI_LASTUPDATE_TIMEOUT                  @"ghinfo.GHSI_LASTUPDATE_TIMEOUT"
#define GH_KEYPATH_FERRET_TIMEOUT                           @"ghinfo.FERRET_TIMEOUT"
#define GH_KEYPATH_TIME_NOT_OK_TIMEOUT                      @"ghinfo.TIME_NOT_OK_TIMEOUT"
#define GH_KEYPATH_MAX_PDATA_TESTS_ALLOWED                  @"ghinfo.MAX_PDATA_TESTS_ALLOWED"
#define GH_KEYPATH_MAX_BLOB_SIZE_ALLOWED_IN_BYTES           @"ghinfo.MAX_BLOB_SIZE_ALLOWED_IN_BYTES"
#define GH_KEYPATH_SIGNATURE_EXPIRATION                     @"ghinfo.SIGNATURE_EXPIRATION"
#define GH_KEYPATH_SIGNATURE_VERSION                        @"ghinfo.SIGNATURE_VERSION"
#define GH_KEYPATH_TIMEZONE                                 @"ghinfo.TIMEZONE"
#define GH_KEYPATH_FDRUCA_IP                                @"ghinfo.FDRUCA_IP"
#define GH_KEYPATH_FDRDS_IP                                 @"ghinfo.FDRDS_IP"
#define GH_KEYPATH_FDRUSS_IP                                @"ghinfo.FDRUSS_IP"
#define GH_KEYPATH_FDR_REGISTRATION                         @"ghinfo.FDR_REGISTRATION"
#define GH_KEYPATH_GH_STATION_NAME                          @"ghinfo.GH_STATION_NAME"
#define GH_KEYPATH_GROUNDHOG_NAT_IP                         @"ghinfo.GROUNDHOG_NAT_IP"
#define GH_KEYPATH_LAST_RESTORED                            @"ghinfo.LAST_RESTORED"
#define GH_KEYPATH_GROUNDHOG_STARTED                        @"ghinfo.GROUNDHOG_STARTED"
#define GH_KEYPATH_LIVE_VERSION                             @"ghinfo.LIVE_VERSION"
#define GH_KEYPATH_LIVE_CURRENT                             @"ghinfo.LIVE_CURRENT"
#define GH_KEYPATH_LIVE_VERSION_PATH                        @"ghinfo.LIVE_VERSION_PATH"
#define GH_KEYPATH_STATION_OVERLAY                          @"ghinfo.STATION_OVERLAY"
#define GH_KEYPATH_STATION_OSX_IMAGE                        @"ghinfo.STATION_OSX_IMAGE"
#define GH_KEYPATH_STATION_BASE_OVERLAY                     @"ghinfo.STATION_BASE_OVERLAY"
#define GH_KEYPATH_STATION_CORE_OVERLAY                     @"ghinfo.STATION_CORE_OVERLAY"
#define GH_KEYPATH_STATION_SUPPLEMENTAL_OVERLAY             @"ghinfo.STATION_SUPPLEMENTAL_OVERLAY"
#define GH_KEYPATH_STATION_FDR_OVERLAY                      @"ghinfo.STATION_FDR_OVERLAY"
#define GH_KEYPATH_SYSTME_MESSAGE                           @"ghinfo.system_message"
/*** ghinfo node ***/

/*** parachute node ***/
#define GH_KEYPATH_IP_MSG_ERROR_NETWORT_NOT_RESPONDING      @"parachute.IP_MSG_ERROR_NETWORK_NOT_RESPONDING"
#define GH_KEYPATH_IP_MSG_ERROR_ETHERNET_NOT_RESPONDING     @"parachute.IP_MSG_ERROR_ETHERNET_NOT_RESPONDING"
#define GH_KEYPATH_IP_MSG_ERROR_INVALID_STATION_TYPE        @"parachute.IP_MSG_ERROR_INVALID_STATION_TYPE"
#define GH_KEYPATH_IP_MSG_ERROR_INVALID_SW_VERSION          @"parachute.IP_MSG_ERROR_INVALID_SW_VERSION"
#define GH_KEYPATH_IP_MSG_ERROR_INVALID_IP_VERSION          @"parachute.IP_MSG_ERROR_INVALID_IP_VERSION"
#define GH_KEYPATH_IP_MSG_ERROR_INVALID_FERRET_VERSION      @"parachute.IP_MSG_ERROR_INVALID_FERRET_VERSION"
#define GH_KEYPATH_IP_MSG_ERROR_FERRET_NOT_RUNNING          @"parachute.IP_MSG_ERROR_FERRET_NOT_RUNNING"
#define GH_KEYPATH_IP_MSG_ERROR_DCS_NOT_RESPONDING          @"parachute.IP_MSG_ERROR_DCS_NOT_RESPONDING"
#define GH_KEYPATH_IP_MSG_ERROR_PDCA_NOT_RESPONDING         @"parachute.IP_MSG_ERROR_PDCA_NOT_RESPONDING"
#define GH_KEYPATH_IP_MSG_ERROR_SFC_QUERY_UNIT              @"parachute.IP_MSG_ERROR_SFC_QUERY_UNIT"
#define GH_KEYPATH_IP_MSG_ERROR_INVALID_SERIAL_NUMBER       @"parachute.IP_MSG_ERROR_INVALID_SERIAL_NUMBER"
#define GH_KEYPATH_IP_MSG_ERROR_API_UNHANDLED               @"parachute.IP_MSG_ERROR_API_UNHANDLED"
#define GH_KEYPATH_IP_MSG_ERROR_API_SYNTAX                  @"parachute.IP_MSG_ERROR_API_SYNTAX"
#define GH_KEYPATH_IP_MSG_ERROR_FILESYSTEM                  @"parachute.IP_MSG_ERROR_FILESYSTEM"
#define GH_KEYPATH_IP_MSG_ERROR_UNIT_OUT_OF_PROCESS         @"parachute.IP_MSG_ERROR_UNIT_OUT_OF_PROCESS"
#define GH_KEYPATH_IP_MSG_ERROR_INVALID_DATA_FORMAT         @"parachute.IP_MSG_ERROR_INVALID_DATA_FORMAT"
#define GH_KEYPATH_IP_MSG_ERROR_INVALID_SIGNATURE           @"parachute.IP_MSG_ERROR_INVALID_SIGNATURE"
#define GH_KEYPATH_IP_MSG_ERROR_TIMESERVER_NOT_RESPONDING   @"parachute.IP_MSG_ERROR_TIMESERVER_NOT_RESPONDING"
/*** parachute node ***/

/*** attr_dictionary ***/
#define GH_KEYPATH_ATTRIBUTE_ARRAY                          @"attr_dictionary"
//key for every attribute
#define ATTRIBUTE_KEY_ATTR_NAME                             @"attr_name"
#define ATTRIBUTE_KEY_ATTR_TYPE                             @"attr_type"
#define ATTRIBUTE_KEY_BOBCAT_ALIAS                          @"bobcat_alias"
#define ATTRIBUTE_KEY_TYPE                                  @"type"
#define ATTRIBUTE_KEY_LENGTH                                @"length"
//#define G
/*** attr_dictionary ***/

/*** controlbits node ***/
#define GH_KEYPATH_CB_VERSION                               @"controlbits.version"
#define GH_KEYPATH_CB_TO_CHECK                              @"controlbits.CONTROL_BITS_TO_CHECK"
#define GH_KEYPATH_CB_TO_CLEAR_ON_PASS                      @"controlbits.CONTROL_BITS_TO_CLEAR_ON_PASS"
#define GH_KEYPATH_CB_TO_CLEAR_ON_FAIL                      @"controlbits.CONTROL_BITS_TO_CLEAR_ON_FAIL"
#define GH_KEYPATH_CB_STATION_NAMES                         @"controlbits.CONTROL_BITS_STATION_NAMES"
#define GH_KEYPATH_CB_STATION_FAIL_COUNT_ALLOWED            @"controlbits.STATION_FAIL_COUNT_ALLOWED"
/*** controlbits node ***/

/*** othe node ***/
#define GH_KEYPATH_SIGNATURE                                @"signature"
#define GH_KEYPATH_DIGEST                                   @"digest"
/*** othe node ***/


/**
 An class used to read infomation from GroundHog station config file(/vault/data_collection/test_station_config/gh_station_info.json) */
@interface JKGHStationInfo : NSObject

+ (instancetype)sharedInfo;

/**
 get value at special keyPath */
- (id)valueForKeyPath:(NSString *)keyPath;

/**
 get all attribute names */
- (NSArray*)attrNames;
/**
 get all all aliases of all attribute in bobcat */
- (NSArray*)bobcatAliases;


@end
