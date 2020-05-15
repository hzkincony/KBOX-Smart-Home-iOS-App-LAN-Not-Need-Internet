//
//  DeviceImageChooseVM.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/8.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceImageChooseVM.h"

@implementation DeviceImageChooseVM

- (void)initializeData {
    [self getImages];
};

#pragma mark - public methods

- (void)chooseImageIndex:(NSInteger)index {
    DeviceImageCellVM *deviceImageCellVM = [self.deviceImageCellVMList objectAtIndex:index];
    [self.delegate choosedImageName:deviceImageCellVM.imageName];
}

#pragma mark - private methods

- (void)getImages {
    [self.deviceImageCellVMList removeAllObjects];
    for (int i = 1; i <= 16; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"icon%d", i];
        [self.deviceImageCellVMList addObject:[[DeviceImageCellVM alloc] initWithImageName:imageName]];
    }
}

#pragma mark - setters and getters

- (NSMutableArray*)deviceImageCellVMList {
    if (_deviceImageCellVMList == nil) {
        self.deviceImageCellVMList = [[NSMutableArray alloc] init];
    }
    return _deviceImageCellVMList;
}

@end
