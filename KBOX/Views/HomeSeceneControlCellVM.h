//
//  HomeSeceneControlCellVM.h
//  KBOX
//
//  Created by gulu on 2020/7/11.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "GLViewModel.h"
//#import <RLMResults.h>
#import "KinconySceneRLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeSeceneControlCellVM : GLViewModel

@property (nonatomic, strong) RLMResults *scenes;

- (void)scenesBtnTouchDown:(KinconySceneRLMObject*)scene;
- (void)scenesBtnTouchUp:(KinconySceneRLMObject*)scene;

@end

NS_ASSUME_NONNULL_END
