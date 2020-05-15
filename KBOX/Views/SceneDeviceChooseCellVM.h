//
//  SceneDeviceChooseCellVM.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "KinconyDeviceRLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SceneDeviceChooseCellVM : GLViewModel

@property (nonatomic, strong) UIImage *deviceImage;
@property (nonatomic, strong) NSString *deviceName;

- (id)initWithDevice:(KinconyDeviceRLMObject*)device;
- (KinconyDeviceRLMObject*)getDevice;

@end

NS_ASSUME_NONNULL_END
