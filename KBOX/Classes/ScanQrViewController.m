//
//  ScanQrViewController.m
//  KBOX
//
//  Created by gulu on 2020/9/11.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "ScanQrViewController.h"
#import <AVFoundation/AVFoundation.h>

#define iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define StateBar_Height (iPhoneX ?  44 : 20)

@interface ScanQrViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *cameraView;
@property (nonatomic, strong) UIView *middleView;

@end

@implementation ScanQrViewController {
    AVCaptureSession * session;
    AVCaptureMetadataOutput * output;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - actions

- (void)backBtnAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - private methods

- (void)setupViews {
    [self configUI];
}

- (void)configUI {
    AVMediaType mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        [self continueConfigUI:mediaType];
                    } else {
                        NSLog(@"denied");
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:{
            [self continueConfigUI:mediaType];
        }
            break;
            
        default:
            NSLog(@"denied");
            break;
    }
}

- (void)continueConfigUI:(AVMediaType)mediaType {
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:mediaType];
    if (!device) {
        return;
    }

    CGRect cameraFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    CGRect scanRect = CGRectMake(30, (cameraFrame.size.height - (cameraFrame.size.width - 30 * 2)) / 2.0, cameraFrame.size.width - 30 * 2, cameraFrame.size.width - 30 * 2);
    
    AVCaptureDeviceInput * deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    session = [[AVCaptureSession alloc] init];
    if([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    if([session canAddOutput:output]) {
        [session addOutput:output];
    }
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    _cameraView = [[UIView alloc] initWithFrame:cameraFrame];
    _cameraView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_cameraView];
    
    AVCaptureVideoPreviewLayer * layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = _cameraView.bounds;
    [_cameraView.layer addSublayer:layer];
    [session startRunning];
    
    output.rectOfInterest = [layer metadataOutputRectOfInterestForRect:scanRect];
    
    _middleView = [[UIView alloc] initWithFrame:[layer rectForMetadataOutputRectOfInterest:output.rectOfInterest]];
    _middleView.backgroundColor = [UIColor clearColor];
    _middleView.layer.borderWidth = 5;
    _middleView.layer.borderColor = [UIColor orangeColor].CGColor;
    [_cameraView addSubview:_middleView];
    
    [self.view addSubview:self.backBtn];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if(metadataObjects.count > 0) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * readCode = metadataObjects.firstObject;
        if ([self.delegate respondsToSelector:@selector(scanQrViewControllerResult:)]) {
            [self.delegate scanQrViewControllerResult:readCode.stringValue];
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - setters and getters

- (ScanQrVM *)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[ScanQrVM alloc] init];
    }
    return _viewModel;
}

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, StateBar_Height + 30, 30, 30)];
        [self.backBtn setImage:[UIImage imageNamed:@"img_scan_back"] forState:(UIControlStateNormal)];
        [self.backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backBtn;
}

@end
