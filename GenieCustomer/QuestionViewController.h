//
//  QuestionViewController.h
//  GenieCustomer
//
//  Created by Goldman on 3/29/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetPicker.h"

@interface QuestionViewController : UIViewController
@property (nonatomic, strong) NSString * category;
@property (nonatomic, strong) NSString * business;
@property (nonatomic, strong) NSDictionary * pQuestions;

@property (strong, nonatomic) IBOutlet UILabel *lbl_question;
@property (strong, nonatomic) IBOutlet UILabel *lbl_business;
- (IBAction)onClickNext:(id)sender;
- (IBAction)onClickBack:(id)sender;

@property (nonatomic, strong) AbstractActionSheetPicker * actionSheetPicker;

@property (nonatomic, strong) NSDate * selectedDate;
@property (nonatomic, strong) NSDate * selectedTime;
@property (nonatomic, assign) NSInteger selectedNumber;
@property (nonatomic, assign) NSInteger selectedDuration;
@property (strong, nonatomic) IBOutlet UIView *imagesFooterView;
@property (strong, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageViewer;

@property (strong, nonatomic) IBOutlet UITableView *tbl_questions;

-(IBAction)selectADate:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_next;

@end
