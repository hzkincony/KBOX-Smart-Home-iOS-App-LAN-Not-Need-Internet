//
//  SceneDeviceCellVM.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/19.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "KinconySceneDeviceRLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SceneDeviceCellVM : GLViewModel

@property (nonatomic, strong) UIImage *deviceImage;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSNumber *deviceOn;

- (id)initWithDevice:(KinconySceneDeviceRLMObject*)device;

@end

NS_ASSUME_NONNULL_END
