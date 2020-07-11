//
//  KinconyRelay.m
//  KBOX
//
//  Created by gulu on 2019/4/3.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "KinconyRelay.h"
#import "KinconySocketManager.h"
#import "KinconyDevice.h"
#import "KinconySceneManager.h"
#import "KinconySceneCommand.h"

NSString * const KinconyDeviceStateNotification = @"KinconyDeviceStateNotification";

@interface KinconyRelay()

@property (nonatomic, strong) NSMutableArray *sceneCommandArray;
@property (nonatomic, strong) KinconySceneRLMObject *nowScene;

@end

@implementation KinconyRelay

- (id)init {
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readData:) name:KinconySocketReadDataNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidConnect:) name:KinconySocketDidConnectNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public methods

- (void)addDevice:(NSString*)ipAddress withPort:(NSInteger)port withNum:(NSInteger)num withBlock:(DeviceAddResultBlock)block {
    
    NSError *error = [[KinconyDeviceManager sharedManager] addDevice:num withIp:ipAddress withPort:port];
    if (error != nil) {
        block([NSError errorWithDomain:@"" code:DeviceAddErrorCode_AlreadyExists userInfo:nil]);
        return;
    }
    
    KinconyDevice *device = [[KinconyDevice alloc] init];
    device.ipAddress = ipAddress;
    device.port = port;
    [[KinconySocketManager sharedManager] connectToDevice:@[device]];
    block([NSError errorWithDomain:@"" code:0 userInfo:nil]);
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
    NSArray *array = [self getAllSceneDevices:scene];
    [self.sceneCommandArray removeAllObjects];
    for (KinconyDevice *kinconyDevice in array) {
        KinconySceneCommand *sceneCommand = [[KinconySceneCommand alloc] init];
        sceneCommand.kinconyDevice = kinconyDevice;
        [self.sceneCommandArray addObject:sceneCommand];
    }
    self.nowScene = scene;
    [self searchDevicesState:array];
}

- (void)sceneCommandTouchUp {
    for (KinconySceneCommand *sceneCommand in self.sceneCommandArray) {
        NSString *sceneCommandStr = [self getOldSceneCommandStr:sceneCommand];
        NSString *commandStr = [NSString stringWithFormat:@"RELAY-SET_ALL-255,%@OK", sceneCommandStr];
        [[KinconySocketManager sharedManager] sendData:commandStr toDevice:sceneCommand.kinconyDevice];
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
        if ([dataArray.firstObject isEqualToString:@"RELAY-STATE-1"]) {
            [self decodeDeviceState:[dataArray subarrayWithRange:NSMakeRange(1, dataArray.count - 2)] withIpaddress:ipAddress withPort:port];
        }
    }
}

- (void)socketDidConnect:(NSNotification*)notification {
    [self searchDevicesState];
}

#pragma mark - private methods

- (void)searchDevicesState:(NSArray*)devices {
    for (KinconyDevice *device in devices) {
        [[KinconySocketManager sharedManager] sendData:@"RELAY-STATE-1" toDevice:device];
    }
}

- (void)addStateToSceneCommands:(NSString*)state withIpaddress:(NSString*)ipAddress withPort:(NSInteger)port {
    for (KinconySceneCommand *sceneCommand in self.sceneCommandArray) {
        if ([sceneCommand.kinconyDevice.ipAddress isEqualToString:ipAddress] && sceneCommand.kinconyDevice.port == port) {
            sceneCommand.commandStr = state;
            break;
        }
    }
    
    Boolean canSendSceneCommand = YES;
    for (KinconySceneCommand *sceneCommand in self.sceneCommandArray) {
        if (sceneCommand.commandStr == nil) {
            canSendSceneCommand = NO;
            break;
        }
    }
    
    if (canSendSceneCommand) {
        [self sendSceneCommand];
    }
}

- (void)sendSceneCommand {
    for (KinconySceneCommand *sceneCommand in self.sceneCommandArray) {
        NSString *sceneCommandStr = [self getSceneCommandStr:sceneCommand];
        NSString *commandStr = [NSString stringWithFormat:@"RELAY-SET_ALL-255,%@OK", sceneCommandStr];
        [[KinconySocketManager sharedManager] sendData:commandStr toDevice:sceneCommand.kinconyDevice];
    }
}

- (NSString*)getSceneCommandStr:(KinconySceneCommand *)sceneCommand {
    NSMutableString *commandStr = [NSMutableString stringWithString:sceneCommand.commandStr];
    for (KinconySceneDeviceRLMObject *sceneDevice in self.nowScene.sceneDevices) {
        if ([sceneDevice.device.ipAddress isEqualToString:sceneCommand.kinconyDevice.ipAddress] && sceneDevice.device.port == sceneCommand.kinconyDevice.port) {
            [commandStr replaceCharactersInRange:NSMakeRange([sceneDevice.device.num integerValue], 1) withString:[NSString stringWithFormat:@"%ld", (long)sceneDevice.state]];
        }
    }
    commandStr = [NSMutableString stringWithString:[self reverseWordsInString:commandStr]];
    NSString *command = commandStr;
    
    NSMutableString *resultCommandStr = [[NSMutableString alloc] init];
    
    while (command.length >= 8) {
        NSString *tempStr = [command substringToIndex:7];
        command = [command substringFromIndex:8];
        [resultCommandStr appendString:[NSString stringWithFormat:@"%ld,", (long)[self getDecimalByBinary:tempStr]]];
    }
    
    return resultCommandStr;
}

- (NSString*)getOldSceneCommandStr:(KinconySceneCommand*)sceneCommand {
    NSString *commandStr = [NSMutableString stringWithString:[self reverseWordsInString:sceneCommand.commandStr]];
    NSString *command = commandStr;
    
    NSMutableString *resultCommandStr = [[NSMutableString alloc] init];
    
    while (command.length >= 8) {
        NSString *tempStr = [command substringToIndex:7];
        command = [command substringFromIndex:8];
        [resultCommandStr appendString:[NSString stringWithFormat:@"%ld,", (long)[self getDecimalByBinary:tempStr]]];
    }
    
    return resultCommandStr;
}

- (NSInteger)getDecimalByBinary:(NSString *)binary {
    NSInteger decimal = 0;
    for (int i=0; i<binary.length; i++) {
        
        NSString *number = [binary substringWithRange:NSMakeRange(binary.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            
            decimal += pow(2, i);
        }
    }
    return decimal;
}

- (NSString*)reverseWordsInString:(NSString*)oldStr {
    NSMutableString *newStr = [[NSMutableString alloc] initWithCapacity:oldStr.length];
    for (int i = (int)oldStr.length - 1; i >= 0; i --) {
        unichar character = [oldStr characterAtIndex:i];
        [newStr appendFormat:@"%c",character];
    }
    return newStr;
}

- (void)decodeDeviceState:(NSArray*)stateArray withIpaddress:(NSString*)ipAddress withPort:(NSInteger)port {
    NSMutableString *resultStateStr = [[NSMutableString alloc] init];
    NSMutableArray *resultStateArray = [[NSMutableArray alloc] init];
    for (int i = (int)stateArray.count - 1; i >= 0; i--) {
        NSString *stateStr = [self toBinarySystemWithDecimalSystem:stateArray[i]];
        for (int j = 1; j <= 8 ; j++) {
            NSString *state = @"0";
            if (j <= stateStr.length) {
                state = [stateStr substringWithRange:NSMakeRange(stateStr.length - j, 1)];
            }
            [resultStateStr appendString:state];
            
            KinconyDeviceState *kinconyDeviceState = [[KinconyDeviceState alloc] init];
            kinconyDeviceState.ipAddress = ipAddress;
            kinconyDeviceState.port = port;
            kinconyDeviceState.state = [state integerValue];
            [resultStateArray addObject:kinconyDeviceState];
        }
    }
    [self addStateToSceneCommands:resultStateStr withIpaddress:ipAddress withPort:port];
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

- (NSArray*)getAllSceneDevices:(KinconySceneRLMObject*)scene {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (KinconySceneDeviceRLMObject *sceneDevice in scene.sceneDevices) {
        [dic setObject:[NSNumber numberWithInteger:sceneDevice.device.port] forKey:sceneDevice.device.ipAddress];
    }
    
    for (NSString *key in dic.allKeys) {
        KinconyDevice *device = [[KinconyDevice alloc] init];
        device.ipAddress = key;
        device.port = [[dic objectForKey:key] integerValue];
        [array addObject:device];
    }
    
    return array;
}

#pragma mark - setters and getters

- (NSMutableArray *)sceneCommandArray {
    if (_sceneCommandArray == nil) {
        self.sceneCommandArray = [[NSMutableArray alloc] init];
    }
    return _sceneCommandArray;
}

@end
