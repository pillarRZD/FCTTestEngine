/*
 *  IPSFCPost_API.h
 *  IPSFCPost
 *
 *  Created on 9/11/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */
#ifndef IPSFCPost__API__HH__
#define IPSFCPost__API__HH__

struct QRStruct {
	char * Qkey;
	char * Qval;
};


#ifdef WIN32
	#define EXPORT __declspec(dllexport)
#else
	#ifndef EXPORT
		#define EXPORT __attribute__((visibility("default")))
	#endif
#endif     //WIN32

#ifdef __OBJC__

	#import <Foundation/Foundation.h>
	/* returns version string */
	EXPORT const char * SFCLibVersion(void);
	EXPORT const char * SFCServerVersion(void);
	EXPORT const char * SFCQueryHistory(const char * acpSerialNumber);
	EXPORT const char * SFCQueryRecordUnitCheck(const char * acpSerialNumber,const char * acpStationID);
	EXPORT int SFCAddRecord(const char * acpSerialNumber,struct QRStruct *apQRStruct[],int size);
	EXPORT int SFCAddAttr(const char * acpSerialNumber,struct QRStruct *apQRStruct[],int size);
	EXPORT int SFCQueryRecord(const char * acpSerialNumber, struct QRStruct *apQRStruct[],int aiSize);
	EXPORT int SFCQueryRecordGetTestResult(const char * acpSerialNumber,const char * acpTestStationName,struct QRStruct *apQRStruct[], int size);
    EXPORT int SFCQueryRecordByStationName(const char * acpSerialNumber,const char * acpTestStationName,struct QRStruct *apQRStruct[], int size);
    EXPORT int SFCQueryRecordByStationID(const char * acpSerialNumber,const char * acpTestStationID,struct QRStruct *apQRStruct[], int size);

	EXPORT	void FreeSFCBuffer(const char * cpBuffer);

#else /* __OBJC__ */



#ifdef __cplusplus
	extern "C" {
#endif

		
	/* returns version string */
	EXPORT const char * SFCLibVersion(void);
	EXPORT const char * SFCServerVersion(void);
	EXPORT const char * SFCQueryHistory(const char * acpSerialNumber);
	EXPORT const char * SFCQueryRecordUnitCheck(const char * acpSerialNumber,const char * acpStationID);
	EXPORT int SFCAddRecord(const char * acpSerialNumber,struct QRStruct *apQRStruct[],int size);
	EXPORT int SFCAddAttr(const char * acpSerialNumber,struct QRStruct *apQRStruct[],int size);
	EXPORT int SFCQueryRecord(const char * acpSerialNumber, struct QRStruct *apQRStruct[],int aiSize);		
	EXPORT int SFCQueryRecordGetTestResult(const char * acpSerialNumber,const char * acpTestStationName,struct QRStruct *apQRStruct[], int size);
    EXPORT int SFCQueryRecordByStationName(const char * acpSerialNumber,const char * acpTestStationName,struct QRStruct *apQRStruct[], int size);
    EXPORT int SFCQueryRecordByStationID(const char * acpSerialNumber,const char * acpTestStationID,struct QRStruct *apQRStruct[], int size);

	EXPORT	void FreeSFCBuffer(const char * cpBuffer);
	

#ifdef __cplusplus
	}
#endif


#endif /* __OBJ__ */
#endif /* IPSFCPost__API__HH__ */

