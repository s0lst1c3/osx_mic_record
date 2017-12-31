//
//  main.m
//  osx_mic_record
//
//  Created by @s0lst1c3 on 12/30/17.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        if (argc != 3) {
            NSLog(@"Usage: ./osx_mic_record <time in seconds> <output file>");
            exit(1);
        }
        
        NSError *error = nil;
        NSString *output_path = [NSString stringWithFormat:@"%s", argv[2]];
        double record_time = [@(argv[1]) doubleValue];
        NSDictionary *recordSettings = [NSDictionary
								dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:AVAudioQualityMin],
                                AVEncoderAudioQualityKey,
                                [NSNumber numberWithInt:16],
                                AVEncoderBitRateKey,
                                [NSNumber numberWithInt: 2],
                                AVNumberOfChannelsKey,
                                [NSNumber numberWithFloat:44100.0],
                                AVSampleRateKey,
                                nil];

        // create an audioRecorder, bail if errors occur
        AVAudioRecorder *audioRecorder = [[AVAudioRecorder alloc]
                                initWithURL:[NSURL fileURLWithPath:output_path]
                                settings:recordSettings
                                error:&error];
        if (error) {
            NSLog(@"error: %@", [error localizedDescription]);
        }
        
        
        // prepare the audioRecorder and start recording
        [audioRecorder prepareToRecord];
        if (!audioRecorder.recording) {
            [audioRecorder record];
        }
        
        // play for record_time seconds
        NSDate *timeOut = [NSDate dateWithTimeIntervalSinceNow:record_time];
        [[NSRunLoop mainRunLoop] runUntilDate:timeOut];
        
        // stop the audioRecorder
        NSLog(@"[osx_mic_record]: Recording complete!\n");
        [audioRecorder stop];
    }
    return 0;
}

