//
//  SocketManager.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/2.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "KinconySocketManager.h"
#import "GCDAsyncSocket.h"

NSString * const KinconySocketReadDataNotification = @"KinconySocketReadDataNotification";
NSString * const KinconySocketDidConnectNotification = @"KinconySocketDidConnectNotification";

@interface KinconySocketManager()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) NSMutableArray *socketArray;

@end

@implementation KinconySocketManager

static KinconySocketManager *sharedManager = nil;

+ (KinconySocketManager*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    [self.socketArray addObject:sock];
    [sock readDataWithTimeout:-1 tag:0];
    [self sendData:@"RELAY-SCAN_DEVICE-NOW" bySock:sock];
    [[NSNotificationCenter defaultCenter] postNotificationName:KinconySocketDidConnectNotification object:nil];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"Disconnect");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *text = [str stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KinconySocketReadDataNotification object:nil userInfo:@{@"data": text, @"ipAddress": sock.connectedHost, @"port": [NSNumber numberWithInteger:sock.connectedPort]}];
    
    [sock readDataWithTimeout:-1 tag:0];
    if ([text isEqualToString:@"RELAY-SCAN_DEVICE-CHANNEL_8,OK"] || [text isEqualToString:@"RELAY-SCAN_DEVICE-CHANNEL_32,OK"]) {
        [self sendData:@"RELAY-TEST-NOW" bySock:sock];
    }
}

#pragma mark - public methods

- (void)connectToDevice:(NSArray *)deviceArray {
    for (KinconyDevice *device in deviceArray) {
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [socket connectToHost:device.ipAddress onPort:device.port error:nil];
    }
}

- (void)sendData:(NSString *)dataStr toDevice:(KinconyDevice *)device {
    for (GCDAsyncSocket* sock in self.socketArray) {
        if ([sock.connectedHost isEqualToString:device.ipAddress]) {
            [self sendData:dataStr bySock:sock];
            return;
        }
    }
}

#pragma mark - private methods

- (void)sendData:(NSString*)dataStr bySock:(GCDAsyncSocket*)sock {
    NSLog(@"======%@", dataStr);
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    [sock writeData:data withTimeout:-1 tag:0];
}

#pragma mark - getters and setters

- (NSMutableArray*)socketArray {
    if (_socketArray == nil) {
        self.socketArray = [[NSMutableArray alloc] init];
    }
    return _socketArray;
}

@end
