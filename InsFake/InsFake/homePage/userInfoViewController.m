//
//  userInfoViewController.m
//  InsFake
//
//  Created by z on 2019/12/26.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userInfoViewController.h"

#define screen_wid self.view.frame.size.width
#define screen_height self.view.frame.size.height

#define top_off 90
#define headImg_height 200

@interface userInfoViewController()

@end

@implementation userInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1];
    self.navigationItem.title=@"个人信息页面";
    
    
    //[self load_view];
}

-(void)set_dataByimg:(UIImage*)img username:(NSString*)username sex:(NSString*)sex birthday:(NSString*)birthday address:(NSString*)address qianming:(NSString*)info{
    [self load_userHeadImg:img username:username info:info];
    [self load_userInfoByusername:username sex:sex birthday:birthday address:address];
}

-(void)load_userHeadImg:(UIImage*)img username:(NSString*)username info:(NSString*)info{
    float img_size=100;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, top_off+10, screen_wid, headImg_height)];
    view.backgroundColor=[UIColor whiteColor];
    UIImageView *imgview=[[UIImageView alloc]initWithFrame:CGRectMake(20,  headImg_height/2-img_size/2, img_size, img_size)];
    [imgview setImage:[self image:img byScalingToSize:CGSizeMake(50, 50)]];
    imgview.layer.cornerRadius=10;
    imgview.layer.masksToBounds=YES;
    [view addSubview:imgview];
    
    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(20+img_size+20, headImg_height/2-img_size/2+20, 150, 30)];
    name.text=username;
    [name setFont:[UIFont fontWithName:@"Arial" size:24.0]];
    [view addSubview:name];
    
    UILabel *qianming=[[UILabel alloc]initWithFrame:CGRectMake(20+img_size+20, headImg_height/2-img_size/2+20+30+10, 250, 90)];
    qianming.text=info;
    [qianming setFont:[UIFont fontWithName:@"Arial" size:20.0]];
    qianming.textColor=[UIColor grayColor];
    [qianming setNumberOfLines:0];
    qianming.lineBreakMode=UILineBreakModeClip;
    qianming.text=[info stringByAppendingString:@"\n\n\n"];
    //qianming.preferredMaxLayoutWidth=250;
    /*UITextField *qianming=[[UITextField alloc]initWithFrame:CGRectMake(20+img_size+20, headImg_height/2-img_size/2+20+30+10, 250, 60)];
    qianming.text=info;
    [qianming setFont:[UIFont fontWithName:@"Arial" size:20.0]];
    qianming.textColor=[UIColor grayColor];
    qianming.enabled=NO;
    qianming.textAlignment=NSTextAlignmentLeft;
    qianming.contentVerticalAlignment=UIControlContentVerticalAlignmentTop;*/
    [view addSubview:qianming];
    
    [self.view addSubview:view];
}

-(void)load_userInfoByusername:(NSString*)username sex:(NSString*)sex birthday:(NSString*)birthday address:(NSString*)address{
    float beginHeight=top_off+headImg_height+10+20;
    NSString *left_off=@"      ";
    [self addInfoLabelTitle:[left_off stringByAppendingString:@"用户名     "] info:username height:beginHeight];
    [self addInfoLabelTitle:[left_off stringByAppendingString:@"性别         "] info:sex height:beginHeight+60];
    [self addInfoLabelTitle:[left_off stringByAppendingString:@"生日         "] info:birthday height:beginHeight+60*2];
    [self addInfoLabelTitle:[left_off stringByAppendingString:@"地址         "] info:address height:beginHeight+60*3];
}

-(void)addInfoLabelTitle:(NSString*)title info:(NSString*)info height:(float)h{
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, h, screen_wid, 50)];
    lab.backgroundColor=[UIColor whiteColor];
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:[title stringByAppendingString:info]];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:20.0] range:NSMakeRange(0, title.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:15.0] range:NSMakeRange(title.length, info.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(title.length, info.length)];
    lab.attributedText=str;
    [self.view addSubview:lab];
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
