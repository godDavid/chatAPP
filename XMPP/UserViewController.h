//
//  UserViewController.h
//  XMPP
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *rosterJids;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
