//
//  ScanQrViewController.h
//  KBOX
//
//  Created by gulu on 2020/9/11.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "GLBaseViewController.h"
#import "ScanQrVM.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ScanQrViewControllerDelegate <NSObject>

- (void)scanQrViewControllerResult:(NSString*)result;

@end

@interface ScanQrViewController : GLBaseViewController

@property (nonatomic, weak) id<ScanQrViewControllerDelegate> delegate;
@property (nonatomic, strong) ScanQrVM *viewModel;

@end

NS_ASSUME_NONNULL_END
