//
//  KinconyRelay.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/3.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "KinconyRelay.h"
#import "KinconySocketManager.h"
#import "KinconyDevice.h"
#import "KinconySceneManager.h"

NSString * const KinconyDeviceStateNotification = @"KinconyDeviceStateNotification";

@interface KinconyRelay()

@property (nonatomic, copy) DeviceAddResultBlock deviceAddResultBlock;

@end

@implementation KinconyRelay

- (id)init {
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readData:) name:KinconySocketReadDataNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidConnect:) name:KinconySocketDidConnectNotification object:nil];
        self.deviceAddResultBlock = nil;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public methods

- (void)addDevice:(NSString*)ipAddress withPort:(NSInteger)port withBlock:(DeviceAddResultBlock)block {
    self.deviceAddResultBlock = block;
    
    if ([[KinconyDeviceManager sharedManager] findDeviceByIp:ipAddress] != nil) {
        self.deviceAddResultBlock([NSError errorWithDomain:@"" code:DeviceAddErrorCode_AlreadyExists userInfo:nil]);
        self.deviceAddResultBlock = nil;
        return;
    }
    
    KinconyDevice *device = [[KinconyDevice alloc] init];
    device.ipAddress = ipAddress;
    device.port = port;
    [[KinconySocketManager sharedManager] connectToDevice:@[device]];
}

- (void)connectAllDevices {
    [[KinconySocketManager sharedManager] connectToDevice:[[KinconyDeviceManager sharedManager] getAllConnectDevice]];
}

- (NSArray*)getAllConnectDevice {
    return [[KinconyDeviceManager sharedManager] getAllConnectDevice];
}

- (RLMResults*)getAllDevices {
    return [[KinconyDeviceManager sharedManager] getAllDevice];
}

- (void)changeDeviceState:(BOOL)on device:(KinconyDeviceRLMObject*)device {
    KinconyDevice *connectDevice = [[KinconyDevice alloc] init];
    connectDevice.ipAddress = device.ipAddress;
    connectDevice.port = device.port;
    NSString *commandStr = [NSString stringWithFormat:@"RELAY-SET-1,%@,%d", device.num, on];
    [[KinconySocketManager sharedManager] sendData:commandStr toDevice:connectDevice];
}

- (void)exchangeDevicesIndex:(NSMutableArray *)devices {
    NSMutableArray *newDevices = [[NSMutableArray alloc] init];
    for (KinconyDeviceRLMObject *oldDevice in devices) {
        KinconyDeviceRLMObject *device = [[KinconyDeviceRLMObject alloc] init];
        device.deviceId = oldDevice.deviceId;
        device.ipAddress = oldDevice.ipAddress;
        device.port = oldDevice.port;
        device.type = oldDevice.type;
        device.num = oldDevice.num;
        device.name = oldDevice.name;
        device.image = oldDevice.image;
        [newDevices addObject:device];
    }
    [[KinconyDeviceManager sharedManager] deleteAllDevice];
    [[KinconyDeviceManager sharedManager] addDevices:newDevices];
}

- (void)editDevice:(KinconyDeviceRLMObject*)device name:(NSString*)name deviceImageName:(NSString*)imageName deviceTouchImageName:(NSString*)touchImageName controlMode:(NSInteger)controlModel {
    [[KinconyDeviceManager sharedManager] editDevice:device name:name deviceImageName:imageName deviceTouchImageName:touchImageName controlMode:controlModel];
}

- (void)deleteDevice:(KinconyDevice *)device {
    [[KinconyDeviceManager sharedManager] deleteDevice:device];
}

- (void)searchDevicesState {
    NSArray *devices = [[KinconyDeviceManager sharedManager] getAllConnectDevice];
    for (KinconyDevice *device in devices) {
        [[KinconySocketManager sharedManager] sendData:@"RELAY-STATE-1" toDevice:device];
    }
}

- (void)saveScene:(KinconySceneRLMObject *)scene {
    [[KinconySceneManager sharedManager] saveScene:scene];
}

- (RLMResults*)getSceces {
    return [[KinconySceneManager sharedManager] getScenes];
}

- (void)deleteScene:(KinconySceneRLMObject*)scene {
    [[KinconySceneManager sharedManager] deleteScene:scene];
}

- (void)sceneCommand:(KinconySceneRLMObject*)scene {
    for (KinconySceneDeviceRLMObject *sceneDevice in scene.sceneDevices) {
        BOOL isOn = sceneDevice.state;
        [self changeDeviceState:isOn device:sceneDevice.device];
    }
}

#pragma mark - notifications

- (void)readData:(NSNotification*)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *text = [dic objectForKey:@"data"];
    NSString *ipAddress = [dic objectForKey:@"ipAddress"];
    NSInteger port = [[dic objectForKey:@"port"] integerValue];
    NSLog(@"read data:%@", text);
    
    NSArray *dataArray = [text componentsSeparatedByString:@","];
    NSString *stateStr = dataArray.lastObject;
    if ([stateStr isEqualToString:@"OK"]) {
        if ([dataArray.firstObject isEqualToString:@"RELAY-SCAN_DEVICE-CHANNEL_8"]) {
            NSError *error = [[KinconyDeviceManager sharedManager] addDevice:8 withIp:ipAddress withPort:port];
            if (self.deviceAddResultBlock != nil) {
                self.deviceAddResultBlock(error);
                self.deviceAddResultBlock = nil;
            }
        } else if ([dataArray.firstObject isEqualToString:@"RELAY-SCAN_DEVICE-CHANNEL_32"]) {
            NSError *error = [[KinconyDeviceManager sharedManager] addDevice:32 withIp:ipAddress withPort:port];
            if (self.deviceAddResultBlock != nil) {
                self.deviceAddResultBlock(error);
                self.deviceAddResultBlock = nil;
            }
        } else if ([dataArray.firstObject isEqualToString:@"RELAY-STATE-1"]) {
            [self decodeDeviceState:[dataArray subarrayWithRange:NSMakeRange(1, dataArray.count - 2)] withIpaddress:ipAddress withPort:port];
        }
    }
}

- (void)socketDidConnect:(NSNotification*)notification {
    [self searchDevicesState];
}

#pragma mark - private methods

- (void)decodeDeviceState:(NSArray*)stateArray withIpaddress:(NSString*)ipAddress withPort:(NSInteger)port {
    NSMutableArray *resultStateStrArray = [[NSMutableArray alloc] init];
    NSMutableArray *resultStateArray = [[NSMutableArray alloc] init];
    for (int i = (int)stateArray.count - 1; i >= 0; i--) {
        NSString *stateStr = [self toBinarySystemWithDecimalSystem:stateArray[i]];
        for (int j = 1; j <= 8 ; j++) {
            NSString *state = @"0";
            if (j <= stateStr.length) {
                state = [stateStr substringWithRange:NSMakeRange(stateStr.length - j, 1)];
            }
            [resultStateStrArray addObject:state];
            
            KinconyDeviceState *kinconyDeviceState = [[KinconyDeviceState alloc] init];
            kinconyDeviceState.ipAddress = ipAddress;
            kinconyDeviceState.port = port;
            kinconyDeviceState.state = [state integerValue];
            [resultStateArray addObject:kinconyDeviceState];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KinconyDeviceStateNotification object:nil userInfo:@{@"stateArray": resultStateArray}];
}

- (NSString *)toBinarySystemWithDecimalSystem:(NSString *)decimal {
    int num = [decimal intValue];
    int remainder = 0;
    int divisor = 0;
    
    NSString * prepare = @"";
    
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        
        if (divisor == 0)
        {
            break;
        }
    }
    
    NSString * result = @"";
    for (int i = (int)prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    
    return result;
}

@end
