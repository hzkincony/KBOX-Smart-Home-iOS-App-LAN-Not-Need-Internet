//
//  DeviceImageChooseVM.h
//  KBOX
//
//  Created by gulu on 2019/4/8.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "DeviceImageCellVM.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    ChooseTypeNone = 0,
    ChooseTypeDevice,
    ChooseTypeTouch
} DeviceImageChooseVMType;

@protocol DeviceImageChooseVMDelegate <NSObject>

- (void)choosedImageName:(NSString*)imageName chooseType:(DeviceImageChooseVMType)chooseType;

@end

@interface DeviceImageChooseVM : GLViewModel

@property (nonatomic, strong) NSMutableArray *deviceImageCellVMList;
@property (nonatomic, weak) id<DeviceImageChooseVMDelegate> delegate;
@property (nonatomic, assign) DeviceImageChooseVMType chooseType;

- (void)chooseImageIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
