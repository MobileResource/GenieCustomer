//
//  LoginViewController.h
//  GenieCustomer
//
//  Created by Goldman on 4/1/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txt_email;
@property (strong, nonatomic) IBOutlet UITextField *txt_password;
@property (strong, nonatomic) IBOutlet UIButton *btn_login;
- (IBAction)onClickLogin:(id)sender;

@end
