//
//  FirstPageViewController.m
//  GenieCustomer
//
//  Created by Goldman on 3/27/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "FirstPageViewController.h"
#import <UIViewController+ECSlidingViewController.h>
#import "MainNavigationController.h"
#import "SecondPageViewController.h"
#import "QuestionViewController.h"

@interface FirstPageViewController ()
@property (nonatomic, strong) NSArray * categoryArray;
@property (nonatomic, strong) NSString * selectedCategory;
@property (nonatomic) long selectedIndex;
@end

@implementation FirstPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping;
    
    MainNavigationController * navController = (MainNavigationController*)self.navigationController;
    
    self.categoryArray = [navController.pCategories allKeys];
    self.categoryArray = [self.categoryArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.selectedIndex = -1;
    self.selectedCategory = @"";
    
    self.tableView.delegate = self;
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categoryArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.categoryArray objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * category = [self.categoryArray objectAtIndex:indexPath.row];
    if ([category isEqualToString:@"Academic"]) {
        QuestionViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"questionVC"];
        controller.category = @"1";
        controller.business = @"Academic";
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        SecondPageViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"subcategoryVC"];
        
        controller.business = [self.categoryArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    /*self.selectedIndex = indexPath.row;
    self.selectedCategory = [self.categoryArray objectAtIndex:indexPath.row];
    [tableView reloadData];*/
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

- (IBAction)onClickMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
- (IBAction)onClickRequestMade:(id)sender {
    [self.slidingViewController.underLeftViewController performSegueWithIdentifier:@"SSID_TO_REQUEST_MADE" sender:nil];
}
@end
