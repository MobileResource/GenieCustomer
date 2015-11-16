//
//  ProviderDetailViewController.m
//  GenieCustomer
//
//  Created by Goldman on 4/1/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "ProviderDetailViewController.h"
#import "UIHelper.h"
#import "UtilitiesHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JSQMessagesViewController.h"
#import "UIAlertView+Starlet.h"
#import "GVUserDefaults+Properties.h"
#import "Customer.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "RateViewController.h"
#import "ReviewTableViewCell.h"
#import "DCPopupSegue.h"
#import "AppDelegate.h"

@interface ProviderDetailViewController ()<UITableViewDataSource, UITableViewDelegate, DCPopupDismissDelegate>{
    NSMutableArray * arr_rates;
    float my_rate;
    NSString * my_comment;
}

@end

@implementation ProviderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arr_rates = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
    [UIHelper buildCircleImageView:self.img_provider];
    [UIHelper buildRoundedViewWithRadius:self.btn_hire withRadius:3.0f];
    [UIHelper buildRoundedViewWithRadius:self.lbl_name withRadius:10.0f];
    
    [self.img_provider sd_setImageWithURL:[NSURL URLWithString:[UtilitiesHelper getFullImageURL:[self.dict objectForKey:@"pv_image"]]] placeholderImage:[UIImage imageNamed:@"empty_photo.png"]];
    [self.lbl_name setText:[self.dict objectForKey:@"pv_business_name"]];
    
    [self.lbl_business_name setText:[self.dict objectForKey:@"pv_business_name"]];
    [self.lbl_full_name setText:[self.dict objectForKey:@"pv_name"]];
    [self.lbl_business_address setText:[self.dict objectForKey:@"pv_business_address"]];
    [self.lbl_phone setText:[self.dict objectForKey:@"pv_phone"]];
    [self.lbl_postal_code setText:[self.dict objectForKey:@"pv_postal_code"]];
    [self.lbl_website setText:[self.dict objectForKey:@"pv_website"]];
    
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped)];
    singleTap.numberOfTapsRequired = 1;
    [self.img_chat setUserInteractionEnabled:YES];
    [self.img_chat addGestureRecognizer:singleTap];
    
    self.btn_review.hidden = YES;
    
    if ([[self.dict objectForKey:@"status"] isEqualToString:@"won"]) {
        [self.btn_hire setBackgroundColor:[UIHelper colorWithRGB:233.0f g:33.0f b:71.0f]];
        [self.btn_hire setTitle:@"Hired" forState:UIControlStateNormal];
        self.btn_review.hidden = NO;
    } else if (self.isHired){
        self.btn_hire.hidden = YES;
    }
    
    self.profile_view.hidden = NO;
    self.tbl_reviews.hidden = YES;
    
    self.tbl_reviews.delegate = self;
    self.tbl_reviews.dataSource = self;
    
    self.tbl_reviews.tableFooterView = [UIView new];
    self.tbl_reviews.tableHeaderView = [UIView new];
    
    [self getRates];
}

-(void)getRates{
    
    my_rate = 0.0f;
    my_comment = @"";
    
    [arr_rates removeAllObjects];
    
    NSDictionary * dict = @{@"pv_id" : [self.dict objectForKey:@"pv_id"]};
    [Customer getRatesWithParameters:dict withSuccessBlock:^(NSArray *response) {
        [arr_rates addObjectsFromArray:response];
        
        for (NSDictionary * item in arr_rates) {
            if ([[item objectForKey:@"cs_id"] isEqualToString:[GVUserDefaults standardUserDefaults].csId]) {
                my_comment = [item objectForKey:@"comment"];
                my_rate = [[item objectForKey:@"rate"] floatValue];
                break;
            }
        }
        
        [self.tbl_reviews reloadData];
    } failure:^(NSError *error) {
        [UIHelper showPromptAlertforTitle:@"Error" withMessage:[error localizedDescription] forDelegate:nil];
    } view:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

-(void)singleTapped{
    JSQMessagesViewController  *messageVC = [[JSQMessagesViewController alloc] initWithNibName:@"JSQMessagesViewController" bundle:nil];
    
    [messageVC setDict:self.dict];
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    RateViewController * controller = (RateViewController*)segue.destinationViewController;
    controller.dict = self.dict;
    controller.current_comment = my_comment;
    controller.current_rating = my_rate;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickHire:(id)sender {
    if (self.isHired) {
        return;
    }
    
    if ([[self.dict objectForKey:@"status"] isEqualToString:@"won"]) {
        return;
    }
    
    [UIAlertView showAlertMessage:@"Are you sure to hire?" complete:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSDictionary * param = @{@"cs_id" : [GVUserDefaults standardUserDefaults].csId,
                                     @"pv_id" : [self.dict objectForKey:@"pv_id"],
                                     @"rq_id" : self.rq_id};
            [Customer hireProviderWithParameters:param withSuccessBlock:^(NSDictionary *response) {
                [UIAlertView showMessage:@"Congratulation! You hired a provider successfully!" complete:^(NSInteger buttonIndex) {
                    AppDelegate * app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    app.updateRequets = YES;
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } failure:^(NSError *error) {
                [UIHelper showPromptAlertforTitle:@"Error" withMessage:[error localizedDescription] forDelegate:nil];
            } view:self.view];
        }
    }];
}

- (IBAction)onSegmentValueChanged:(id)sender {
    if (self.segment_control.selectedSegmentIndex == 0) {
        // About
        self.profile_view.hidden = NO;
        self.tbl_reviews.hidden = YES;
    } else {
        self.profile_view.hidden = YES;
        self.tbl_reviews.hidden = NO;
    }
}

- (IBAction)onClickRate:(id)sender {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (arr_rates == nil) {
        return 0;
    }
    return [arr_rates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dict = [arr_rates objectAtIndex:indexPath.row];
    ReviewTableViewCell * cell = (ReviewTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"reviewIdentifier" forIndexPath:indexPath];
    cell.dict = dict;
    [cell configureCell];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - DCPopup Segue

- (void)dismissedPopupWithValue:(NSInteger)nDismiss {
    NSLog(@"Dismiss: %ld", (long)nDismiss);
    if (nDismiss == 1) {//OK
        [self getRates];
    }
}

@end
