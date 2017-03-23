//
//  JKDSP.h
//  JKFramework
//
//  Created by Jack.MT on 9/19/16.
//  Copyright © 2016 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

@interface JKDSP : NSObject

+ (double)thdOfSignal:(double *)signal length:(long)lenOfSignal orderOfharmonic:(long)harmOrder baseFreq:(double)baseFreq sampleFreq:(double)sampleFreq;

+ (double)harmonicAmplitude:(long)harmonicOrder complexData:(DSPDoubleSplitComplex)complexData lenOfTimeSignal:(long)lenOfTimeSignal baseFreq:(double)baseFreq sampleFreq:(double)sampleFreq;
+ (double)harmonicFreq:(long)harmonicOrder complexData:(DSPDoubleSplitComplex)complexData lenOfTimeSignal:(long)lenOfTimeSignal baseFreq:(double)baseFreq sampleFreq:(double)sampleFreq;

+ (double)rms:(double *)signal length:(long)lenOfSignal;
+ (double)rms:(double *)signal length:(long)lenOfSignal maxFreq:(double)maxFreq sampleFreq:(double)sampleFreq;

@end
