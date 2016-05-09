//
//  ServerController.h
//  XMPP
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "MBProgressHUD.h"
@interface ServerController :UIViewController <XMPPStreamDelegate>
@property (nonatomic,strong) XMPPStream *xmppStream;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,assign) NSInteger purpose;
-(void) connect:(NSString*)user :(NSString *)password :(NSInteger)purpose;
//-(void) configureStream;
+ (instancetype)shareSever;
- (void) hudLabel:(NSString *)text :(void *(^)(void)) myBlock;
@end
