
//
//  UserViewController.m
//  XMPP
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "ServerController.h"
#import "ChatViewController.h"
//#import "XMPPFramework.h"
@interface UserViewController ()<XMPPRosterDelegate,UITableViewDelegate, UITableViewDataSource>

@end

@implementation UserViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"吱吱"]];
    self.rosterJids = [[NSMutableArray alloc]init];
    ServerController *conn=[ServerController shareSever];
    [conn.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // Do any additional setup after loading the view.
     UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setTitle:@"11111" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"11111%@",self.rosterJids);
    return self.rosterJids.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"124");
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    //NSLog(@"123");
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    XMPPJID *jid=self.rosterJids[indexPath.row];
    
    cell.textLabel.text = jid.user;
    //NSLog(@"12345%@",jid.domain);
    return cell;
}
-(void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender{
    NSLog(@"开始检索好友列表");
}
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item{
    NSLog(@"检索好友列表");
    
    NSLog(@"%@",item);
    //NSString *groupString = [self encodeWithCoder:
    NSString *jidString = [[item attributeForName:@"jid"] stringValue];
    NSString *groupString = [[item attributeForName:@"group"] stringValue];
    XMPPJID *jid = [XMPPJID jidWithUser:jidString domain:@"127.0.0.1" resource:@"openfire1"];
    // 存储到数组
    [self.rosterJids addObject:jid];
    NSLog(@"%@",self.rosterJids);
    //NSString *liu=@"liudawei";
    // 更新到UI界面
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.rosterJids.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
}
-(void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{
    NSLog(@"结束检索好友列表");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)sender;
    // 拿到下一步要跳转的Controller对象
    ChatViewController *cVC = segue.destinationViewController;
    // 判断选中的cell在当前的table中的位置
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    cVC.chatToJid = self.rosterJids[path.row];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)logout{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];//向服务器发送离线消息
    [[ServerController shareSever].xmppStream sendElement:presence];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    [[ServerController shareSever].xmppStream disconnect];
    
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
