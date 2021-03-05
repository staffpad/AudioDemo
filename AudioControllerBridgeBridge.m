//
//  AudioControllerBridgeBridge.m
//  AudioDemo
//
//  Created by Tom Irving on 05/03/2021.
//

#import "AudioControllerBridgeBridge.h"
#import "AudioControllerBridge.h"

@implementation AudioControllerBridgeBridge {
    AudioControllerBridge *_audioControllerBridge;
}

- (instancetype)init {
    
    if ((self = [super init])) {
        _audioControllerBridge = [AudioControllerBridge new];
    }
    
    return self;
}

- (void)initialiseWithMeasurementMode:(BOOL)measurementMode {
    [_audioControllerBridge initialiseWithMeasurementMode:measurementMode];
}

@end
