//
//  DeviceImageChooseViewController.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/8.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceImageChooseViewController.h"
#import "DeviceImageCell.h"

@interface DeviceImageChooseViewController ()

@end

@implementation DeviceImageChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"deviceImagesTitle", nil);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = [[UIScreen mainScreen] bounds].size.width / 4.0f;
    return CGSizeMake(w, w);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.deviceImageCellVMList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeviceImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DeviceImageCell" forIndexPath:indexPath];
    
    cell.viewModel = [self.viewModel.deviceImageCellVMList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel chooseImageIndex:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setters and getters

- (DeviceImageChooseVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[DeviceImageChooseVM alloc] init];
    }
    return _viewModel;
}

@end
