//
//  ChatViewController.m
//  XMPP
//
//  Created by mac on 16/3/25.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import "ChatViewController.h"

#import "ServerController.h"
#import "UIBubbleHeaderTableViewCell.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
@interface ChatViewController ()
@property (nonatomic ,strong) NSMutableArray *messageArray;
//@property (nonatomic ,strong) NSMutableArray *bubbleData;
@property (nonatomic ,strong) NSString *sendMessage;
@property (nonatomic ,strong) NSString *message;
//@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic,assign) NSInteger section;
//@property (weak, nonatomic) IBOutlet UIButton *mButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@property (weak, nonatomic) IBOutlet UIView *inputView;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[ServerController shareSever].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // Do any additional setup after loading the view.
    self.messageArray = [NSMutableArray array];
    self.tableView.bubbleDataSource = self;
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"吱吱"]];
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    self.tableView.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    //bubbleTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    self.tableView.typingBubble = NSBubbleTypingTypeSomebody;
    //self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView reloadData];

    //self.bubbleData =[NSMutableArray array];
    //[[ServerController shareSever].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 更新聊天记录信息
    [self reloadMessage];
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    backBtn.frame = CGRectMake(0, 0, 30, 30);
//    [backBtn setTitle:@"发送" forState:UIControlStateNormal];
//    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolBar addSubview:backBtn];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.chatText becomeFirstResponder];
    [self.chatText resignFirstResponder];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}
/**
 *  键盘工具条处理：constant方式
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note{
    // 获得键盘的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改工具条底部约束
    self.bottom.constant = [UIScreen mainScreen].bounds.size.height - frame.origin.y;
    
    // 获得键盘弹出或隐藏时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 添加动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}


/**
 *  点击屏幕任意位置退出键盘
 */

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.chatText becomeFirstResponder];
//    [self.chatText resignFirstResponder];
//}

- (void)reloadMessage
{
    [[ServerController shareSever].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];

    NSManagedObjectContext *context = [ServerController shareSever].messageContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    /** 获取所有的聊天记录 */
    // 这里面要填的是XMPPARCHiver的coreData实例类型
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    // 对取到的数据进行过滤,传入过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr==%@ AND bareJidStr == %@", [ServerController shareSever].xmppStream.myJID.bare,self.chatToJid.bare];
    [fetchRequest setPredicate:predicate];
    //NSLog(@"-----%@",fetchRequest);
    // Specify how the fetched objects should be sorted
    // 设置排序的关键字
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        // 完成之后
        NSLog(@"I'll be back!");
    }
//    self.bubbleData =[NSMutableArray array];
//    [self.bubbleData removeAllObjects];
//    [self.bubbleData addObjectsFromArray:fetchedObjects];
    
    // 清空消息数组里的所有数据
    [self.messageArray removeAllObjects];
    // 将新的聊天记录添加到数组中
    [self.messageArray addObjectsFromArray:fetchedObjects];
    
    NSArray *arrayTemp = [self.messageArray copy];
    NSLog(@"%lu",(unsigned long)arrayTemp.count);
    for (int i = 0;i<arrayTemp.count;i++) {
        XMPPMessageArchiving_Message_CoreDataObject *message = [arrayTemp objectAtIndex:i];
        if (message.isOutgoing==YES) {
            NSBubbleData *sendMessage= [NSBubbleData dataWithText:message.body date:message.timestamp type:BubbleTypeMine];
            [self.messageArray replaceObjectAtIndex:i withObject:sendMessage];
            NSLog(@"i say ----%d----%@",i,sendMessage);
            
        } else {
            NSBubbleData *recieveMessage= [NSBubbleData dataWithText:message.body date:message.timestamp type:BubbleTypeSomeoneElse];
            [self.messageArray replaceObjectAtIndex:i withObject:recieveMessage];
        }
    }
    //for (int i = 0;i<self.messageArray.count;i++) {
        [self.tableView reloadData];
    //}
    if (self.messageArray.count) {
        // 判断当前数组的元素个数，代码保护
        // 滑动到UITableView的最底部，保证用户看到的是最新的消息
        self.section = [self.tableView.bubbleSection count]-1;   //获取section数量
        NSIndexPath *indexPath
        = [NSIndexPath indexPathForRow:[[self.tableView.bubbleSection objectAtIndex:self.section] count] - 1 inSection:self.section];
        //[[self.bubbleSection objectAtIndex:section] count]
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    //self.tableView.showAvatars = YES;
    
//    if (self.messageArray.count) {
//        // 判断当前数组的元素个数，代码保护
//        // 滑动到UITableView的最底部，保证用户看到的是最新的消息
//        NSIndexPath *indexPath
//        = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//    
 
}
- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    NSLog(@"row are -------%lu",(unsigned long)self.messageArray.count);
    return [self.messageArray count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    
    NSLog(@"row %ld  data is -------%@",(long)row,[self.messageArray objectAtIndex:row]);
    return [self.messageArray objectAtIndex:row];
}
- (IBAction)sendAction:(id)sender{
    // 创建消息实体
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.chatToJid];
    
    [message addBody:_chatText.text];
     [[ServerController shareSever].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 发送消息
    [[ServerController shareSever].xmppStream sendElement:message];
   
    
    [self reloadMessage];
     self.chatText.text = @"";
    //[self.chatText resignFirstResponder];
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    
    NSLog(@"%s__%d__|message = %@", __FUNCTION__, __LINE__,message);
    //NSManagedObjectContext *context =[ServerController shareSever].messageContext;
    
    [self reloadMessage];
}

//  收到他人发送的消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"%s__%d__|message = %@", __FUNCTION__, __LINE__,message);
    [self reloadMessage];
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error
{
    NSLog(@"发送失败------%@",error);
}

//- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
//{
//    return [self.messageArray count];
//}
//
//- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
//{
//    return [self.messageArray objectAtIndex:row];
//}



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

@end
