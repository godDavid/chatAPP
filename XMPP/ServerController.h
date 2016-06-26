//
//  ServerController.h
//  XMPP
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPMessageArchiving.h"
#import "MBProgressHUD.h"
@interface ServerController :NSObject<XMPPStreamDelegate,XMPPRosterDelegate>
//@property (nonatomic,strong) NSString *nameRoster;
@property (nonatomic,strong) XMPPStream *xmppStream;
@property (nonatomic,strong) XMPPRoster *xmppRoster;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,assign) NSInteger purpose;
// XMPP聊天消息本地化处理对象
@property (nonatomic ,strong) XMPPMessageArchiving *messageArchiving;
@property (nonatomic ,strong) NSManagedObjectContext *messageContext;
-(void) connect:(NSString*)user :(NSString *)password :(NSInteger)purpose;
//-(void) configureStream;
+ (instancetype)shareSever;
//-(void)logout;
//- (void) hudLabel:(NSString *)text :(void *(^)(void)) myBlock;
@end
