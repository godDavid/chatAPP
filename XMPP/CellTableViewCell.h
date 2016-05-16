//
//  CellTableViewCell.h
//  XMPP
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellTableViewCell : UITableViewCell

@property(nonatomic, retain) UILabel *senderAndTimeLabel;
//@property(nonatomic, retain) UILabel *textLabel;

@property(nonatomic, retain) UITextView *messageContentView;
@property(nonatomic, retain) UIImageView *bgImageView;

@end
