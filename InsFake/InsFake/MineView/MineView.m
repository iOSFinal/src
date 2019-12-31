//
//  MineView.m
//  InsFake
//
//  Created by big-R on 2019/12/22.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import "MineView.h"

#define Width [[UIScreen mainScreen] bounds].size.width
#define Heigh [[UIScreen mainScreen] bounds].size.heigh

@implementation MineView

- (id)init{
    _visiting_card = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 300)];
    _visiting_card.backgroundColor = [UIColor whiteColor];
    UIImageView* head_image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 140, 110, 110)];
    head_image.layer.masksToBounds = YES;
    head_image.layer.cornerRadius = 10;
    head_image.userInteractionEnabled = YES;
    UITapGestureRecognizer *acta = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upAnimation)];
    [head_image addGestureRecognizer:acta];
    UILabel* username = [[UILabel alloc]initWithFrame:CGRectMake(140, 145, Width-160, 30)];
    username.font = [UIFont boldSystemFontOfSize:20];
    username.userInteractionEnabled = YES;
    UILabel* motto = [[UILabel alloc]initWithFrame:CGRectMake(140, 165, Width-160, 70)];
    [_visiting_card addSubview:head_image];
    [_visiting_card addSubview:username];
    [_visiting_card addSubview:motto];
    
    
    return self;
}

@end
