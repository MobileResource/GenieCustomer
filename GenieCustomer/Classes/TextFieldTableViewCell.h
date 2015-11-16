//
//  TextFieldTableViewCell.h
//  GenieCustomer
//
//  Created by Goldman on 3/31/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *text_field;
@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) NSString * holderText;
@property (nonatomic, strong) id delegate;
@property (nonatomic) BOOL isDifferent;
@property (nonatomic) BOOL isMultiSelect;
-(void)configureCell;

@end
