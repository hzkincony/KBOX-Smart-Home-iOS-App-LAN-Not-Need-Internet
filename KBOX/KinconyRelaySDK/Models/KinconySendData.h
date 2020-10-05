//
//  KinconySendData.h
//  KBOX
//
//  Created by gulu on 2020/9/15.
//  Copyright © 2020 kincony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KinconySendData : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger sendNum;
@property (nonatomic, strong) NSString *sendDataStr;
@property (nonatomic, strong) NSString *serial;
@property (nonatomic, assign) NSInteger firstSendTime;

@end

NS_ASSUME_NONNULL_END
