//
//  ServerController.m
//  XMPP
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import "ServerController.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
static NSString *USER=@"user1";
static NSString *PASS=@"pass1";
@interface ServerController ()


@end

@implementation ServerController

//单例方法
+ (instancetype)shareSever{
    static ServerController *sc=nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sc = [[ServerController alloc]init];
    });
    return sc;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        self.xmppStream = [[XMPPStream alloc]init];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        XMPPRosterCoreDataStorage *rosterCoreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
        self.xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:rosterCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        //激活
        [self.xmppRoster activate:self.xmppStream];
        [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        // 初始化聊天记录管理对象
        XMPPMessageArchivingCoreDataStorage * archiving = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        self.messageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:archiving dispatchQueue:dispatch_get_main_queue()];
        // 激活管理对象
        [self.messageArchiving activate:self.xmppStream];
        // 给管理对象添加代理
        
        [self.messageArchiving addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        self.messageContext = archiving.mainThreadManagedObjectContext;
        
        //3.保存聊天记录
        //初始化一个仓库
       
        
   
    }
    return self;
}
-(void) connect:(NSString *)user :(NSString *)password :(NSInteger)purpose{
    //创建XMPP Stream
    //self.xmppStream = [[XMPPStream alloc] init];
    //设置服务器地址，如果没有设置，则通过JID获取服务器地址
    
    //设置代理，多播代理（可以设置多个代理对象）
    //[self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.password=password;
    self.purpose=purpose;
    
    if([self.xmppStream isConnected]){
        [self.xmppStream disconnect];
    }
    XMPPJID *jid = [XMPPJID jidWithUser:user domain:@"127.0.0.1" resource:@"openfire1"];
    [self.xmppStream setMyJID:jid];
    [self.xmppStream setHostName:@"127.0.0.1"];
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
//#pragma mark 开始检索好友列表的方法
//-(void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender{
//    NSLog(@"开始检索好友列表");
//}
//-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item{
//    NSLog(@"检索好友列表");
//}
//-(void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{
//    NSLog(@"结束检索好友列表");
//}
- (void) XMPPAddFriendSubscribe:(NSString *)name{
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%s",name,"127.0.0.1"]];
    //[presence addAttributeWithName:@"subscription" stringValue:@"好友"];
    [self.xmppRoster subscribePresenceToUser:jid];
}

@end
