//
//  SecondPageViewController.m
//  GenieCustomer
//
//  Created by Goldman on 3/29/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "SecondPageViewController.h"
#import "MainNavigationController.h"
#import "QuestionViewController.h"
#import "UIHelper.h"

@interface SecondPageViewController ()
@property (nonatomic, strong) NSArray * categoryArray;
@end

@implementation SecondPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MainNavigationController * navController = (MainNavigationController*)self.navigationController;
    
    self.categoryArray = [navController.pCategories objectForKey:self.business];
    
    [self.lbl_business setText:self.business];
    
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
    // Return the number of rows in the section.
    return [self.categoryArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subCategoryIdentifier" forIndexPath:indexPath];

    id item = [self.categoryArray objectAtIndex:indexPath.row];
    // Configure the cell...
    
    cell.textLabel.text = [item objectForKey:@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"questionVC"];
    id item = [self.categoryArray objectAtIndex:indexPath.row];
    controller.category = [NSString stringWithFormat:@"%ld", [[item objectForKey:@"id"] longValue]];
    
    MainNavigationController * navController = (MainNavigationController*)self.navigationController;
    if ([navController.pQuestions objectForKey:controller.category] == nil) {
        [UIHelper showPromptAlertforTitle:@"Oops" withMessage:@"Sorry, this category service will come soon..." forDelegate:nil];
        return;
    }
    
    controller.business = self.business;
    [self.navigationController pushViewController:controller animated:YES];
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

@end
