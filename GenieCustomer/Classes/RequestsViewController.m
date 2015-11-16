//
//  RequestsViewController.m
//  GenieCustomer
//
//  Created by Goldman on 4/1/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "RequestsViewController.h"
#import "Customer.h"
#import "UIHelper.h"
#import "GVUserDefaults+Properties.h"
#import <UIViewController+ECSlidingViewController.h>
#import "RequestTableViewCell.h"
#import "RequestHeaderView.h"
#import "ProviderDetailViewController.h"

#import "AppDelegate.h"

@interface RequestsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray * rq_array;
@property (nonatomic, strong) NSMutableDictionary * rqs;
@property (nonatomic, strong) NSMutableArray * rq_ids;
@property (nonatomic, strong) NSMutableArray * rq_dates;
@property (nonatomic, strong) NSMutableArray * rq_names;
@property (nonatomic, strong) NSIndexPath * curIndexPath;
@property (nonatomic) unsigned long current_request;
@property (nonatomic) BOOL isHired;
@end

typedef enum {
    Cover_FromLeft = 0,
    Cover_FromRight = 1,
    Cover_FromTop = 2,
    Cover_FromBottom
} CoverType;

@implementation RequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.updateRequets = NO;
    
    self.current_request = 0;
    
    self.table_requests.tableFooterView = [UIView new];
    self.table_requests.tableHeaderView = [UIView new];
    
    [self.table_requests registerClass:[RequestHeaderView class] forHeaderFooterViewReuseIdentifier:@"requestHeader"];
    
    self.rq_array = [NSMutableArray array];
    self.rqs = [[NSMutableDictionary alloc] init];
    self.rq_ids = [NSMutableArray array];
    self.rq_dates = [NSMutableArray array];
    self.rq_names = [NSMutableArray array];
    
    self.table_requests.delegate = self;
    self.table_requests.dataSource = self;
    
    self.isHired = NO;
    
    [self getRequest];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate * app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (app.updateRequets) {
        [self getRequest];
    }
    app.updateRequets = NO;
}

-(void)getRequest{
    
    [self.rq_array removeAllObjects];
    [self.rq_ids removeAllObjects];
    [self.rqs removeAllObjects];
    [self.rq_dates removeAllObjects];
    [self.rq_names removeAllObjects];
    
    NSDictionary * param = @{@"id" : [GVUserDefaults standardUserDefaults].csId};
    
    [Customer getRequestsParameters:param withSuccessBlock:^(NSArray *response) {
        for (NSDictionary * dict in response) {
            NSString * rq_id = [dict objectForKey:@"rq_id"];
            BOOL exist = NO;
            for (int i = 0; i < [self.rq_ids count]; i++) {
                if ([[self.rq_ids objectAtIndex:i] isEqualToString:rq_id]) {
                    exist = YES;
                    break;
                }
            }
            
            if (!exist) {
                [self.rq_ids addObject:rq_id];
                [self.rq_dates addObject:[dict objectForKey:@"created_at"]];
                [self.rq_names addObject:[dict objectForKey:@"ct_name"]];
            }
            
            if (![[dict objectForKey:@"pv_name"] isEqualToString:@""]) {
                if ([self.rqs objectForKey:rq_id] == nil) {
                    NSMutableArray * array = [[NSMutableArray alloc] init];
                    [array addObject:dict];
                    [self.rqs setValue:array forKey:rq_id];
                } else {
                    NSMutableArray * array = [self.rqs objectForKey:rq_id];
                    [array addObject:dict];
                    [self.rqs setValue:array forKey:rq_id];
                }
            }
        }
        [self.table_requests reloadData];
        //[self.rq_array addObjectsFromArray:response];
    } failure:^(NSError *error) {
        [UIHelper showPromptAlertforTitle:@"Error" withMessage:[error localizedDescription] forDelegate:nil];
    } view:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
    //return [self.rq_ids count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([self.rq_ids count] <= self.current_request) {
        return 0;
    }
    
    NSString * rq_id = [self.rq_ids objectAtIndex:self.current_request];
    //NSString * rq_id = [self.rq_ids objectAtIndex:section];
    NSMutableArray * array = [self.rqs objectForKey:rq_id];
/*    if ([array count] == 0) {
        return 1;
    }*/
    return [array count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString * rq_id = [self.rq_ids objectAtIndex:indexPath.section];
//    NSMutableArray * array = [self.rqs objectForKey:rq_id];
//    if ([array count] == 0) {
//        return 44;
//    }
    return 80;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.rq_dates count] <= self.current_request) {
        return nil;
    }
    RequestHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"requestHeader"];
//    [headerView.dateLabel setText:[NSString stringWithFormat:@"Created on %@", [self.rq_dates objectAtIndex:section]]];
//    [headerView.titleLabel setText:[self.rq_names objectAtIndex:section]];
    [headerView.dateLabel setText:[NSString stringWithFormat:@"Created on %@", [self.rq_dates objectAtIndex:self.current_request]]];
    [headerView.titleLabel setText:[self.rq_names objectAtIndex:self.current_request]];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 96;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NSString * rq_id = [self.rq_ids objectAtIndex:indexPath.section];
    NSString * rq_id = [self.rq_ids objectAtIndex:self.current_request];
    NSMutableArray * array = [self.rqs objectForKey:rq_id];
    
    NSDictionary * dict = [array objectAtIndex:indexPath.row];
    
    ProviderDetailViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailVC"];
    controller.isHired = self.isHired;
    controller.rq_id = rq_id;
    [controller setDict:dict];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSString * rq_id = [self.rq_ids objectAtIndex:indexPath.section];
    NSString * rq_id = [self.rq_ids objectAtIndex:self.current_request];
    NSMutableArray * array = [self.rqs objectForKey:rq_id];
    
/*    if ([array count] == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"noresponseIdentifier"];
        return cell;
    } else */{
        RequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"requestIdentifier" forIndexPath:indexPath];
        
        
        NSDictionary * dict = [array objectAtIndex:indexPath.row];
        
        if ([[dict objectForKey:@"status"] isEqualToString:@"won"]) {
            self.isHired = YES;
        }
        
        [cell setDict:dict];
        [cell configureCell];
        // Configure the cell...
        
        return cell;
    }
}

- (void)coverAnimationWithDuration:(CGFloat)duration type:(CoverType)fromType {
    [self.table_requests.layer removeAnimationForKey:@"coverAnimation"];
    
    CATransition* transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = [self getCATransitionTypeFromCoverType:fromType];
    [self.table_requests.layer addAnimation:transition forKey:@"coverAnimation"];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.curIndexPath = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
    
}


- (IBAction)onClickNext:(id)sender {
    NSInteger lastSectionIndex = [self.tableView numberOfSections] - 1;
    NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:self.curIndexPath.section + 1 inSection:0];
    if (newIndexPath == nil) {
        return;
    }
    if (newIndexPath.section > lastSectionIndex) {
        newIndexPath = [NSIndexPath indexPathForRow:lastSectionIndex inSection:0];
    }
    
    if (newIndexPath == nil) {
        return;
    }
    
    NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    if (visibleIndexPaths.count < 1)
        return;
    newIndexPath = visibleIndexPaths[0];
    NSInteger nSection = newIndexPath.section + 1;
    if (nSection > lastSectionIndex)
        return;
    
    CGRect sectionRect = [self.tableView rectForHeaderInSection:nSection];
    //sectionRect.size.height = self.tableView.frame.size.height;
    //[self.tableView scrollRectToVisible:sectionRect animated:YES];
    
    [self.tableView setContentOffset:sectionRect.origin animated:YES];
}
*/

- (IBAction)onClickMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction)onClickPrev:(id)sender {
    if (self.current_request == 0) {
        return;
    }
    
    NSInteger oldQuestion = self.current_request;
    self.current_request--;
    
    [self.table_requests reloadData];
    
    [self coverAnimationWithDuration:0.35 type:(oldQuestion < self.current_request ? Cover_FromRight : Cover_FromLeft)];
    
}

- (IBAction)onClickNext:(id)sender {
    
    NSInteger oldQuestion = self.current_request;
    self.current_request++;
    
    if (self.current_request >= [self.rq_ids count]) {
        self.current_request = [self.rq_ids count] - 1;
        return;
    }
    
    [self.table_requests reloadData];
    
    [self coverAnimationWithDuration:0.35 type:(oldQuestion < self.current_request ? Cover_FromRight : Cover_FromLeft)];
}
@end
