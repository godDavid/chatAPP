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

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[ServerController shareSever].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // Do any additional setup after loading the view.
    self.messageArray = [NSMutableArray array];
    //self.bubbleData =[NSMutableArray array];
    //[[ServerController shareSever].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 更新聊天记录信息
    [self reloadMessage];
    
}
- (IBAction)exitKeyboard:(id)sender {
    [sender resignFirstResponder];
}

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
    [self.tableView reloadData];
    if (self.messageArray.count) {
        // 判断当前数组的元素个数，代码保护
        // 滑动到UITableView的最底部，保证用户看到的是最新的消息
        NSIndexPath *indexPath
        = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
 
}
- (IBAction)sendAction:(id)sender{
    // 创建消息实体
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.chatToJid];
    
    [message addBody:_chatText.text];
     [[ServerController shareSever].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 发送消息
    [[ServerController shareSever].xmppStream sendElement:message];
   
    
    [self reloadMessage];
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

- (NSInteger)numberOfSectionsInTableView:(UIBubbleTableView *)tableView {
   return 1;
}


- (NSInteger)tableView:(UIBubbleTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
//    NSLog(@"%lu",self.messageArray.count);
}



- (UIBubbleTableViewCell *)tableView:(UIBubbleTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UIBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatcell" forIndexPath:indexPath];

    XMPPMessageArchiving_Message_CoreDataObject *message = self.messageArray[indexPath.row];
    
   
    if (message.isOutgoing == YES) {
        //NSDate *date=[NSDate date];
        NSLog(@"i say:%@",message.body);
        NSLog(@"at time:%@",message.timestamp);
                //cell.detailTextLabel.text = @"";
        NSBubbleData *sendMessage= [NSBubbleData dataWithText:message.body date:message.timestamp type:BubbleTypeMine];
        
        cell.data = sendMessage;
        return cell;
    
        //[self.messageArray addObject:sendMessage];
        //self.tableView.bubbleDataSource = self;
        
    
        
    } else {
        //cell= [cell initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        //cell.textLabel.text = message.body;
        NSLog(@"u say:%@",message.body);
        NSLog(@"at time:%@",message.timestamp);
        NSBubbleData *recieveMessage= [NSBubbleData dataWithText:message.body date:[NSDate dateWithTimeIntervalSince1970:0] type:BubbleTypeSomeoneElse];
        //cell.detailTextLabel.text = @"";
        cell.data=recieveMessage;
        return cell;
    }
    
    
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

@end
