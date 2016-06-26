//
//  LoginViewController.m
//  XMPP
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import "LoginViewController.h"
#import "XMPPFramework.h"
#import "ServerController.h"
#import "UserViewController.h"
#import "HudViewController.h"
#import "MBProgressHUD.h"
static NSString *USER=@"user";
static NSString *PASS=@"pass";
@interface LoginViewController ()<XMPPStreamDelegate>
//@property (strong,nonatomic) XMPPStream *xmppStream;
//@property (strong, nonatomic) IBOutlet UIView *view;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.pwd setSecureTextEntry:YES];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"吱吱"]];
    // Do any additional setup after loading the view.
    //[[ServerController shareSever].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    if(self.user.isFirstResponder){
        [self.user resignFirstResponder];
    }
    else if(self.pwd.isFirstResponder){
        [self.pwd resignFirstResponder];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exitKeyboard:(id)sender {
    [sender resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginAction:(id)sender {
    if(_pwd.text.length==0 |_user.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名和密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        ServerController *conn =[ServerController shareSever];
        HudViewController *hud1=[[HudViewController alloc]init];
        UIView *a =self.navigationController.view;     // 纪录当前的导航view做参数传递
        void  (^myBlock)(void)=^{        //定义block
           [conn connect:_user.text:_pwd.text:1];
           [conn.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        };
        [hud1 hudLabel:@"loading..." :myBlock :a];  //调用loadingHUD
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//
//        // Set the label text.
//        hud.labelText = NSLocalizedString(@"Loading...", @"HUD loading title");
//        // You can also adjust other label properties if needed.
//        // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
//        
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//            ServerController *conn =[ServerController shareSever];
//            //[conn configureStream];
//            [conn connect:_user.text:_pwd.text:1];
//            [conn.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hide:YES];
//            });
//        });
          
    
    }
    
}

-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"连接服务器失败，请检查网络是否正常");
}
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    [self performSegueWithIdentifier:@"segue" sender:self]; //跳转到登录成功页面
    NSLog(@"now ---%@",self);
//     HudViewController *hud2=[[HudViewController alloc]init];
//     UIView *a =self.navigationController.view;
//      void  (^myBlock)(void)=^{
//          
//        };
//     [hud2  hudtext:@"登陆成功" :myBlock :a];
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"------prepareForSegue------");
    UserViewController *uv=segue.destinationViewController;
    uv.navigationItem.hidesBackButton=YES;
}
//- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
//    
//}
//- (void)xmppStreamDidConnect:(XMPPStream *)sender{
//    
//    NSLog(@"再发送密码授权");
//    NSError *err = nil;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *pwd = [defaults objectForKey:PASS];
//    [_xmppStream authenticateWithPassword:pwd error:&err];
//    if (err) {
//        NSLog(@"%@",err);
//    }
//}
//
//- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
//    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
//    [self.xmppStream sendElement:presence];
//    NSLog(@"登陆成功%@",presence);
//    [self performSegueWithIdentifier:@"segue" sender:self];
//}
//
//-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
//    NSLog(@"授权失败 %@",error);
//     //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆失败" message:@"账号密码错误”"preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
//    [alert addAction:cancelAction];
//    [alert addAction:okAction];
//    [self presentViewController:alert animated:YES completion:nil];
//    [self.xmppStream disconnect];
//
//}
//
//
//
//- (void)connect {
////    if (self.xmppStream == nil) {
////        self.xmppStream = [[XMPPStream alloc] init];
////        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
////    }
////    if (![self.xmppStream isConnected]) {
////        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
////        XMPPJID *jid = [XMPPJID jidWithUser:username domain:@"root" resource:@"openfire1"];
////        [self.xmppStream setMyJID:jid];
////        [self.xmppStream setHostName:@"127.0.0.1"];
////        NSError *error = nil;
////        if (![self.xmppStream connectWithTimeout:4.0 error:&error]) {
////            NSLog(@"Connect Error: %@", [[error userInfo] description]);
////        }
////    }
//}
@end
