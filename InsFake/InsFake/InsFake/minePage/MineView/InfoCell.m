//
//  InfoCell.m
//  InsFake
//
//  Created by big-R on 2019/12/21.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import "InfoCell.h"

@implementation InfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        _attribute = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 50)];
        _value = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, [[UIScreen mainScreen] bounds].size.width-150, 50)];
        _value.textColor=[UIColor grayColor];
        _button = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-30, 0, 30, 50)];
        _button.text = @">";
        UITapGestureRecognizer *clik=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEvent)];
        [_button addGestureRecognizer:clik];
        _button.userInteractionEnabled=YES;
        [self.contentView addSubview:_attribute];
        [self.contentView addSubview:_value];
        [self.contentView addSubview:_button];
    }
    
    return self;
}

-(void)setData:(NSString*)info{
    _attribute.text=info;
}

-(void)clickEvent{
    [_delegate settingEvent:_attribute.text];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    // Configure the view for the selected state
    
}

@end
