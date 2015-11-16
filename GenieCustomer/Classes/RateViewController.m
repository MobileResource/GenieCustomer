//
//  RateViewController.m
//  GenieCustomer
//
//  Created by Goldman on 4/29/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "RateViewController.h"
#import "UIHelper.h"
#import "DCPopupSegue.h"
#import "Customer.h"
#import "UtilitiesHelper.h"
#import "GVUserDefaults+Properties.h"
#import "UIAlertView+Starlet.h"

@interface RateViewController ()<TPFloatRatingViewDelegate>{
    BOOL showKeybard;
}

@end

@implementation RateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    showKeybard = NO;
    
    self.frv_rating.emptySelectedImage = [UIImage imageNamed:@"btn_star_empty.png"];
    self.frv_rating.fullSelectedImage = [UIImage imageNamed:@"btn_star.png"];
    self.frv_rating.contentMode = UIViewContentModeScaleAspectFill;
    self.frv_rating.maxRating = 5;
    self.frv_rating.minRating = 0;
    self.frv_rating.editable = YES;
    self.frv_rating.floatRatings = YES;
    self.frv_rating.halfRatings = NO;
    self.frv_rating.delegate = self;
    
    self.frv_rating.rating = self.current_rating;
    
    [self.lbl_rate setText:[NSString stringWithFormat:@"Rate( %.1f )", self.current_rating]];
    
    [self.txt_comment setText:self.current_comment];
    
    // Do any additional setup after loading the view.
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeButtonPressed:)];
    singleTap.numberOfTapsRequired = 1;
    [self.dismiss_view setUserInteractionEnabled:YES];
    [self.dismiss_view addGestureRecognizer:singleTap];
    
    [UIHelper buildRoundedViewWithRadius:self.btn_ok withRadius:3.0f];
    [UIHelper buildRoundedViewWithRadius:self.btn_cancel withRadius:3.0f];
    [UIHelper buildRoundedViewWithRadius:self.rate_view withRadius:5.0f];
    
    [UIHelper buildRoundedViewWithRadiusAndBorderColor:self.txt_comment withRadius:0.0f borderWidth:0.5f borderColor:[UIColor blackColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

 -(void)keyboardDidShow:(NSNotification*)notification{
     if (showKeybard) {
         return;
     }
 self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 100.0, self.view.frame.size.width, self.view.frame.size.height);
     showKeybard = YES;
 }
 
 -(void)keyboardDidHide:(NSNotification*)notification{
     showKeybard = NO;
 self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 100.0, self.view.frame.size.width, self.view.frame.size.height);
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

- (IBAction)onClickOK:(id)sender {
    
    NSString * comment = self.txt_comment.text;
    if ([UtilitiesHelper IsNullOrEmptyString:comment]) {
        [UIHelper showPromptAlertforTitle:@"Warning" withMessage:@"Please input feedback" forDelegate:nil];
        return;
    }
    
    NSDictionary * dict = @{@"cs_id" : [GVUserDefaults standardUserDefaults].csId,
                            @"pv_id" : [self.dict objectForKey:@"pv_id"],
                            @"rate" : @(self.current_rating),
                            @"comment" : comment};
    
    [Customer rateProviderWithParameters:dict withSuccessBlock:^(NSDictionary *response) {
        [UIAlertView showMessage:@"Rated Successfully!" complete:^(NSInteger buttonIndex) {
            DCPopupSegue *dismissSegue = [[DCPopupSegue alloc] initWithIdentifier:@"DismissPopup" source:self destination:self];
            [dismissSegue performWithDismiss:1];
        }];
    } failure:^(NSError *error) {
        [UIHelper showPromptAlertforTitle:@"Error" withMessage:[error localizedDescription] forDelegate:nil];
    } view:self.view];
   
}

- (IBAction)onClickCancel:(id)sender {
    DCPopupSegue *dismissSegue = [[DCPopupSegue alloc] initWithIdentifier:@"DismissPopup" source:self destination:self];
    [dismissSegue performWithDismiss:0];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self onClickCancel:nil];
}

#pragma mark - TPFloatRatingViewDelegate

-(void)floatRatingView:(TPFloatRatingView *)ratingView continuousRating:(CGFloat)rating{
    [self.lbl_rate setText:[NSString stringWithFormat:@"Rate( %.1f )", rating]];
    self.current_rating = rating;
}

@end
