
//
//  RegViewController.m
//  XMPP
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import "RegViewController.h"
#import "ServerController.h"
#import "HudViewController.h"
@interface RegViewController ()

@end

@implementation RegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)RegiterAction:(id)sender {
    if(_password.text.length==0 |_user.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名和密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        ServerController *conn =[ServerController shareSever];
        //[conn configureStream];
        [conn connect:_user.text:_password.text:2];
        [conn.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
    }
}

//代理方法
- (void) xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    HudViewController *hud2=[[HudViewController alloc]init];
    UIView *a =self.navigationController.view;
    void  (^myBlock)(void)=^{
        
    };
    [hud2  hudtext:@"注册成功" :myBlock :a];
    
    
}
- (void) xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败");
    HudViewController *hud2=[[HudViewController alloc]init];
    UIView *a =self.navigationController.view;
    void  (^myBlock)(void)=^{
        
    };
    [hud2  hudtext:@"注册失败" :myBlock :a];
}

@end
