//
//  MainNavigationController.m
//  GenieCustomer
//
//  Created by Goldman on 3/27/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation MainNavigationController
@synthesize pCategories = _pCategories;
@synthesize pQuestions = _pQuestions;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Do any additional setup after loading the view.
    NSArray *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *bundlepath = [[NSBundle mainBundle] pathForResource: @"category" ofType: @"plist"];
    NSData *plistData = [NSData dataWithContentsOfFile:bundlepath];
    
    NSString *documentsPath = [documentDir objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"category.plist"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(!fileExists){
        [plistData writeToFile:filePath atomically:YES]; //Write the file
    }
    _pCategories = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    bundlepath = [[NSBundle mainBundle] pathForResource: @"questions" ofType: @"plist"];
    plistData = [NSData dataWithContentsOfFile:bundlepath];
    
    documentsPath = [documentDir objectAtIndex:0]; //Get the docs directory
    filePath = [documentsPath stringByAppendingPathComponent:@"questions.plist"];
    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(!fileExists){
        [plistData writeToFile:filePath atomically:YES]; //Write the file
    }
    
    _pQuestions = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
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

@end
