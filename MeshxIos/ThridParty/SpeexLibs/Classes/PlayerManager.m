//
//  PlayerManager.m
//  OggSpeex
//
//  Created by Jiang Chuncheng on 6/25/13.
//  Copyright (c) 2013 Sense Force. All rights reserved.
//

#import "PlayerManager.h"

@interface PlayerManager ()

- (void)startProximityMonitering;  //开启距离感应器监听(开始播放时)
- (void)stopProximityMonitering;   //关闭距离感应器监听(播放完成时)

@property (nonatomic ,strong)NSLock *lock;
@property (nonatomic ,strong)NSMutableArray *fileNameArray;

@end

@implementation PlayerManager

@synthesize decapsulator;
@synthesize avAudioPlayer;

static PlayerManager *mPlayerManager = nil;

+ (PlayerManager *)sharedManager {
    @synchronized(self) {
        if (mPlayerManager == nil)
        {
            mPlayerManager = [[PlayerManager alloc] init];
            
            [[NSNotificationCenter defaultCenter] addObserver:mPlayerManager
                                                     selector:@selector(sensorStateChange:)
                                                         name:@"UIDeviceProximityStateDidChangeNotification"
                                                       object:nil];
        }
    }
    return mPlayerManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(mPlayerManager == nil)
        {
            mPlayerManager = [super allocWithZone:zone];
            return mPlayerManager;
        }
    }
    
    return nil;
}

- (id)init {
    if (self = [super init]) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        self.lock = [[NSLock alloc] init];
        self.fileNameArray = [NSMutableArray array];
    }
    return self;
}

- (void)playAudioWithFileName:(NSString *)filename delegate:(id<PlayingDelegate>)newDelegate {
    if ( ! filename) {
        return;
    }
    [self.fileNameArray addObject:filename];
    if ([NSThread isMainThread]) {
        
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [weakSelf.lock lock];
            [weakSelf playSpxAudioWithFileName:filename delegate:newDelegate];
            [weakSelf.lock unlock];
        });
    }else{
    
        [self.lock lock];
        [self playSpxAudioWithFileName:filename delegate:newDelegate];
        [self.lock unlock];
    }
    
  
   
}



- (void)playSpxAudioWithFileName:(NSString *)filename delegate:(id<PlayingDelegate>)newDelegate{
   
    NSLog(@"=====+++++++++");
    //数组来管理播放文件路径，控制管理播放最后一个文件
    if (!self.fileNameArray.count)return;
    NSString *fileN = self.fileNameArray.lastObject;
    [self.fileNameArray removeAllObjects];
    if (![[[AVAudioSession sharedInstance] category] isEqualToString:AVAudioSessionCategoryPlayback]) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    if ([fileN rangeOfString:@".spx"].location != NSNotFound) {
        [self stopPlaying];
        self.delegate = newDelegate;
        self.decapsulator = [[Decapsulator alloc] initWithFileName:fileN];
        self.decapsulator.delegate = self;
        [self startProximityMonitering];
        [self.decapsulator play];
       
        
    }
    else if ([filename rangeOfString:@".mp3"].location != NSNotFound) {
        if ( ! [[NSFileManager defaultManager] fileExistsAtPath:fileN]) {
            NSLog(@"要播放的文件不存在:%@", fileN);
            [self playeStop];
            return;
        }
        [self playeStop];
        self.delegate = newDelegate;
        
        NSError *error;
        self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:fileN] error:&error];
        if (self.avAudioPlayer) {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            self.avAudioPlayer.delegate = self;
            [self.avAudioPlayer play];
            [self startProximityMonitering];
        }
        else {
            [self playeStop];
        }
    }
    else {
        //        [self.delegate playingStoped];
    }
}

- (void)stopPlaying {
    
//    [self stopProximityMonitering];
    if (self.decapsulator) {
        [self.decapsulator stopPlaying];
//        self.decapsulator.delegate = nil;   //此行如果放在上一行之前会导致回调问题
        self.decapsulator = nil;
        self.decapsulator.delegate = nil;
    }
    if (self.avAudioPlayer) {
        [self.avAudioPlayer stop];
        self.avAudioPlayer = nil;
        
    }
    
}

- (void)decapsulatingAndPlayingOver {
    
    [self playeStop];
    [self stopProximityMonitering];
}

- (void)playeStop{

    if ([self.delegate respondsToSelector:@selector(playingStoped)]) {
        
        if (![NSThread isMainThread]) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.delegate playingStoped];
            });
        }else{
        
             [self.delegate playingStoped];
        }
    }
}

- (void)sensorStateChange:(NSNotification *)notification {
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
//    if ([[UIDevice currentDevice] proximityState] == YES) {
//        NSLog(@"Device is close to user");
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    }
//    else {
//        NSLog(@"Device is not close to user");
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    }
}

- (void)startProximityMonitering {
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];

//    NSLog(@"开启距离监听");
}

- (void)stopProximityMonitering {

//    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    NSLog(@"关闭距离监听");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
