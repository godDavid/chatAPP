//
//  HudViewController.h
//  XMPP
//
//  Created by mac on 16/5/8.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HudViewController : UIViewController
- (void) hudLabel:(NSString *)text :(void (^)(void)) myBlock :(UIView *) view;
- (void) hudtext:(NSString *) text :(void (^)(void)) myBlock :(UIView *) view;
@end
