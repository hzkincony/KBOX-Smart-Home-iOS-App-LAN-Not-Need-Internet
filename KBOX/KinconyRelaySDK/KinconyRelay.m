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

static KinconyRelay *sharedManager = nil;

+ (KinconyRelay*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sharedManager = [[self alloc] init];

    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readData:) name:KinconySocketReadDataNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidConnect:) name:KinconySocketDidConnectNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public methods

- (void)addDevice:(NSString*)ipAddress withPort:(NSInteger)port withNum:(NSInteger)num withDeviceType:(KinconyDeviceType)deviceType withSerial:(NSString*)serial withBlock:(DeviceAddResultBlock)block {
    
    NSError *error = [[KinconyDeviceManager sharedManager] addDevice:num withIp:ipAddress withPort:port withDeviceType:deviceType withSerial:serial];
    if (error != nil) {
        block([NSError errorWithDomain:@"" code:DeviceAddErrorCode_AlreadyExists userInfo:nil]);
        return;
    }
    
    KinconyDevice *device = [[KinconyDevice alloc] init];
    device.ipAddress = ipAddress;
    device.port = port;
    device.serial = serial;
    [[KinconySocketManager sharedManager] connectToDevice:@[device]];
    block([NSError errorWithDomain:@"" code:0 userInfo:nil]);
}

- (void)connectAllDevices {
    [[KinconySocketManager sharedManager] connectToDevice:[[KinconyDeviceManager sharedManager] getAllConnectDevice]];
}

- (void)disConnectAllDevices {
    [[KinconySocketManager sharedManager] disConnectAllDevice];
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
    connectDevice.serial = device.serial;
    if (device.type == KinconyDeviceType_Relay) {
        NSString *commandStr = [NSString stringWithFormat:@"RELAY-SET-255,%@,%d", device.num, on];
        [[KinconySocketManager sharedManager] sendData:commandStr toDevice:connectDevice];
    }
}

- (void)changeDeviceValue:(NSInteger)value device:(KinconyDeviceRLMObject*)device {
    KinconyDevice *connectDevice = [[KinconyDevice alloc] init];
    connectDevice.ipAddress = device.ipAddress;
    connectDevice.port = device.port;
    connectDevice.serial = device.serial;
    if (device.type == KinconyDeviceType_Dimmer) {
        NSString *commandStr = [NSString stringWithFormat:@"DIMMER-SEND-%@,%ld", device.num, (long)value];
        [[KinconySocketManager sharedManager] sendData:commandStr toDevice:connectDevice];
    }
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
        device.touchImage = oldDevice.touchImage;
        device.controlModel = oldDevice.controlModel;
        [newDevices addObject:device];
    }
    [[KinconySceneManager sharedManager] updateSceneTempDevices];
    [[KinconyDeviceManager sharedManager] deleteAllDevice];
    [[KinconyDeviceManager sharedManager] addDevices:newDevices];
    [self updateSceneDevices];
    [self deleteAllTempDevices];
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
        if (device.type == KinconyDeviceType_Relay) {
            [[KinconySocketManager sharedManager] sendData:@"RELAY-STATE-1" toDevice:device];
        } else {
            [[KinconySocketManager sharedManager] sendData:@"DIMMER-READ-ALL" toDevice:device];
        }
    }
}

- (void)searchDeviceState:(NSString*)ip {
    KinconyDevice *device = [[KinconyDeviceManager sharedManager] getConnectDeviceByIp:ip];
    if (device.type == KinconyDeviceType_Relay) {
        [[KinconySocketManager sharedManager] sendData:@"RELAY-STATE-1" toDevice:device];
    } else {
        [[KinconySocketManager sharedManager] sendData:@"DIMMER-READ-ALL" toDevice:device];
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
    self.nowScene = nil;
    [self searchDevicesState];
}

#pragma mark - notifications

- (void)readData:(NSNotification*)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *text = [dic objectForKey:@"data"];
    NSString *ipAddress = [dic objectForKey:@"ipAddress"];
    NSInteger port = [[dic objectForKey:@"port"] integerValue];
    NSString *serial = [dic objectForKey:@"serial"];
    NSLog(@"read data:%@", text);

    NSArray *dataArray = [text componentsSeparatedByString:@","];
    NSString *stateStr = dataArray.lastObject;
    if ([stateStr containsString:@"OK"]) {
        if ([dataArray.firstObject hasPrefix:@"RELAY-STATE-"] || [dataArray.firstObject hasPrefix:@"RELAY-SET_ALL-"]) {
            [self decodeDeviceState:[dataArray subarrayWithRange:NSMakeRange(1, dataArray.count - 2)] withIpaddress:ipAddress withPort:port withSerial:serial];
        } else if ([dataArray.firstObject hasPrefix:@"RELAY-KEY-"]) {
            [self searchDeviceState:ipAddress];
        } else if ([dataArray.firstObject hasPrefix:@"DIMMER-READ-"]) {
            NSMutableArray *stateStrArray = [[NSMutableArray alloc] init];
            [stateStrArray addObjectsFromArray:[dataArray subarrayWithRange:NSMakeRange(1, dataArray.count - 2)]];
            [self decodeDimmerDeviceValue:stateStrArray withIpaddress:ipAddress withPort:port withSerial:serial];
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

- (void)addStateToSceneCommands:(NSString*)state withIpaddress:(NSString*)ipAddress withPort:(NSInteger)port withSerial:(NSString*)serial {
    if (self.nowScene == nil) {
        return;
    }
    
    for (KinconySceneCommand *sceneCommand in self.sceneCommandArray) {
        if (([sceneCommand.kinconyDevice.ipAddress isEqualToString:ipAddress] && sceneCommand.kinconyDevice.port == port) || [serial hasPrefix:sceneCommand.kinconyDevice.serial]) {
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
    if (self.nowScene.controlModel == 0) {
        self.nowScene = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self searchDevicesState];
        });
    }
}

- (NSString*)getSceneCommandStr:(KinconySceneCommand *)sceneCommand {
    NSMutableString *commandStr = [NSMutableString stringWithString:sceneCommand.commandStr];
    for (KinconySceneDeviceRLMObject *sceneDevice in self.nowScene.sceneDevices) {
        if ([sceneDevice.device.ipAddress isEqualToString:sceneCommand.kinconyDevice.ipAddress] && sceneDevice.device.port == sceneCommand.kinconyDevice.port) {
            [commandStr replaceCharactersInRange:NSMakeRange([sceneDevice.device.num integerValue] - 1, 1) withString:[NSString stringWithFormat:@"%ld", (long)sceneDevice.state]];
        }
    }
    commandStr = [NSMutableString stringWithString:[self reverseWordsInString:commandStr]];
    NSString *command = commandStr;
    
    NSMutableString *resultCommandStr = [[NSMutableString alloc] init];
    
    while (command.length >= 8) {
        NSString *tempStr = [command substringToIndex:8];
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
        NSString *tempStr = [command substringToIndex:8];
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

- (void)decodeDeviceState:(NSArray*)stateArray withIpaddress:(NSString*)ipAddress withPort:(NSInteger)port withSerial:(NSString*)serial {
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
            kinconyDeviceState.serial = serial;
            kinconyDeviceState.state = [state integerValue];
            kinconyDeviceState.deviceType = KinconyDeviceType_Relay;
            [resultStateArray addObject:kinconyDeviceState];
        }
    }
    [self addStateToSceneCommands:resultStateStr withIpaddress:ipAddress withPort:port withSerial:serial];
    if (self.nowScene == nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KinconyDeviceStateNotification object:nil userInfo:@{@"stateArray": resultStateArray}];
    }
}

- (void)decodeDimmerDeviceValue:(NSArray*)valueArray withIpaddress:(NSString*)ipAddress withPort:(NSInteger)port withSerial:(NSString*)serial {
    NSMutableArray *resultStateArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < valueArray.count; i++) {
        KinconyDeviceState *kinconyDeviceState = [[KinconyDeviceState alloc] init];
        kinconyDeviceState.ipAddress = ipAddress;
        kinconyDeviceState.port = port;
        kinconyDeviceState.serial = serial;
        kinconyDeviceState.value = [valueArray[i] integerValue];
        kinconyDeviceState.deviceType = KinconyDeviceType_Dimmer;
        [resultStateArray addObject:kinconyDeviceState];
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

- (NSArray*)getAllSceneDevices:(KinconySceneRLMObject*)scene {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    for (KinconySceneDeviceRLMObject *sceneDevice in scene.sceneDevices) {
//        [dic setObject:[NSNumber numberWithInteger:sceneDevice.device.port] forKey:sceneDevice.device.ipAddress];
//    }
//
//    for (NSString *key in dic.allKeys) {
//        KinconyDevice *device = [[KinconyDevice alloc] init];
//        device.ipAddress = key;
//        device.port = [[dic objectForKey:key] integerValue];
//        [array addObject:device];
//    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (KinconySceneDeviceRLMObject *sceneDevice in scene.sceneDevices) {
        [dic setObject:sceneDevice.device forKey:sceneDevice.device.ipAddress];
    }
    
    for (NSString *key in dic.allKeys) {
        KinconyDeviceRLMObject *rlmDevice = [dic objectForKey:key];
        KinconyDevice *device = [[KinconyDevice alloc] init];
        device.ipAddress = key;
        device.port = rlmDevice.port;
        device.serial = rlmDevice.serial;
        [array addObject:device];
    }
    
    return array;
}

- (void)updateSceneDevices {
    RLMResults *scenes = [[KinconySceneManager sharedManager] getScenes];
    for (KinconySceneRLMObject *scene in scenes) {
        NSMutableArray *tempDevicesArray = [[NSMutableArray alloc] init];
        for (KinconySceneDeviceRLMObject *sceneDevice in scene.sceneDevices) {
            KinconyDeviceRLMObject *device = [[KinconyDeviceManager sharedManager] findDeviceByIp:sceneDevice.tempDevice.ipAddress withNum:sceneDevice.tempDevice.num];
            if (device != nil) {
                [tempDevicesArray addObject:device];
            }
        }
        [[KinconySceneManager sharedManager] updateSceneDevice:scene withDevice:tempDevicesArray];
    }
}

- (void)deleteAllTempDevices {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults *tempDevices = [KinconyTempDeviceRLMObject allObjects];
    [realm deleteObjects:tempDevices];
    [realm commitWriteTransaction];
}

#pragma mark - setters and getters

- (NSMutableArray *)sceneCommandArray {
    if (_sceneCommandArray == nil) {
        self.sceneCommandArray = [[NSMutableArray alloc] init];
    }
    return _sceneCommandArray;
}

@end
