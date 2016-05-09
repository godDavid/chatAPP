//
//  HudViewController.m
//  XMPP
//
//  Created by mac on 16/5/8.
//  Copyright © 2016年 davidliu. All rights reserved.
//

#import "HudViewController.h"
#import "MBProgressHUD.h"
@interface HudViewController ()

@end

@implementation HudViewController
- (void) hudLabel:(NSString *)text :(void (^)(void)) myBlock :(UIView *)view{
    UIView *a=self.navigationController.view;
    NSLog(@"%@",a);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText =NSLocalizedString(text, @"HUD loading title");
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            myBlock();
            [hud hide:YES];
        });
    });
    
}
- (void) hudtext:(NSString *) text :(void (^)(void)) myBlock :(UIView *) view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(text, @"HUD message title");
    // Move to bottm center.
    //hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    myBlock();
    
    [hud hide:YES afterDelay:1];
}
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

@end
