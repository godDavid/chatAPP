//
//  ChatViewController.h
//  XMPP
//
//  Created by mac on 16/3/25.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerController.h"
//#import "CellTableViewCell.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
@interface ChatViewController : UIViewController
@property (strong,nonatomic) XMPPJID *chatToJid;
@property (strong,nonatomic) IBOutlet UIBubbleTableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *chatText;

- (IBAction)sendAction:(id)sender;
//- (IBAction)closeKey:(id)sender;
@end
