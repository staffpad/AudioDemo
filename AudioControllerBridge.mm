#import "AudioControllerBridge.h"
#import "AudioController.mm"

@implementation AudioControllerBridge {
    AudioController audioController;
}

// Needs constructor

- (void)initialiseWithMeasurementMode:(BOOL)measurementMode {
    audioController.Initialize(measurementMode);
}

@end
