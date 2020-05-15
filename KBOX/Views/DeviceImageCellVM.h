//
//  DeviceImageCellVM.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceImageCellVM : GLViewModel

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageName;

- (id)initWithImageName:(NSString*)imageName;

@end

NS_ASSUME_NONNULL_END
