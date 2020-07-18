//
//  SceneCellVM.m
//  KBOX
//
//  Created by gulu on 2019/4/19.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SceneCellVM.h"
#import "KinconyRelay.h"

@interface SceneCellVM()

@property (nonatomic, strong) KinconySceneRLMObject *scene;
//@property (nonatomic, strong) KinconyRelay *kinconyRelay;

@end

@implementation SceneCellVM

- (id)initWithScene:(KinconySceneRLMObject *)scene {
    if ((self = [super init])) {
        self.scene = scene;
        [self getData];
    }
    return self;
}

#pragma mark - private methods

- (void)getData {
    self.name = self.scene.name;
    self.image = [UIImage imageNamed:self.scene.image];
}

- (void)deleteScene {
    [[KinconyRelay sharedManager] deleteScene:self.scene];
}

- (KinconySceneRLMObject*)getScene {
    return self.scene;
}

#pragma mark - setters and getters

//- (KinconyRelay*)kinconyRelay {
//    if (_kinconyRelay == nil) {
//        self.kinconyRelay = [[KinconyRelay alloc] init];
//    }
//    return _kinconyRelay;
//}

@end
