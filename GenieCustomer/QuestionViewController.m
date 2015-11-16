//
//  QuestionViewController.m
//  GenieCustomer
//
//  Created by Goldman on 3/29/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "QuestionViewController.h"
#import "MainNavigationController.h"
#import "TextFieldTableViewCell.h"
#import "UIHelper.h"
#import "NSDate+TCUtils.h"
#import "UtilitiesHelper.h"
#import "GVUserDefaults+Properties.h"
#import "Customer.h"
#import "UIAlertView+Starlet.h"
#import <UIViewController+ECSlidingViewController.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ScreenHelper.h"

typedef enum {
    Cover_FromLeft = 0,
    Cover_FromRight = 1,
    Cover_FromTop = 2,
    Cover_FromBottom
} CoverType;


@interface QuestionViewController ()<UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

-(void)dateWasSelected:(NSDate*)selectedDate element:(id)element;

@property (nonatomic, strong) NSArray * questions;
@property (nonatomic) unsigned long current_question;
@property (nonatomic) NSUInteger max_question_count;
@property (nonatomic, strong) NSString * question_title;
@property (nonatomic, strong) NSMutableArray * question_answers;
@property (nonatomic, strong) NSArray * question_orig_answers;

@property (nonatomic, strong) NSMutableArray * numbers;

@property (nonatomic, strong) NSMutableDictionary * answers;
@property (nonatomic) NSUInteger current_selected;
@property (nonatomic, strong) NSMutableIndexSet * selected_indexes;
@property (nonatomic, strong) NSMutableArray * current_answer;
@property (nonatomic) BOOL isDifferentQuestion;
@property (nonatomic) BOOL isOptional;
@property (nonatomic) BOOL isMultiSelect;
@property (nonatomic) BOOL isMoveButtton;

@property (nonatomic, strong) NSMutableArray * arr_images;
@property (nonatomic, strong) NSMutableArray * arr_paths;
@property (nonatomic) unsigned long current_image;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation QuestionViewController
@synthesize pQuestions = _pQuestions;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    self.imagesScrollView.delegate = self;
    self.isOptional = NO;
    self.isMultiSelect = YES;
    
    self.answers = [[NSMutableDictionary alloc] init];
    self.current_selected = -1;
    self.current_answer = [NSMutableArray array];
    
    self.selected_indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 50)];
    
    MainNavigationController * navController = (MainNavigationController*)self.navigationController;
    
    self.current_question = 0;
    
    self.questions = [navController.pQuestions objectForKey:self.category];
    self.max_question_count = [self.questions count];
    
    self.numbers = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 100; i++) {
        [self.numbers addObject:[NSString stringWithFormat:@"%d",i]];
    }
   
    self.tbl_questions.delegate = self;
    self.tbl_questions.dataSource = self;
    
    self.arr_images = [NSMutableArray array];
    self.arr_paths = [NSMutableArray array];
    [self.pageViewer setNumberOfPages:0];
    
    self.tbl_questions.tableFooterView = [UIView new];
    
    [self.lbl_business setText:self.business];
    
    [self setQuestionAndAnswers];
}

-(void)keyboardDidShow:(NSNotification*)notification{
    if (!self.isMoveButtton) {
        return;
    }
    
    NSDictionary* info = [notification userInfo];
    CGRect kbFrameEndFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // _showKeyboard = YES;
    [UIView animateWithDuration:animDuration animations:^{
        self.bottomConstraint.constant = kbFrameEndFrame.size.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

-(void)keyboardDidHide:(NSNotification*)notification{
    if (!self.isMoveButtton) {
        return;
    }
    
    NSDictionary* info = [notification userInfo];
    NSTimeInterval animDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:animDuration animations:^{
        self.bottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

-(void)setQuestionAndAnswers{
    self.isDifferentQuestion = YES;
    
    NSDictionary * qs = [self.questions objectAtIndex:self.current_question];
    self.question_title = [qs objectForKey:@"Question"];
    
    self.question_orig_answers = [qs objectForKey:@"Answers"];
    
    self.isMultiSelect = [[qs objectForKey:@"MultiSelect"] boolValue];
    self.isOptional = [[qs objectForKey:@"Optional"] boolValue];
    self.isMoveButtton = NO;
    
    if ([self.question_orig_answers count] == 1 && [[self.question_orig_answers objectAtIndex:0] isEqualToString:@"TextField"]) {
        self.isMoveButtton = YES;
        self.isMultiSelect = YES;
    }
    
    self.tbl_questions.tableFooterView = [UIView new];
    
    for (NSString* question in self.question_orig_answers) {
        if ([question isEqualToString:@"MediaField"]) {
            self.tbl_questions.tableFooterView = self.imagesFooterView;
            break;
        }
    }
    
    [self.arr_images removeAllObjects];
    [self.arr_paths removeAllObjects];
    [self.imagesScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.question_answers = [[NSMutableArray alloc] initWithArray:self.question_orig_answers];
    
    [self.lbl_question setText:self.question_title];
    self.current_selected = -1;
    [self.selected_indexes removeAllIndexes];
    [self.current_answer removeAllObjects];
    
    self.selectedDate = [NSDate date];
    self.selectedTime = [NSDate date];
    self.selectedNumber = 0;
    self.selectedDuration = 0;
    
    [self.tbl_questions reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = scrollView.frame;
    NSInteger nIndex = floor(scrollView.contentOffset.x / frame.size.width);
    self.pageViewer.currentPage = nIndex;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.question_answers == nil) {
        return 0;
    }
    return [self.question_answers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * question = [self.question_answers objectAtIndex:indexPath.row];
    
    if ([question isEqualToString:@"TextField"] || [question isEqualToString:@"Others"]) {
        TextFieldTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"textIdentifier" forIndexPath:indexPath];
        [cell setIndex:indexPath.row];
        [cell setTag:indexPath.row + 1000];
        [cell setDelegate:self];
        [cell setIsMultiSelect:self.isMultiSelect];
        
        if ([question isEqualToString:@"TextField"]) {
            [cell setHolderText:@"Please enter here"];
        } else {
            [cell setHolderText:@"Others"];
        }
        
        [cell setIsDifferent:self.isDifferentQuestion];

        [cell configureCell];
        
        if (self.isDifferentQuestion) {
            self.isDifferentQuestion = NO;
        }
        
        if (self.isMultiSelect) {
            NSLog(@"test: %d", [self.selected_indexes containsIndex:indexPath.row]);
            if ([self.selected_indexes containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            //cell.accessoryType = UITableViewCellAccessoryNone;
            NSLog(@"IndexRow: %lu", (unsigned long)cell.index);
            NSLog(@"currentselected: %lu", (unsigned long)self.current_selected);
            NSLog(@"test: %d", [self.selected_indexes containsIndex:indexPath.row]);
            if (self.current_selected == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }

        return cell;
    } else if ([question isEqualToString:@"MediaField"]){
        UITableViewCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"generalIdentifier" forIndexPath:indexPath];
        cell.textLabel.text = @"Attach up to 3 photos to show the problem/what you want to achieve";
        if (self.isMultiSelect) {
            if ([self.selected_indexes containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            /*
            if (indexPath.row == self.current_selected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }*/
        }
        
        return cell;
    } else {
        UITableViewCell * cell;
        if (self.isMultiSelect) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"generalIdentifier" forIndexPath:indexPath];
        } else {
            //cell = [tableView dequeueReusableCellWithIdentifier:@"nextIdentifier" forIndexPath:indexPath];
            cell = [tableView dequeueReusableCellWithIdentifier:@"generalIdentifier" forIndexPath:indexPath];
        }
        
        if ([question isEqualToString:@"DurationPicker"]) {
            cell.textLabel.text = @"Please click to select duration";
        } else if ([question isEqualToString:@"DatePicker"]){
            cell.textLabel.text = @"Choose a Date";
        } else if ([question isEqualToString:@"NumberPicker"]){
            cell.textLabel.text = @"Please click to select number";
        } else if ([question isEqualToString:@"TimePicker"]){
            cell.textLabel.text = @"Choose a Time";
        } else {
            cell.textLabel.text = question;
        }
        
        if (self.isMultiSelect) {
            if ([self.selected_indexes containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            /*if (indexPath.row == self.current_selected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }*/
        }
        
        // Configure the cell...
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * orig_answer = [self.question_orig_answers objectAtIndex:indexPath.row];
    if ([orig_answer isEqualToString:@"DatePicker"]) {
        [self selectADate:[tableView cellForRowAtIndexPath:indexPath]];
    } else if ([orig_answer isEqualToString:@"TimePicker"]){
        [self selectATime:[tableView cellForRowAtIndexPath:indexPath]];
    } else if ([orig_answer isEqualToString:@"DurationPicker"]){
        [self selectADuration:[tableView cellForRowAtIndexPath:indexPath]];
    } else if ([orig_answer isEqualToString:@"NumberPicker"]){
        [self selectANumber:[tableView cellForRowAtIndexPath:indexPath]];
    } else if ([orig_answer isEqualToString:@"MediaField"]){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Select image" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Camera", @"Album", nil];
        [alert show];
    } else {
        if (self.isMultiSelect) {
            if ([self.selected_indexes containsIndex:indexPath.row]) {
                [self.selected_indexes removeIndex:indexPath.row];
                
                NSString * answer = [self.question_answers objectAtIndex:indexPath.row];
                [self.current_answer removeObject:answer];
            } else{
                [self.selected_indexes addIndex:indexPath.row];
                [self.current_answer addObject:[self.question_answers objectAtIndex:indexPath.row]];
            }
        } else {
            self.current_selected = indexPath.row;
            [self.current_answer removeAllObjects];
            [self.current_answer addObject:[self.question_answers objectAtIndex:indexPath.row]];
            //[self onClickNext:nil];
            return;
        }
        
        NSLog(@"Current Answer : %@", self.current_answer);
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [tableView reloadData];
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
        UIImage * img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        img = [UtilitiesHelper imageWithImage:img scaledToSize:CGSizeMake([ScreenHelper getScreenWidth] - 30, 230)];

        [self.arr_images addObject:img];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        CGRect rect = self.imagesScrollView.frame;
        rect.origin.x = ([self.arr_images count] - 1) * (rect.size.width);
        rect.origin.y = 0;
        [imgView setFrame:rect];
        [self.imagesScrollView addSubview:imgView];
        [self.imagesScrollView setContentSize:CGSizeMake(([ScreenHelper getScreenWidth] - 30) *[self.arr_images count], 230)];
        [self.imagesScrollView scrollRectToVisible:rect animated:YES];
        [self.pageViewer setNumberOfPages:[self.arr_images count]];
        
        [self.selected_indexes addIndex:1];
        [self.current_answer addObject:@"Images"];
        
        //self.current_answer = @"Images";
        //NSLog(@"Current Answer : %@", self.current_answer);
        [self.tbl_questions reloadData];
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
-(IBAction)selectADate:(id)sender{
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate target:self action:@selector(dateWasSelected:element:) origin:sender cancelAction:@selector(actionPickerCancelled:)];
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    [self.actionSheetPicker showActionSheetPicker];
}
*/

-(IBAction)selectADate:(id)sender{
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDateAndTime selectedDate:self.selectedDate target:self action:@selector(dateWasSelected:element:) origin:sender cancelAction:@selector(actionPickerCancelled:)];
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    [self.actionSheetPicker showActionSheetPicker];
}

-(IBAction)selectATime:(id)sender{
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeTime selectedDate:self.selectedDate target:self action:@selector(timeWasSelected:element:) origin:sender cancelAction:@selector(actionPickerCancelled:)];
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    [self.actionSheetPicker showActionSheetPicker];
}

-(IBAction)selectADuration:(id)sender{
    [ActionSheetStringPicker showPickerWithTitle:@"" rows:self.numbers initialSelection:self.selectedDuration target:self successAction:@selector(durationWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

-(IBAction)selectANumber:(id)sender{
    
    [ActionSheetStringPicker showPickerWithTitle:@"" rows:self.numbers initialSelection:self.selectedNumber target:self successAction:@selector(numberWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

-(void)numberWasSelected:(NSNumber*)selectedIndex element:(id)element{
    self.selectedNumber = [selectedIndex integerValue];
    
    UITableViewCell * cell = (UITableViewCell*)element;
    NSIndexPath * indexPath = [self.tbl_questions indexPathForCell:cell];
    
    [self.current_answer addObject:[NSString stringWithFormat:@"%ld", self.selectedNumber]];
    if (self.isMultiSelect) {
        self.current_selected = indexPath.row;
    } else {
        [self.selected_indexes addIndex:indexPath.row];
    }

    [self.question_answers replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%ld", self.selectedNumber]];
    [self.tbl_questions reloadData];
}

-(void)durationWasSelected:(NSNumber*)selectedIndex element:(id)element{
    self.selectedDuration = [selectedIndex integerValue];
    
    UITableViewCell * cell = (UITableViewCell*)element;
    NSIndexPath * indexPath = [self.tbl_questions indexPathForCell:cell];
    
    [self.current_answer addObject:[NSString stringWithFormat:@"%ld", self.selectedDuration]];
    if (self.isMultiSelect) {
        self.current_selected = indexPath.row;
    } else {
        [self.selected_indexes addIndex:indexPath.row];
    }
    
    [self.question_answers replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%ld", self.selectedDuration]];
    [self.tbl_questions reloadData];
}

/*
-(void)dateWasSelected:(NSDate*)selectedDate element:(id)element{
    self.selectedDate = selectedDate;
    
    UITableViewCell * cell = (UITableViewCell*)element;
    NSIndexPath * indexPath = [self.tbl_questions indexPathForCell:cell];
    
    [self.current_answer addObject:[UtilitiesHelper convert2DateString:self.selectedDate]];
    if (self.isMultiSelect) {
        self.current_selected = indexPath.row;
    } else {
        [self.selected_indexes addIndex:indexPath.row];
    }
    
    [self.question_answers replaceObjectAtIndex:indexPath.row withObject:[UtilitiesHelper convert2DateString:self.selectedDate]];
    [self.tbl_questions reloadData];
}
*/
-(void)dateWasSelected:(NSDate*)selectedDate element:(id)element{
    //Time
    self.selectedTime = selectedDate;
    UITableViewCell * cell2 = (UITableViewCell*)element;
    NSIndexPath * indexPath2 = [self.tbl_questions indexPathForCell:cell2];
    
    [self.current_answer addObject:[UtilitiesHelper convert2TimeString:self.selectedTime]];
    if (self.isMultiSelect) {
        self.current_selected = indexPath2.row;
    } else {
        [self.selected_indexes addIndex:indexPath2.row];
    }
    [self.question_answers replaceObjectAtIndex:indexPath2.row withObject:[UtilitiesHelper convert2TimeString:self.selectedTime]];
    [self.tbl_questions reloadData];
    
    //Date
    self.selectedDate = selectedDate;
    UITableViewCell * cell = (UITableViewCell*)element;
    NSIndexPath * indexPath = [self.tbl_questions indexPathForCell:cell];
    
    [self.current_answer addObject:[UtilitiesHelper convert2DateString:self.selectedDate]];
    if (self.isMultiSelect) {
        self.current_selected = indexPath.row;
    } else {
        [self.selected_indexes addIndex:indexPath.row];
    }
    
    [self.question_answers replaceObjectAtIndex:indexPath.row withObject:[UtilitiesHelper convert2DateString:self.selectedDate]];
    [self.tbl_questions reloadData];
}

-(void)timeWasSelected:(NSDate*)selectedDate element:(id)element{
    self.selectedTime = selectedDate;
    UITableViewCell * cell = (UITableViewCell*)element;
    NSIndexPath * indexPath = [self.tbl_questions indexPathForCell:cell];
    
    [self.current_answer addObject:[UtilitiesHelper convert2TimeString:self.selectedTime]];
    if (self.isMultiSelect) {
        self.current_selected = indexPath.row;
    } else {
        [self.selected_indexes addIndex:indexPath.row];
    }
    [self.question_answers replaceObjectAtIndex:indexPath.row withObject:[UtilitiesHelper convert2TimeString:self.selectedTime]];
    [self.tbl_questions reloadData];
}

-(void)actionPickerCancelled:(id)sender{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickNext:(id)sender {
    
    BOOL isImage = NO;
    
    if ([self.current_answer containsObject:@"Images"]) {
        isImage = YES;
    } else if ([self.current_answer count] == 0){
        if (!self.isOptional) {
            [UIHelper showPromptAlertforTitle:@"Warning" withMessage:@"Please select or enter answer" forDelegate:nil];
            return;
        }
    }
    
    if (isImage == YES && [self.arr_images count] == 0) {
        [UIHelper showPromptAlertforTitle:@"Warning" withMessage:@"Please select at least one image" forDelegate:nil];
        return;
    }
    
    if (!isImage) {
        [self.answers setValue:[self.current_answer componentsJoinedByString:@","] forKey:self.question_title];
        NSLog(@"Current Answers : %@", self.answers);
    }
    
    if (self.isMoveButtton) {
        self.bottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }
    
    [self.arr_paths removeAllObjects];
    
    if (self.current_question == self.max_question_count - 1) {
        //Submit
        
        [UIAlertView showAlertMessage:@"Do you want to submit?" complete:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                self.current_image = 0;
                
                if (isImage) {
                    UIImage * img = [self.arr_images objectAtIndex:self.current_image];
                    
                    NSData * photoData = UIImageJPEGRepresentation(img, 1.0f);
                    
                    NSDictionary * param = @{};
                    
                    [Customer uploadImageWithImageData:param imageData:photoData imageDataParam:@"image" withSuccessBlock:^(NSDictionary *response) {
                        NSString * path = [response objectForKey:@"path"];
                        [self.arr_paths addObject:path];
                        
                        self.current_image++;
                        
                        if (self.current_image >= [self.arr_images count]) {
                            [self uploadRequest];
                        } else {
                            [self selfUploadImage:[self.arr_images objectAtIndex:self.current_image]];
                        }
                        
                    } failure:^(NSError *error) {
                        [UIHelper showPromptAlertforTitle:@"Error" withMessage:[error localizedDescription] forDelegate:nil];
                    } view:self.view];

                } else {
                    [self uploadRequest];
                }
            }
        }];
        return;
    }
    
    self.isDifferentQuestion = YES;
    
    NSInteger oldQuestion = self.current_question;
    self.current_question++;
    
    if (self.current_question >= self.max_question_count) {
        self.current_question = self.max_question_count - 1;
    }
    
    if (self.current_question == self.max_question_count - 1) {
        [self.btn_next setTitle:@"Submit" forState:UIControlStateNormal];
    } else {
        [self.btn_next setTitle:@"Next" forState:UIControlStateNormal];
    }
    
    [self setQuestionAndAnswers];
    
    [self coverAnimationWithDuration:0.35 type:(oldQuestion < self.current_question ? Cover_FromRight : Cover_FromLeft)];
}

-(void)uploadRequest{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    for (NSString * key in self.answers) {
        NSString * value = [self.answers objectForKey:key];
        NSArray * answerArray = @[value];
        [dict setValue:answerArray forKey:key];
    }
    
    NSError * error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * json_dict = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    data = [NSJSONSerialization dataWithJSONObject:self.arr_paths options:kNilOptions error:&error];
    NSString * img_array = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON Answers : %@", json_dict);
    
    NSDictionary * param = @{@"id" : [GVUserDefaults standardUserDefaults].csId,
                             @"category_id" : self.category,
                             @"content" : json_dict,
                             @"img_list" : img_array == nil ? @"" : img_array};
    
    [Customer sendRequestWithParameters:param withSuccessBlock:^(NSDictionary *response) {
        [UIAlertView showMessage:@"Your request has been submitted successfully! You will receive 3-5 quotes from professionals within 24 hours!" complete:^(NSInteger buttonIndex) {
            [self.slidingViewController.underLeftViewController performSegueWithIdentifier:@"SSID_TO_REQUEST_MADE" sender:nil];
        }];
    } failure:^(NSError *error) {
        [UIHelper showPromptAlertforTitle:@"Error" withMessage:[error localizedDescription] forDelegate:nil];
    } view:self.view];
    
    return;
}

-(void)selfUploadImage:(UIImage*)img{
    NSData * photoData = UIImageJPEGRepresentation(img, 1.0f);
    
    NSDictionary * param = @{};
    
    [Customer uploadImageWithImageData:param imageData:photoData imageDataParam:@"image" withSuccessBlock:^(NSDictionary *response) {
        NSString * path = [response objectForKey:@"path"];
        [self.arr_paths addObject:path];
        
        self.current_image++;
        
        if (self.current_image >= [self.arr_images count]) {
            [self uploadRequest];
        } else {
            [self selfUploadImage:[self.arr_images objectAtIndex:self.current_image]];
        }
    } failure:^(NSError *error) {
        
    } view:self.view];
}

- (IBAction)onClickBack:(id)sender {
    if (self.current_question == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.isDifferentQuestion = YES;
    
    NSInteger oldQuestion = self.current_question;
    self.current_question--;
    
    if (self.current_question == self.max_question_count - 1) {
        [self.btn_next setTitle:@"Submit" forState:UIControlStateNormal];
    } else {
        [self.btn_next setTitle:@"Next" forState:UIControlStateNormal];
    }
    
    [self setQuestionAndAnswers];
    
    [self coverAnimationWithDuration:0.35 type:(oldQuestion < self.current_question ? Cover_FromRight : Cover_FromLeft)];
}

- (void)coverAnimationWithDuration:(CGFloat)duration type:(CoverType)fromType {
    [self.tbl_questions.layer removeAnimationForKey:@"coverAnimation"];
    
    CATransition* transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = [self getCATransitionTypeFromCoverType:fromType];
    [self.tbl_questions.layer addAnimation:transition forKey:@"coverAnimation"];
}

- (NSString*)getCATransitionTypeFromCoverType:(CoverType)nType {
    NSString* tttype = kCATransitionFromLeft;
    switch (nType) {
        case Cover_FromRight:
            tttype = kCATransitionFromRight;
            break;
        case Cover_FromTop:
            tttype = kCATransitionFromTop;
            break;
        case Cover_FromBottom:
            tttype = kCATransitionFromBottom;
            break;
        case Cover_FromLeft:
        default:
            break;
    }
    return tttype;
}

-(void)textFieldEdit:(id)sender{
    /*if (!self.isMoveButtton) {
        return;
    }*/
    
    UITextField *textField = (UITextField*)sender;
    NSUInteger index = textField.tag - 1000;
    if (self.isMultiSelect) {
        [self.current_answer addObject:textField.text];
        [self.selected_indexes addIndex:index];
    } else {
        self.current_selected = index;
        [self.current_answer removeAllObjects];
        [self.current_answer addObject:textField.text];
    }
}

- (void)textFieldChanged:(id)sender{
    //self.isDifferentQuestion = NO;
    
    if (self.isDifferentQuestion) {
        return;
    }
    
    UITextField *textField = (UITextField*)sender;
    NSUInteger index = textField.tag - 1000;
    if (self.isMultiSelect) {
        [self.current_answer addObject:textField.text];
        [self.selected_indexes addIndex:index];
    } else {
        self.current_selected = index;
        [self.current_answer removeAllObjects];
        [self.current_answer addObject:textField.text];
        if (!self.isMoveButtton) {
            //[self onClickNext:nil];
        }
        return;
    }

    //NSLog(@"Current Answer : %@", self.current_answer);
    [self.tbl_questions reloadData];
}

@end
