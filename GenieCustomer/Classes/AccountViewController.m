//
//  AccountViewController.m
//  GenieCustomer
//
//  Created by Goldman on 4/2/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "AccountViewController.h"
#import "UIHelper.h"
#import "Customer.h"
#import "GVUserDefaults+Properties.h"
#import "UtilitiesHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Constants.h"

@interface AccountViewController ()<UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    img = nil;
    
    [self.img_avatar sd_setImageWithURL:[NSURL URLWithString:[UtilitiesHelper getFullImageURL:[GVUserDefaults standardUserDefaults].csImage]] placeholderImage:[UIImage imageNamed:@"empty_photo.png"]];
    
    [UIHelper buildCircleImageView:self.img_avatar];
    [UIHelper buildRoundedViewWithRadius:self.btn_save withRadius:3.0f];
    [self.txt_email setText:[GVUserDefaults standardUserDefaults].csEmail];
    [self.txt_name setText:[GVUserDefaults standardUserDefaults].csName];
    
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped)];
    singleTap.numberOfTapsRequired = 1;
    [self.img_avatar setUserInteractionEnabled:YES];
    [self.img_avatar addGestureRecognizer:singleTap];
    
    // Do any additional setup after loading the view.
}

-(void)singleTapped{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Select image" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Camera", @"Album", nil];

    [alert show];
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

- (IBAction)onClickSave:(id)sender {
    NSString * name = self.txt_name.text;
    NSString * email = self.txt_email.text;
    if ([UtilitiesHelper IsNullOrEmptyString:name]) {
        [UIHelper showPromptAlertforTitle:@"Warning" withMessage:@"Please enter name" forDelegate:nil];
        return;
    }
    
    if ([UtilitiesHelper IsNullOrEmptyString:email]) {
        [UIHelper showPromptAlertforTitle:@"Warning" withMessage:@"Please enter email" forDelegate:nil];
        return;
    }
    
    NSDictionary * param = @{@"cs_id" : [GVUserDefaults standardUserDefaults].csId,
                             @"email" : email,
                             @"name" : name};
    if (img == nil) {
        [Customer updateProfileParameters:param withSuccessBlock:^(NSDictionary *response) {
            
            [GVUserDefaults standardUserDefaults].csEmail = email;
            [GVUserDefaults standardUserDefaults].csName = name;
            
            [UIHelper showPromptAlertforTitle:@"Success" withMessage:@"Updated successfully!" forDelegate:nil];
        } failure:^(NSError *error) {
            [UIHelper showPromptAlertforTitle:@"Error" withMessage:[error localizedDescription] forDelegate:nil];
        } view:self.view];
    } else{
        NSData * photoData = UIImageJPEGRepresentation(img, 1.0f);
        
        [Customer updateProfileParametersWithImageData:param imageData:photoData imageDataParam:@"image" withSuccessBlock:^(NSDictionary *response) {
            [GVUserDefaults standardUserDefaults].csEmail = email;
            [GVUserDefaults standardUserDefaults].csName = name;
            [GVUserDefaults standardUserDefaults].csImage = [response objectForKey:@"cs_image"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:GCNotificationAvatarChanged object:nil];
            
            [UIHelper showPromptAlertforTitle:@"Success" withMessage:@"Updated successfully!" forDelegate:nil];
        } failure:^(NSError *error) {
            [UIHelper showPromptAlertforTitle:@"Error" withMessage:[error localizedDescription] forDelegate:nil];
        } view:self.view];
    }
}
@end
