//
//  LoginViewController.m
//  GenieCustomer
//
//  Created by Goldman on 4/1/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "LoginViewController.h"
#import "UIHelper.h"
#import "UtilitiesHelper.h"
#import "Customer.h"
#import "GVUserDefaults+Properties.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIHelper buildRoundedViewWithRadius:self.btn_login withRadius:3.0f];
    // Do any additional setup after loading the view.
    
    NSString * cs_id = [GVUserDefaults standardUserDefaults].csId;
    if (![UtilitiesHelper IsNullOrEmptyString:cs_id]) {
        self.navigationController.navigationBar.hidden = YES;
        self.navigationController.toolbarHidden = YES;
        [self performSegueWithIdentifier:@"SSID_TO_MAIN_NO_ANIM" sender:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.toolbarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.toolbarHidden = NO;
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

- (IBAction)onClickLogin:(id)sender {
//    [self performSegueWithIdentifier:@"SSID_TO_MAIN" sender:nil];
//    return;
    
    NSString * email = self.txt_email.text;
    NSString * pwd = self.txt_password.text;
    if ([UtilitiesHelper IsNullOrEmptyString:email]) {
        [UIHelper showPromptAlertforTitle:@"Error" withMessage:@"Please enter email" forDelegate:nil];
        return;
    }
    
    if ([UtilitiesHelper IsNullOrEmptyString:pwd]) {
        [UIHelper showPromptAlertforTitle:@"Error" withMessage:@"Please enter password" forDelegate:nil];
        return;
    }
    
    NSDictionary * dict = @{@"email_phone" : email,
                            @"password" : pwd,
                            @"device_token" : [GVUserDefaults standardUserDefaults].device_token};
    
    [Customer loginWithParameters:dict withSuccessBlock:^(NSDictionary *response) {
        if ([response count] == 0) {
            [UIHelper showPromptAlertforTitle:@"Error" withMessage:@"Invalid credential" forDelegate:nil];
        } else {
            [GVUserDefaults standardUserDefaults].csId = [response objectForKey:@"cs_id"];
            [GVUserDefaults standardUserDefaults].csName = [response objectForKey:@"cs_name"];
            [GVUserDefaults standardUserDefaults].csEmail = [response objectForKey:@"cs_email"];
            [GVUserDefaults standardUserDefaults].csImage = [response objectForKey:@"cs_image"];
            [self performSegueWithIdentifier:@"SSID_TO_MAIN" sender:nil];
        }
    } failure:^(NSError *error) {
        [UIHelper showPromptAlertforTitle:@"Error" withMessage:[error localizedDescription] forDelegate:nil];
    } view:self.view];

}
@end
