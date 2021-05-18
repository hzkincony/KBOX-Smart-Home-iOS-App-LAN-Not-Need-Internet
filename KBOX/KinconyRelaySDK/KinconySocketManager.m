//
//  SocketManager.m
//  KBOX
//
//  Created by gulu on 2019/4/2.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "KinconySocketManager.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "KinconySendData.h"

#define RESEND_NUM 3

NSString * const KinconySocketReadDataNotification = @"KinconySocketReadDataNotification";
NSString * const KinconySocketDidConnectNotification = @"KinconySocketDidConnectNotification";

@interface KinconySocketManager()<GCDAsyncSocketDelegate, GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) NSMutableArray *socketArray;
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic, strong) NSMutableArray<KinconySendData*> *sendDataLoop;

@end

@implementation KinconySocketManager {
    dispatch_source_t _timer;
}

static KinconySocketManager *sharedManager = nil;

+ (KinconySocketManager*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sharedManager = [[self alloc] init];
        [sharedManager setupSocket];
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
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *text = [str stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KinconySocketReadDataNotification object:nil userInfo:@{@"data": text, @"ipAddress": sock.connectedHost, @"port": [NSNumber numberWithInteger:sock.connectedPort]}];
    
    [sock readDataWithTimeout:-1 tag:0];
}

#pragma mark - GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"send data successed");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"send data fail:%@", error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    NSData *serialData = [data subdataWithRange:NSMakeRange(6, 28)];
    NSString *serialStr = [[NSString alloc]initWithData:serialData encoding:NSASCIIStringEncoding];
    
    NSData *newData = [data subdataWithRange:NSMakeRange(44, data.length - 44)];
    NSString *contentStr = [[NSString alloc]initWithData:newData encoding:NSASCIIStringEncoding];
    
//    [self removeSendLoopDataBy:contentStr];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KinconySocketReadDataNotification object:nil userInfo:@{@"data": contentStr, @"serial": serialStr}];
}

#pragma mark - public methods

- (void)connectToDevice:(NSArray *)deviceArray {
    for (KinconyDevice *device in deviceArray) {
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [socket connectToHost:device.ipAddress onPort:device.port error:nil];
    }
}

- (void)disConnectAllDevice {
    for (GCDAsyncSocket *socket in self.socketArray) {
        [socket disconnect];
    }
    [self.socketArray removeAllObjects];
}

- (void)sendData:(NSString *)dataStr toDevice:(KinconyDevice *)device {
    NSLog(@"send dataStr:%@", dataStr);
    for (GCDAsyncSocket* sock in self.socketArray) {
        if ([sock.connectedHost isEqualToString:device.ipAddress]) {
            [self sendData:dataStr bySock:sock];
            return;
        }
    }
}

#pragma mark - private methods

- (void)setupSocket {
    NSError *error = nil;
    
    int port = 0;
    if (![self.udpSocket bindToPort:port error:&error]) {
        return;
    }
    if (![self.udpSocket enableBroadcast:YES error:&error]) {
        return;
    }
    if (![self.udpSocket beginReceiving:&error]) {
        [self.udpSocket close];
        return;
    }
}

- (NSString*)udpSendData:(NSString*)sendData withSerial:(NSString*)serial {
    NSString *udpSendDataStr = @"";
    
    NSInteger index = 0;
    if (self.sendDataLoop.count > 0) {
        if (self.sendDataLoop.lastObject.index < 255) {
            index = self.sendDataLoop.lastObject.index + 1;
        }
    }
    
    NSString *regulaString = @"-([\\d]+)";
    NSRange range = [sendData rangeOfString:regulaString options:NSRegularExpressionSearch];
    
    udpSendDataStr = [sendData stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"-%ld", (long)index]];
    
    KinconySendData *sendLoopData = [[KinconySendData alloc] init];
    sendLoopData.index = index;
    sendLoopData.sendNum = 1;
    sendLoopData.sendDataStr = udpSendDataStr;
    sendLoopData.serial = serial;
    sendLoopData.firstSendTime = [[NSDate date] timeIntervalSince1970];
    [self.sendDataLoop addObject:sendLoopData];
    
    return udpSendDataStr;
}

- (void)removeSendLoopDataBy:(NSString*)readStr {
    NSInteger index = [self getSendDataIndex:readStr];
    for (KinconySendData *sendData in self.sendDataLoop) {
        if (sendData.index == index) {
            [self.sendDataLoop removeObject:sendData];
            return;
        }
    }
}

- (NSInteger)getSendDataIndex:(NSString*)sendData {
    NSInteger index = 0;
    
    NSString *regulaString = @"-([\\d]+)";
    NSRange range = [sendData rangeOfString:regulaString options:NSRegularExpressionSearch];
    NSString *indexStr = [sendData substringWithRange:NSMakeRange(range.location + 1, range.length - 1)];
    if (indexStr != nil) {
        index = indexStr.integerValue;
    }
    
    return index;
}

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

- (NSMutableArray<KinconySendData*> *)sendDataLoop {
    if (_sendDataLoop == nil) {
        self.sendDataLoop = [[NSMutableArray<KinconySendData*> alloc] init];
    }
    return _sendDataLoop;
}

- (GCDAsyncUdpSocket *)udpSocket {
    if (_udpSocket == nil) {
        self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _udpSocket;
}

@end
