//
//  TextFieldTableViewCell.m
//  GenieCustomer
//
//  Created by Goldman on 3/31/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@implementation TextFieldTableViewCell{
    BOOL isSentChange;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell{
    isSentChange = NO;
    
    UIImageView * check_mark = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13.5f, 13.5f)];
    UIImage * img = [UIImage imageNamed:@"check_mark.png"];
    check_mark.image = img;
    check_mark.contentMode = UIViewContentModeScaleAspectFit;
    self.text_field.rightView = check_mark;
    self.text_field.rightViewMode = UITextFieldViewModeNever;
    
    self.text_field.tag = self.tag;
    self.text_field.delegate = self;
    self.text_field.placeholder = self.holderText;
    
    if (self.isDifferent) {
        self.text_field.text = @"";
    }
    
    [self.text_field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    [self.text_field addTarget:self action:@selector(textFieldEdited:) forControlEvents:UIControlEventEditingChanged];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (isSentChange) {
        return YES;
    }
    
    if ([_delegate respondsToSelector:@selector(textFieldChanged:)]){
        [textField setTag:self.tag];
        [_delegate performSelector:@selector(textFieldChanged:) withObject:textField];
        isSentChange = YES;
    }
    return YES;
}

-(void)textFieldEdited:(id)sender{
    if ([_delegate respondsToSelector:@selector(textFieldEdit:)]){
        [sender setTag:self.tag];
        [_delegate performSelector:@selector(textFieldEdit:) withObject:sender];
    }
}

-(void)textFieldDidChange:(id)sender{
    
    if (isSentChange) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(textFieldChanged:)]){
        [sender setTag:self.tag];
        [_delegate performSelector:@selector(textFieldChanged:) withObject:sender];
        isSentChange = YES;
    }
    
    NSString * content = self.text_field.text;
    if (self.isMultiSelect && !self.isDifferent) {
        if ([content isEqualToString:@""]) {
            self.text_field.rightViewMode = UITextFieldViewModeNever;
        } else {
            self.text_field.rightViewMode = UITextFieldViewModeAlways;
        }
    }
}

@end
