//
//  ChangePasswordViewController.m
//  GenieProvider
//
//  Created by Goldman on 3/24/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UtilitiesHelper.h"
#import "Customer.h"
#import "UIHelper.h"
#import "GVUserDefaults+Properties.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

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

- (IBAction)onClickDone:(id)sender {
    NSString* old_pwd = self.txt_old_pwd.text;
    NSString* new_pwd = self.txt_new_pwd.text;
    NSString* confirm_pwd = self.txt_pwd_confirm.text;
    if ([UtilitiesHelper IsNullOrEmptyString:old_pwd]) {
        [UIHelper showPromptAlertforTitle:@"Warning" withMessage:@"Please enter current password" forDelegate:nil];
        return;
    }
    
    if ([UtilitiesHelper IsNullOrEmptyString:new_pwd]) {
        [UIHelper showPromptAlertforTitle:@"Warning" withMessage:@"Please new password" forDelegate:nil];
        return;
    }
    
    if (![new_pwd isEqualToString:confirm_pwd]) {
        [UIHelper showPromptAlertforTitle:@"Warning" withMessage:@"New password does not match" forDelegate:nil];
        return;
    }
    
    NSDictionary * dict = @{@"cs_id" : [GVUserDefaults standardUserDefaults].csId,
                            @"old_pwd" : old_pwd,
                            @"new_pwd" : new_pwd};
    
    [Customer changePasswordParameters:dict withSuccessBlock:^(NSDictionary *response) {
        [UIHelper showPromptAlertforTitle:@"Success" withMessage:@"Password changed successfully!" forDelegate:nil];
    } failure:^(NSError *error) {
        [UIHelper showPromptAlertforTitle:@"Error" withMessage:[error localizedDescription] forDelegate:nil];
    } view:self.view];
    
}
@end
