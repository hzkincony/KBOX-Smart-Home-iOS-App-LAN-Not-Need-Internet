//
//  DeviceManager.m
//  KBOX
//
//  Created by gulu on 2019/4/2.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "KinconyDeviceManager.h"
#import "RLMRealm.h"
#import "RLMResults.h"

@implementation KinconyDeviceManager

static KinconyDeviceManager *sharedManager = nil;

+ (KinconyDeviceManager*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - public methods

- (NSError*)addDevice:(NSInteger)relayNum withIp:(NSString*)ipAddress withPort:(NSInteger)port withDeviceType:(KinconyDeviceType)deviceType withSerial:(NSString*)serial {
    NSError *error = nil;
    if ([self findDeviceByIp:ipAddress] != nil) {
        error = [NSError errorWithDomain:@"device already exists." code:DeviceAddErrorCode_AlreadyExists userInfo:nil];
        return error;
    }
    
    NSMutableArray *deviceArray = [[NSMutableArray alloc] init];
    NSString *ipLastNum = [[ipAddress componentsSeparatedByString:@"."] lastObject];
    
    for (int i = 1; i <= relayNum; i ++) {
        KinconyDeviceRLMObject *device = [[KinconyDeviceRLMObject alloc] init];
        device.deviceId = [self getUuid];
        device.ipAddress = ipAddress;
        device.port = port;
        device.serial = serial;
        device.num = [NSString stringWithFormat:@"%d", i];
        device.name = [NSString stringWithFormat:@"%@-%d", ipLastNum, i];
        device.image = @"icon1";
        device.type = deviceType;
        device.controlModel = 0;
        device.touchImage = @"icon1";
        [deviceArray addObject:device];
    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObjects:deviceArray];
    [realm commitWriteTransaction];
    
    return error;
}

- (KinconyDeviceRLMObject*)findDeviceByIp:(NSString*)ipAddress {
    RLMResults<KinconyDeviceRLMObject*> *devices = [KinconyDeviceRLMObject objectsWhere:[NSString stringWithFormat:@"ipAddress = '%@'", ipAddress]];
    if (devices.count > 0) {
        return devices.firstObject;
    }
    return nil;
}

- (KinconyDeviceRLMObject *)findDeviceByIp:(NSString *)ipAddress withNum:(NSString*)num {
    RLMResults<KinconyDeviceRLMObject*> *devices = [KinconyDeviceRLMObject objectsWhere:[NSString stringWithFormat:@"ipAddress = '%@' AND num = '%@'", ipAddress, num]];
    if (devices.count > 0) {
        return devices.firstObject;
    }
    return nil;
}

- (NSArray*)getAllConnectDevice {
    NSMutableArray *connectDevices = [[NSMutableArray alloc] init];
    
    RLMResults<KinconyDeviceRLMObject*> *devices = [KinconyDeviceRLMObject allObjects];
    NSMutableSet *deviceSet = [[NSMutableSet alloc] init];
    for (KinconyDeviceRLMObject *device in devices) {
        if (![deviceSet containsObject:device.ipAddress]) {
            KinconyDevice *connectDevice = [[KinconyDevice alloc] init];
            connectDevice.ipAddress = device.ipAddress;
            connectDevice.port = device.port;
            connectDevice.type = device.type;
            connectDevice.serial = device.serial;
            [connectDevices addObject:connectDevice];
        }
        [deviceSet addObject:device.ipAddress];
    }
    
    return connectDevices;
}

- (KinconyDevice*)getConnectDeviceByIp:(NSString*)ipAddress {
    KinconyDeviceRLMObject *device = [self findDeviceByIp:ipAddress];
    KinconyDevice *connectDevice = [[KinconyDevice alloc] init];
    if (device != nil) {
        connectDevice.ipAddress = device.ipAddress;
        connectDevice.port = device.port;
        connectDevice.type = device.type;
        connectDevice.serial = device.serial;
    }
    return connectDevice;
}

- (RLMResults*)getAllDevice {
    RLMResults<KinconyDeviceRLMObject*> *devices = [KinconyDeviceRLMObject allObjects];
    return devices;
}

- (void)deleteAllDevice {
    RLMResults<KinconyDeviceRLMObject*> *devices = [KinconyDeviceRLMObject allObjects];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:devices];
    [realm commitWriteTransaction];
}

- (void)addDevices:(NSMutableArray *)devices {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObjects:devices];
    [realm commitWriteTransaction];
}

- (void)editDevice:(KinconyDeviceRLMObject*)device name:(NSString*)name deviceImageName:(NSString*)imageName deviceTouchImageName:(NSString*)touchImageName controlMode:(NSInteger)controlModel {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    device.name = name;
    device.image = imageName;
    device.touchImage = touchImageName;
    device.controlModel = controlModel;
    [realm commitWriteTransaction];
}

- (void)deleteDevice:(KinconyDevice *)device {
    RLMResults<KinconyDeviceRLMObject*> *devices = [KinconyDeviceRLMObject objectsWhere:[NSString stringWithFormat:@"ipAddress = '%@' and port = %ld", device.ipAddress, (long)device.port]];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:devices];
    [realm commitWriteTransaction];
}

#pragma mark - private methods

- (NSString*)getUuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end
