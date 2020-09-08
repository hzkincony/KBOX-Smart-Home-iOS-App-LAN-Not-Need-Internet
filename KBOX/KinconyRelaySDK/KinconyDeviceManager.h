//
//  DeviceManager.h
//  KBOX
//
//  Created by gulu on 2019/4/2.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KinconyDeviceRLMObject.h"
#import "KinconyDevice.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    DeviceAddErrorCode_None = 0,
    DeviceAddErrorCode_AlreadyExists
} DeviceAddErrorCode;

typedef enum {
    KinconyDeviceType_Relay = 0
}KinconyDeviceType;

@interface KinconyDeviceManager : NSObject

+ (KinconyDeviceManager*)sharedManager;

- (NSError*)addDevice:(NSInteger)relayNum withIp:(NSString*)ipAddress withPort:(NSInteger)port withSerial:(NSString*)serial;
- (KinconyDeviceRLMObject*)findDeviceByIp:(NSString*)ipAddress;
- (KinconyDeviceRLMObject*)findDeviceByIp:(NSString*)ipAddress withNum:(NSString*)num;
- (NSArray*)getAllConnectDevice;
- (RLMResults*)getAllDevice;
- (void)deleteDevice:(KinconyDevice*)device;
- (void)deleteAllDevice;
- (void)addDevices:(NSMutableArray*)devices;
- (void)editDevice:(KinconyDeviceRLMObject*)device name:(NSString*)name deviceImageName:(NSString*)imageName deviceTouchImageName:(NSString*)touchImageName controlMode:(NSInteger)controlModel;

@end

NS_ASSUME_NONNULL_END
