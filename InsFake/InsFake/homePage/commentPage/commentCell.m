//
//  commentCell.m
//  InsFake
//
//  Created by z on 2019/12/31.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "commentCell.h"
#import "../../ODMultiColumnLabel/ODMultiColumnLabel.h"

#define userLabel_size 40

@interface commentCell()

@property(nonatomic)unsigned long int h;


@end

@implementation commentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        //[self set_data];
    }
    return self;
}

-(void)set_data:(UIImage*)headImg username:(NSString*)username info:(NSString*)info{
    UIImageView *userhead=[[UIImageView alloc]initWithFrame:CGRectMake(25, 20, userLabel_size, userLabel_size)];
    userhead.layer.masksToBounds=YES;
    userhead.layer.cornerRadius=userhead.frame.size.width/2;
    userhead.image=headImg;
    [self.contentView addSubview:userhead];
    
    UILabel *username_lab=[[UILabel alloc]initWithFrame:CGRectMake(25+userLabel_size+10, 20, self.frame.size.width, 20)];
    username_lab.text=username;
    [self.contentView addSubview:username_lab];
    
    unsigned long int row=info.length/35;
    
    ODMultiColumnLabel *comment=[[ODMultiColumnLabel alloc]initWithFrame:CGRectMake(25+userLabel_size+10, 45, 300, 17*(row+1))];
    
    comment.text=info;
    [comment setFont:[UIFont fontWithName:@"Arial" size:15]];
    comment.textColor=[UIColor grayColor];
    [self.contentView addSubview:comment];
    
    _h=45+17*(row+1)+10;
    //NSLog(@"row %lu getheight %lu",row,_h);
}

-(unsigned long int)getHeight{
    return _h;
}

@end
