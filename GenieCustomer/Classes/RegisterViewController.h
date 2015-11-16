//
//  RegisterViewController.h
//  GenieCustomer
//
//  Created by Goldman on 4/1/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIImage *img;
}

- (IBAction)onClickSubmit:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txt_full_name;
@property (strong, nonatomic) IBOutlet UITextField *txt_phone;
@property (strong, nonatomic) IBOutlet UITextField *txt_email;
@property (strong, nonatomic) IBOutlet UITextField *txt_password;
@property (strong, nonatomic) IBOutlet UITextField *txt_password_confirm;

@property (strong, nonatomic) IBOutlet UIImageView *img_avatar;

@end
