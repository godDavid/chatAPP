//
//  ServerController.m
//  XMPP
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import "ServerController.h"
//#import "UIKit.h"
static NSString *USER=@"user1";
static NSString *PASS=@"pass1";
@interface ServerController ()


@end

@implementation ServerController
- (void) hudLabel:(NSString *)text :(void *(^)(void)) myBlock{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText =NSLocalizedString(text, @"HUD loading title");
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            myBlock();
            [hud hide:YES afterDelay:1];
        });
    });
    
}
//单例方法
+ (instancetype)shareSever{
    static ServerController *sc=nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sc = [[ServerController alloc]init];
    });
    return sc;
}

-(void) connect:(NSString *)user :(NSString *)password :(NSInteger)purpose{
    //创建XMPP Stream
    self.xmppStream = [[XMPPStream alloc] init];
    //设置服务器地址，如果没有设置，则通过JID获取服务器地址
    
    //设置代理，多播代理（可以设置多个代理对象）
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.password=password;
    self.purpose=purpose;
    
    if(![self.xmppStream isConnected]){
    XMPPJID *jid = [XMPPJID jidWithUser:user domain:@"127.0.0.1" resource:@"openfire1"];
    [self.xmppStream setMyJID:jid];
    [self.xmppStream setHostName:@"127.0.0.1"];
    }
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    //NSError *error = nil;
    if (error) {
        NSLog(@"error = %@",error);
    }
    

}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"连接服务器失败的方法，请检查网络是否正常");
    
    NSLog(@"连接服务器失败的方法，请检查网络是否正常");
    
}
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    NSLog(@"连接成功");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    NSLog(@"再发送密码授权");
    NSError *err = nil;
    switch (self.purpose) {
        case 1:
            [_xmppStream authenticateWithPassword:self.password error:&err];
            break;
        case 2:
            [_xmppStream registerWithPassword:self.password error:&err];
            
        default:
            break;
    }
   
    
    if (err) {
        NSLog(@"%@",err);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [_xmppStream sendElement:presence];
    NSLog(@"登陆成功%@",presence);
    
}

-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"授权失败 %@",error);
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆失败" message:@"账号密码错误”"preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    //[alert addAction:cancelAction];
    //[alert addAction:okAction];
    //[self presentViewController:alert animated:YES completion:nil];
    [_xmppStream disconnect];
    
}
- (void) xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    
}
- (void) xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败");
}
- (void) registerAction:(NSString *)user :(NSString *)password{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) logout{
    //注销
    [self.xmppStream disconnect];
}

@end
