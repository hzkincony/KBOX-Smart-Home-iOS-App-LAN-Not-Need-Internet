//
//  HomeSeceneControlCellVM.m
//  KBOX
//
//  Created by gulu on 2020/7/11.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "HomeSeceneControlCellVM.h"
#import "KinconyRelay.h"

@interface HomeSeceneControlCellVM()

//@property (nonatomic, strong) KinconyRelay *kinconyRelay;

@end

@implementation HomeSeceneControlCellVM

#pragma mark - public methods

- (void)scenesBtnTouchUp:(KinconySceneRLMObject *)scene {
    if (scene.controlModel == 1) {
        [[KinconyRelay sharedManager] sceneCommandTouchUp];
    } else {
        [[KinconyRelay sharedManager] sceneCommand:scene];
    }
}

- (void)scenesBtnTouchDown:(KinconySceneRLMObject *)scene {
    if (scene.controlModel == 1) {
        [[KinconyRelay sharedManager] sceneCommand:scene];
    }
}

#pragma mark - setters and getters

//- (KinconyRelay*)kinconyRelay {
//    if (_kinconyRelay == nil) {
//        self.kinconyRelay = [[KinconyRelay alloc] init];
//    }
//    return _kinconyRelay;
//}

@end
