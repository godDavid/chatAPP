//
//  LoginViewController.h
//  XMPP
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *user;

@property (weak, nonatomic) IBOutlet UITextField *pwd;

- (IBAction)loginAction:(id)sender;
//- (void)logout;
@end
