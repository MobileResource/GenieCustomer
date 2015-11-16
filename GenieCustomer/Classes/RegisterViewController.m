//
//  RegisterViewController.m
//  GenieCustomer
//
//  Created by Goldman on 4/1/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIHelper.h"
#import "UtilitiesHelper.h"
#import "UIAlertView+Starlet.h"
#import "GVUserDefaults+Properties.h"
#import "Customer.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface RegisterViewController ()<UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSMutableArray * arr_images;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIHelper buildCircleImageView:self.img_avatar];
    
    self.arr_images = [NSMutableArray array];
    
    img = nil;
    
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped)];
    singleTap.numberOfTapsRequired = 1;
    [self.img_avatar setUserInteractionEnabled:YES];
    [self.img_avatar addGestureRecognizer:singleTap];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.toolbarHidden = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.toolbarHidden = YES;
}

-(void)singleTapped{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Select image" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Camera", @"Album", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickSubmit:(id)sender {
    NSString * full_name = self.txt_full_name.text;
    NSString * phone = self.txt_phone.text;
    NSString * email = self.txt_email.text;
    NSString * pwd = self.txt_password.text;
    NSString * pwd_confirm = self.txt_password_confirm.text;
    
    if ([UtilitiesHelper IsNullOrEmptyString:full_name]) {
        [UIHelper showPromptAlertforTitle:@"Warning" withMessage:@"Please enter full name" forDelegate:nil];
        return;
    }
    
    if ([UtilitiesHelper IsNullOrEmptyString:phone]) {
        [UIHelper showPromptAlertforTitle:@"Warning" withMessage:@"Please enter phone number" forDelegate:nil];
        return;
    }
    
    if ([UtilitiesHelper IsNullOrEmptyString:email]) {
        [UIHelper showPromptAlertforTitle:@"Warning" withMessage:@"Please enter email" forDelegate:nil];
        return;
    }
    
    if ([UtilitiesHelper IsNullOrEmptyString:pwd]) {
        [UIHelper showPromptAlertforTitle:@"Warning" withMessage:@"Please enter password" forDelegate:nil];
        return;
    }
    
    if (![pwd isEqualToString:pwd_confirm]) {
        [UIHelper showPromptAlertforTitle:@"Warning" withMessage:@"Password does not match" forDelegate:nil];
        return;
    }
    
    NSDictionary * dict;
    dict = @{@"name" : full_name,
             @"phone" : phone,
             @"email" : email,
             @"device_token" : [GVUserDefaults standardUserDefaults].device_token,
             @"password" : pwd,
             @"device_type":  @"ios"};
    
    if (img == nil) {
        [Customer registerWithParameters:dict withSuccessBlock:^(NSDictionary *response) {
            [GVUserDefaults standardUserDefaults].csId = [response objectForKey:@"cs_id"];
            [GVUserDefaults standardUserDefaults].csName = [response objectForKey:@"cs_name"];
            [GVUserDefaults standardUserDefaults].csEmail = [response objectForKey:@"cs_email"];
            [GVUserDefaults standardUserDefaults].csImage = [response objectForKey:@"cs_image"];
            
            //[UIHelper showPromptAlertforTitle:@"Success" withMessage:@"Registered Successfully!" forDelegate:nil];
            [UIAlertView showMessage:@"Registered Successfully!" complete:^(NSInteger buttonIndex) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            
        } failure:^(NSError *error) {
            [UIHelper showPromptAlertforTitle:@"Error" withMessage:[error localizedDescription] forDelegate:nil];
        } view:self.view];
    } else {
        NSData * photoData = UIImageJPEGRepresentation(img, 1.0f);
        
        [Customer registerWithParametersWithImage:dict imageData:photoData imageDataParam:@"image" withSuccessBlock:^(NSDictionary *response) {
            [GVUserDefaults standardUserDefaults].csId = [response objectForKey:@"cs_id"];
            [GVUserDefaults standardUserDefaults].csName = [response objectForKey:@"cs_name"];
            [GVUserDefaults standardUserDefaults].csEmail = [response objectForKey:@"cs_email"];
            [GVUserDefaults standardUserDefaults].csImage = [response objectForKey:@"cs_image"];
            
            [UIAlertView showMessage:@"Registered Successfully!" complete:^(NSInteger buttonIndex) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            
            //            [UIHelper showPromptAlertforTitle:@"Success" withMessage:@"Registered Successfully!" forDelegate:nil];
        } failure:^(NSError *error) {
            [UIHelper showPromptAlertforTitle:@"Error" withMessage:[error localizedDescription] forDelegate:nil];
        } view:self.view];
    }
}

#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        if ([alertView.title isEqualToString:@"Success"]) {
            
        }
        
    } else if (buttonIndex == 2){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setMediaTypes:[NSArray arrayWithObject:(NSString*)kUTTypeImage]];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [picker setAllowsEditing:YES];
        [picker setDelegate:self];
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    } else if (buttonIndex == 1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setMediaTypes:[NSArray arrayWithObject:(NSString*)kUTTypeImage]];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [picker setAllowsEditing:YES];
        [picker setDelegate:self];
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@",info);
    [picker dismissViewControllerAnimated:YES completion:^{
        img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        img = [UtilitiesHelper imageWithImage:img scaledToSize:CGSizeMake(200, 200)];
        self.img_avatar.image = img;
    }];
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
