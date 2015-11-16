//
//  AccountViewController.h
//  GenieCustomer
//
//  Created by Goldman on 4/2/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController{
    UIImage * img;
}
@property (strong, nonatomic) IBOutlet UIImageView *img_avatar;
@property (strong, nonatomic) IBOutlet UITextField *txt_name;
@property (strong, nonatomic) IBOutlet UITextField *txt_email;
@property (strong, nonatomic) IBOutlet UIButton *btn_save;
- (IBAction)onClickSave:(id)sender;

@end
