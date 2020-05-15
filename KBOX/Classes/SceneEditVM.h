//
//  SceneEditVM.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "KinconySceneRLMObject.h"
#import "ChooseSceneDeviceVM.h"

typedef enum {
    SceneEditVMTypeAdd = 0,
    SceneEditVMTypeEdit
} SceneEditVMType;

NS_ASSUME_NONNULL_BEGIN

@interface SceneEditVM : GLViewModel

@property (nonatomic, strong) KinconySceneRLMObject *scene;
@property (nonatomic, assign) SceneEditVMType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *sceneDeviceCellVMList;
@property (nonatomic, strong) RACSubject *getSceneDevicesSignal;
@property (nonatomic, strong) RACSubject *saveSceneSignal;

- (ChooseSceneDeviceVM*)getChooseSceneDeviceVM;
- (void)getSceneDevices;
- (void)saveScene;
- (BOOL)isValidInput;

@end

NS_ASSUME_NONNULL_END
