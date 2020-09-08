//
//  KinconyRelay.h
//  KBOX
//
//  Created by gulu on 2019/4/3.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KinconyDeviceManager.h"
#import "KinconyDeviceState.h"
#import "KinconySceneRLMObject.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const KinconyDeviceStateNotification;

typedef void (^DeviceAddResultBlock) (NSError *error);

@interface KinconyRelay : NSObject

+ (KinconyRelay*)sharedManager;

- (void)addDevice:(NSString*)ipAddress withPort:(NSInteger)port withNum:(NSInteger)num withSerial:(NSString*)serial withBlock:(DeviceAddResultBlock)block;

- (void)connectAllDevices;

- (RLMResults*)getAllDevices;

- (NSArray*)getAllConnectDevice;

- (void)changeDeviceState:(BOOL)on device:(KinconyDeviceRLMObject*)device;

- (void)exchangeDevicesIndex:(NSMutableArray*)devices;

- (void)editDevice:(KinconyDeviceRLMObject*)device name:(NSString*)name deviceImageName:(NSString*)imageName deviceTouchImageName:(NSString*)touchImageName controlMode:(NSInteger)controlModel;

- (void)deleteDevice:(KinconyDevice*)device;

- (void)searchDevicesState;

- (void)saveScene:(KinconySceneRLMObject*)scene;

- (RLMResults*)getSceces;

- (void)deleteScene:(KinconySceneRLMObject*)scene;

- (void)sceneCommand:(KinconySceneRLMObject*)scene;

- (void)sceneCommandTouchUp;

@end

NS_ASSUME_NONNULL_END
