//
//  SettingVM.h
//  KBOX
//
//  Created by gulu on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingVM : GLViewModel

@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSNumber *useServer;

@end

NS_ASSUME_NONNULL_END
