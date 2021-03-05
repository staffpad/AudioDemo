#pragma once
#include <AVFoundation/AVFoundation.h>
#include <mach/mach_time.h>
#include <stdlib.h>

static AudioUnit audioUnitCreate(UInt32 type, UInt32 subType)
{
  AudioComponentDescription desc = {0};
  desc.componentType = type;
  desc.componentSubType = subType;
  desc.componentManufacturer = kAudioUnitManufacturer_Apple;

  AudioComponent component = AudioComponentFindNext(NULL, &desc);
  AudioUnit audioUnit;
  OSStatus status = AudioComponentInstanceNew(component, &audioUnit);

  if (status != noErr)
    throw status;

  return audioUnit;
}

OSStatus audioRenderCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber,
                             UInt32 inNumberFrames, AudioBufferList *ioData);

static AudioStreamBasicDescription asbdWithAudioFormat(int numChannels, double sampleRate)
{
  uint32_t sampleSize = sizeof(float);

  AudioStreamBasicDescription asbd = {0};
  asbd.mFormatID = kAudioFormatLinearPCM;
  asbd.mFormatFlags = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
  asbd.mBytesPerPacket = sampleSize;
  asbd.mFramesPerPacket = 1;
  asbd.mBytesPerFrame = sampleSize;
  asbd.mBitsPerChannel = sampleSize * 8;
  asbd.mChannelsPerFrame = numChannels;
  asbd.mSampleRate = sampleRate;

  return asbd;
}

class AudioController
{
public:
  AudioController()
  {
    ioUnit = audioUnitCreate(kAudioUnitType_Output, kAudioUnitSubType_RemoteIO);
  }
  void Initialize(bool measurementMode)
  {
    AudioOutputUnitStop(ioUnit);
    AudioStreamBasicDescription preferredAsbd = asbdWithAudioFormat(2, 48000);
    OSStatus status = 0;
    if (status = AudioUnitSetProperty(ioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &preferredAsbd, sizeof(preferredAsbd));
        status != noErr)
      throw "AudioUnitSetProperty kAudioUnitProperty_StreamFormat - Failed ";

    const UInt32 inputEnabled = 1;
    if (status = AudioUnitSetProperty(ioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &inputEnabled, sizeof(inputEnabled));
        status != noErr)
      throw "AudioUnitSetProperty kAudioOutputUnitProperty_EnableIO - Failed ";

    AURenderCallbackStruct cbData;
    cbData.inputProc = audioRenderCallback;
    cbData.inputProcRefCon = this;
    if (status = AudioUnitSetProperty(ioUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Global, 0, &cbData, sizeof(cbData)); status != noErr)
      throw "AudioUnitSetProperty kAudioUnitProperty_SetRenderCallback - "
            "Failed";

    if (status = AudioUnitInitialize(ioUnit); status != noErr)
      throw "AudioUnitInitialize - Failed";

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    if (measurementMode)
      if (![audioSession setMode:AVAudioSessionModeMeasurement error:&error])
        throw "Setting measurement mode - Failed";

    if (![audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error] || ![audioSession setActive:true error:&error])
      throw "AudioSessionInitialize - Failed";
  }

private:
  AudioUnit ioUnit;
};

inline OSStatus audioRenderCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber,
                                    UInt32 inNumberFrames, AudioBufferList *ioData)
{
  // generate white noise
  for (int ch = 0; ch < ioData->mNumberBuffers; ch++)
  {
    float *ptr = (float *)ioData->mBuffers[ch].mData;
    for (int i = 0; i < inNumberFrames; i++)
      *ptr++ = ((float)rand() / RAND_MAX) * 0.5;
  }
  return 0;
}
