//
//  SocketManager.m
//  Socket
//
//  Created by ccxdd on 13-9-1.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import "SocketManager.h"
#import "GCDAsyncSocket.h"
#import "NSDictionary+DDictionary.h"

@interface SocketManager () <GCDAsyncSocketDelegate>
{
@private
    GCDAsyncSocket *socket;
    NSMutableArray *requests;
    NSMutableData *chatData;
}

@property (nonatomic, copy) void (^completeBlock)(BOOL isConnect);

@end

#define dHOST                   @"192.168.2.5"
#define dPORT                   14604
#define dREQUEST_TAG            0
#define dSEND_HANDLER           @"dSEND_HANDLER"
#define dRECEIVE_HANDLER        @"dRECEIVE_HANDLER"
#define dRECEIVE_DATA           @"dRECEIVE_DATA"

@implementation SocketManager

+ (SocketManager *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        requests = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

#pragma mark connect

- (void)connectCompleteBlock:(void (^)(BOOL isConnect))completeBlock
{
    BOOL result = NO;
    
    if (![self isConnect]) {
        NSError *error = nil;
        result = [socket connectToHost:dHOST onPort:dPORT error:&error];
        
        if (error != nil) {
            //        @throw [NSException exceptionWithName:@"GCDAsyncSocket"
            //                                       reason:[error localizedDescription]
            //                                     userInfo:nil];
            NSLog(@"connect fail!");
        }
    }
    
    if (completeBlock) {
        self.completeBlock = completeBlock;
    }
}

- (BOOL)isConnect
{
    return [socket isConnected];
}

#pragma mark disconnect

- (void)disconnectCompleteBlock:(void (^)(BOOL isConnect))completeBlock
{
    if ([self isConnect]) {
        [socket disconnect];
    }
    
    if (completeBlock) {
        self.completeBlock = completeBlock;
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [requests removeAllObjects];
    NSLog(@"socketDidDisconnect %@", err);
    
    if (self.completeBlock) {
        self.completeBlock(NO);
    }
}

//#pragma mark chat mode
//
//- (void)chatMode
//{
//    isChatMode = YES;
//    NSLog(@"chatMode");
//    [socket readDataWithTimeout:-1 tag:dREQUEST_TAG];
//}

#pragma mark send request

- (void)sendRequestWithData:(NSString *)requestStr
              onSendHandler:(void(^)(int tag))sendHandler
           onReceiveHandler:(void(^)(int tag, id responseObject))receiveHandler
{
    //int tag = rand();
    //NSString *tagKey = [NSString stringWithFormat:@"%d", tag];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    if (sendHandler)
    {
        [requestDict setValue:[sendHandler copy] forKey:dSEND_HANDLER];
    }
    if (receiveHandler)
    {
        [requestDict setValue:[receiveHandler copy] forKey:dRECEIVE_HANDLER];
        [requestDict setValue:[[NSMutableData alloc] initWithCapacity:0] forKey:dRECEIVE_DATA];
    }
    if ([requestDict count] > 0)
    {
        //[requests setValue:requestDict forKey:tagKey];
        [requests addObject:requestDict];
    }
    
    //发送
    [socket writeData:[requestStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:dREQUEST_TAG];
}

#pragma mark sendHanelerFromTag

- (void)sendHanelerFromTag:(int)tag
{
    if ([requests count] > 0) {
        void (^sendHandler)(int tag) = requests[0][dSEND_HANDLER];
        
        if (sendHandler) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                sendHandler(tag);
            });
            
            if (!requests[0][dRECEIVE_HANDLER]) {
                [requests removeObjectAtIndex:0];
            }
        }
    }
    
}

#pragma mark receiveHanelerFromTag

- (void)receiveHanelerFromTag:(int)tag response:(id)responseObject
{
    
    if ([requests count] > 0) {
        void (^receiveHandler)(int tag, id responseObject) = [requests[0][dRECEIVE_HANDLER] copy];
        [requests removeObjectAtIndex:0];
        
        if (receiveHandler) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                receiveHandler(tag, responseObject);
            });
        }
    }
    
    
}

#pragma mark GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"connect success!");
    [sock readDataWithTimeout:-1 tag:dREQUEST_TAG];
    
    if (self.completeBlock) {
        self.completeBlock(YES);
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"-----didWriteDataWithTag----- %ld", tag);
    
    if ([requests count] > 0) {
        //sendHanelerFromTag
        if (requests[0][dSEND_HANDLER]) {
            [self sendHanelerFromTag:tag];
        }
    }
    
    [socket readDataWithTimeout:-1 tag:dREQUEST_TAG];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"-----didReadData----- %ld", tag);
    
    if ([requests count] > 0) {
        chatData = requests[0][dRECEIVE_DATA];
        [chatData appendData:data];
    } else {
        if (!chatData) {
            chatData = [[NSMutableData alloc] initWithCapacity:0];
        }
        [chatData appendData:data];
    }
    
    NSData *contentData = [chatData subdataWithRange:NSMakeRange(8, chatData.length-8)];
    NSInteger contentLen = [[[NSString alloc] initWithData:[chatData subdataWithRange:NSMakeRange(0, 8)] encoding:NSUTF8StringEncoding] intValue];
    
    if (contentLen == contentData.length) {
        NSError *error;
        id responseObject = [NSJSONSerialization JSONObjectWithData:contentData options:0 error:&error];
        DLog(@"didReadData %@",responseObject);
        if ([responseObject count] > 0) {
            //receiveHanelerFromTag
            [self receiveHanelerFromTag:tag response:responseObject];
        }
    }
    
    [socket readDataWithTimeout:-1 tag:dREQUEST_TAG];
}

- (void)autoLogin
{
    NSDictionary *regDict = @{@"APP_KEY": @"MVTM",
                              @"JYM": @"1002",
                              @"UUID": [Utility stringForKey:@"TOKEN"],
                              @"MAC_TYPE": @"IOS"};
    
    
    NSString *lengthStr = [NSString stringWithFormat:@"%08d", [regDict JSONString].length];
    NSString *sendStr = [NSString stringWithFormat:@"%@%@", lengthStr, [regDict JSONString]];
    
    [self sendRequestWithData:sendStr onSendHandler:^(int tag) {
        
    } onReceiveHandler:^(int tag, id responseObject) {
        DLog(@"responseObject = %@", responseObject);
    }];
    
}

- (void)logout
{
    NSDictionary *regDict = @{@"APP_KEY": @"MVTM",
                              @"JYM": @"1003",
                              @"UUID": [Utility stringForKey:@"TOKEN"]};
    
    
    NSString *lengthStr = [NSString stringWithFormat:@"%08d", [regDict JSONString].length];
    NSString *sendStr = [NSString stringWithFormat:@"%@%@", lengthStr, [regDict JSONString]];
    
    [self sendRequestWithData:sendStr onSendHandler:^(int tag) {
        
    } onReceiveHandler:^(int tag, id responseObject) {
        DLog(@"responseObject = %@", responseObject);
    }];
}

@end
