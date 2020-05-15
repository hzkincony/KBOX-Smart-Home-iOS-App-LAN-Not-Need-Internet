//
//  DeviceManager.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/2.
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

- (NSError*)addDevice:(NSInteger)relayNum withIp:(NSString*)ipAddress withPort:(NSInteger)port {
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
        device.num = [NSString stringWithFormat:@"%d", i];
        device.name = [NSString stringWithFormat:@"%@-%d", ipLastNum, i];
        device.image = @"icon1";
        device.type = KinconyDeviceType_Relay;
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

- (NSArray*)getAllConnectDevice {
    NSMutableArray *connectDevices = [[NSMutableArray alloc] init];
    
    RLMResults<KinconyDeviceRLMObject*> *devices = [KinconyDeviceRLMObject allObjects];
    NSMutableSet *deviceSet = [[NSMutableSet alloc] init];
    for (KinconyDeviceRLMObject *device in devices) {
        if (![deviceSet containsObject:device.ipAddress]) {
            KinconyDevice *connectDevice = [[KinconyDevice alloc] init];
            connectDevice.ipAddress = device.ipAddress;
            connectDevice.port = device.port;
            [connectDevices addObject:connectDevice];
        }
        [deviceSet addObject:device.ipAddress];
    }
    
    return connectDevices;
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

- (void)editDevice:(KinconyDeviceRLMObject*)device name:(NSString*)name deviceImageName:(NSString*)imageName {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    device.name = name;
    device.image = imageName;
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
