
//
//  UserViewController.m
//  XMPP
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "XMPPFramework.h"
@interface UserViewController ()
//@property (strong,nonatomic) XMPPStream *xmppStream;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setTitle:@"注销" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
   
    //[self.xmppStream disconect];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
