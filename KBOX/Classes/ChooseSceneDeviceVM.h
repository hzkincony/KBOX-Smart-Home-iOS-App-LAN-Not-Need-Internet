//
//  ChooseSceneDeviceVM.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "KinconyDeviceRLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChooseSceneDeviceVMDelegate

- (void)sceneDeviceChoosed:(KinconyDeviceRLMObject*)device;

@end

@interface ChooseSceneDeviceVM : GLViewModel

@property (nonatomic, weak) id<ChooseSceneDeviceVMDelegate> delegate;
@property (nonatomic, strong) RACSubject *getDevicesSignal;
@property (nonatomic, strong) RACSubject *chooseDeviceSignal;
@property (nonatomic, strong) NSMutableArray *deviceCellVMList;

- (void)getDevices;
- (void)chooseDevice:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
