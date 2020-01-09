//
//  VisitingCard.m
//  InsFake
//
//  Created by big-R on 2019/12/22.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import "VisitingCard.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation VisitingCard

- (id)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        _head_image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 140, 110, 110)];
        _head_image.layer.masksToBounds = YES;
        _head_image.layer.cornerRadius = 10;
        _head_image.userInteractionEnabled = YES;
        _head_image.image = [UIImage imageNamed:@"yonghu.png"];//初始化用户头像
        UITapGestureRecognizer *clik=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseHead)];
        _head_image.userInteractionEnabled=YES;
        [_head_image addGestureRecognizer:clik];
        
        AVUser *user=[AVUser currentUser];//得到当前用户
        //获取头像
        AVQuery *query2=[AVQuery queryWithClassName:@"_User"];//查询用户表
        [query2 whereKey:@"objectId" equalTo:user.objectId];//根据当前用户id查询
        [query2 includeKey:@"headImg"];
        NSArray *a=[query2 findObjects];//得到查询到的数组
        AVObject *avobj=a[0];//由于id是唯一标识，所以只会查找到一个
        AVFile *file=avobj[@"headImg"][0];//用户头像只有一张
        [file downloadWithProgress:^(NSInteger number) {
            // 下载的进度数据，number 介于 0 和 100
        } completionHandler:^(NSURL * _Nullable filePath, NSError * _Nullable error) {
            // filePath 是文件下载到本地的地址
            NSString* urlStr = [filePath absoluteString];//得到下载到本地的缓存路径
            NSString* cutpath=[urlStr substringWithRange:NSMakeRange(7, urlStr.length-7)];
            UIImage *img=[[UIImage alloc] initWithContentsOfFile:cutpath];//拿到图片
            self->_head_image.image=img;//设置用户头像
        }];
        
        _username = [[UILabel alloc]initWithFrame:CGRectMake(140, 145, [[UIScreen mainScreen] bounds].size.width-160, 30)];
        _username.font = [UIFont boldSystemFontOfSize:20];
        _username.text = user.username;
        
        _motto = [[UILabel alloc]initWithFrame:CGRectMake(140, 165, [[UIScreen mainScreen] bounds].size.width-160, 70)];
        _motto.text = user[@"qianming"];
        _motto.textColor=[UIColor grayColor];
        
        [self addSubview:_head_image];
        [self addSubview:_username];
        [self addSubview:_motto];
    }
    return self;
}

-(void)chooseHead{
    //NSLog(@"click");
    [_delegate chooseWindow];
}

- (BOOL)setHeadImage:(UIImage*)image{
    _head_image.image = image;
    return YES;
}

- (BOOL)setUsername:(NSString*)str{
    _username.text = str;
    return YES;
}

- (BOOL)setMotto:(NSString*)str{
    _motto.text = str;
    return YES;
}

@end
