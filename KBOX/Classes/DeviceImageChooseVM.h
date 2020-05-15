//
//  DeviceImageChooseVM.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/8.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "DeviceImageCellVM.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DeviceImageChooseVMDelegate <NSObject>

- (void)choosedImageName:(NSString*)imageName;

@end

@interface DeviceImageChooseVM : GLViewModel

@property (nonatomic, strong) NSMutableArray *deviceImageCellVMList;
@property (nonatomic, weak) id<DeviceImageChooseVMDelegate> delegate;

- (void)chooseImageIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
