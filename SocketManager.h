//
//  SocketManager.h
//  Socket
//
//  Created by ccxdd on 13-9-1.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocketManagerDelegate <NSObject>
@required
- (void)updateToChatView:(NSDictionary *)dict;
@end

@interface SocketManager : NSObject

@property (nonatomic, assign) id <SocketManagerDelegate> delegate;

+ (SocketManager *)sharedInstance;

- (void)connectCompleteBlock:(void (^)(BOOL isConnect))completeBlock;

- (BOOL)isConnect;

- (void)disconnectCompleteBlock:(void (^)(BOOL isConnect))completeBlock;

- (void)autoLogin;

- (void)logout;

//不接收数据时receiveHandler:必须设为nil
- (void)sendRequestWithData:(NSString *)requestStr
              onSendHandler:(void(^)(int tag))sendHandler
           onReceiveHandler:(void(^)(int tag, id responseObject))receiveHandler;

@end
