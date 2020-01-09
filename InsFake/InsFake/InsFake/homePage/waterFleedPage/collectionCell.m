//
//  collectionCell.m
//  InsFake
//
//  Created by z on 2020/1/5.
//  Copyright © 2020 lelouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "collectionCell.h"

@interface collectionCell()

@end

@implementation collectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setimg:[UIImage imageNamed:@"back.jpg"]];
    }
    return self;
}

-(void)setimg:(UIImage *)img{
    UIImageView *imgview=[[UIImageView alloc]initWithFrame:self.bounds];
    imgview.image=img;
    [self.contentView addSubview:imgview];
    _img=img;
}

@end
