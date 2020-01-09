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
#import <AVOSCloud/AVOSCloud.h>

#define userLabel_size 40

@interface commentCell()

@property(nonatomic)unsigned long int h;
@property(nonatomic) int order;

@end

@implementation commentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        //[self set_data];
    }
    return self;
}

-(void)loadData:(int)order feedId:(NSString*)feedId{
    _order=order;
    AVQuery *query=[AVQuery queryWithClassName:@"feedInfo"];
    [query whereKey:@"objectId" equalTo:feedId];
    //NSLog(@"get data");
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        NSArray *commentsarr=object[@"comments"];
        //NSLog(@"%lu", (unsigned long)commentsarr.count);
        NSMutableDictionary *dic=commentsarr[order];
        NSString *userid=dic[@"userId"];//评论者的id
        NSString *name=[self getUsernameById:userid];
        //UIImage *headimg=[self getUserImgById:userid];
        NSString *comment=dic[@"comment"];
        
        AVQuery *query2=[AVQuery queryWithClassName:@"_User"];
        [query2 whereKey:@"objectId" equalTo:userid];
        [query2 includeKey:@"headImg"];
        NSArray *a=[query2 findObjects];
        AVObject *avobj=a[0];
        AVFile *file=avobj[@"headImg"][0];
        [file downloadWithProgress:^(NSInteger number) {
            // 下载的进度数据，number 介于 0 和 100
        } completionHandler:^(NSURL * _Nullable filePath, NSError * _Nullable error) {
            // filePath 是文件下载到本地的地址
            NSString* urlStr = [filePath absoluteString];
            NSString* cutpath=[urlStr substringWithRange:NSMakeRange(7, urlStr.length-7)];
            UIImage *i=[[UIImage alloc] initWithContentsOfFile:cutpath];
            [self set_data:i username:name info:comment];
        }];
    }];
}

-(NSString*)getUsernameById:(NSString*)Id{
    AVQuery *query=[AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:Id];
    NSArray *a=[query findObjects];
    NSString *name=a[0][@"username"];
    return name;
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
    
    AVUser *user=[AVUser currentUser];
    if([username isEqualToString:user.username]){
        //NSLog(@"find");
        float chaSize=20;
        UIButton *bu=[[UIButton alloc]initWithFrame:CGRectMake(375, 40, chaSize, chaSize)];
        [bu setImage:[self image:[UIImage imageNamed:@"chahao-3.png"] byScalingToSize:CGSizeMake(chaSize, chaSize)] forState:UIControlStateNormal];
        bu.layer.cornerRadius=5;
        //bu.tag=num;
        [bu addTarget:self action:@selector(deleteCom) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:bu];
    }
    
    _h=45+17*(row+1)+10;
    //NSLog(@"row %lu getheight %lu",row,_h);
}

-(void)deleteCom{
    [_delegate deleteComment:_order];
}

-(unsigned long int)getHeight{
    return _h;
}

- (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}

@end
