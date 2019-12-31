//
//  infoCell.m
//  InsFake
//
//  Created by z on 2019/12/22.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "infoCell.h"
#import "commentList.h"
#import <XRCarouselView.h>

#define screen_wid 414
#define screen_height 896

#define icon_wid 30                     //下方点赞和评论图标大小
#define userLabel_size 40               //头像的高度与宽度
#define infoPic_height 250              //发布的信息的大小
#define likecomment_height icon_wid*2

#define comment_height 20
#define top_interval 20
#define left_interval 20
#define bottom_interval 20

#define comment_putin_height 40

@interface infoCell ()

//-(IBAction)clickComment:(id)sender;

@end

@implementation infoCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        //[self setData];
        //[self set_data];
    }
    return self;
}

-(NSInteger)getheight{
    return _h+bottom_interval;
}

-(void)set_dataByHeadImg:(UIImage*)headImg username:(NSString*)username infoPic:(NSArray*)picArray likeNum:(int)likeNum commentNum:(int)commentNum commentList:(NSArray*)commentListArray{
    CGFloat height=0;
    
    [self setHeadbyImg:headImg username:username po:height];//设置头像及名称
    
    height+=top_interval+userLabel_size;
    [self setInfoPicBypic:picArray po:height];//设置图片信息
    
    height+=top_interval+infoPic_height;
    [self setIconBylikenum:likeNum commentnum:commentNum po:height];//设置点赞与评论图标
    
    height+=icon_wid+icon_wid/2+top_interval;
    if(commentListArray.count<=2){
        for(int i=0;i<commentListArray.count;i++){
            commentList *temp=commentListArray[i];
            [self commentinfo:height+20 byuser:temp.username content:temp.comment];//添加评论
            height+=30;
        }
    } else {
        for(int i=0;i<2;i++){
            commentList *temp=commentListArray[i];
            [self commentinfo:height+20 byuser:temp.username content:temp.comment];//添加评论
            height+=30;
        }
        [self moreComment:height];
        height+=30;
        _h=height;
    }
}

-(void)moreComment:(float)h{
    UILabel *more=[[UILabel alloc]initWithFrame:CGRectMake(25, h+30, 100, 10)];
    more.text=@"更多评论";
    more.textColor=[UIColor grayColor];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMoreComment:)];
    [more addGestureRecognizer:singleTap];
    more.userInteractionEnabled=YES;
    
    [self.contentView addSubview:more];
}

-(void)commentinfo:(CGFloat)offheight byuser:(NSString*)username content:(NSString*)content{
    UILabel *username_lab=[[UILabel alloc]initWithFrame:CGRectMake(25, offheight, self.frame.size.width, 20)];
    //username_lab.text=username;
    username=[username stringByAppendingString:@"  "];
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:[username stringByAppendingString:content]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, username.length)];
    //[str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:20.0] range:NSMakeRange(0, username.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, username.length)];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:15.0] range:NSMakeRange(username.length, content.length)];
    //[str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30] range:NSMakeRange(username.length, content.length)];
    
    username_lab.attributedText=str;
    [self.contentView addSubview:username_lab];
    
    _h=offheight+comment_height;
}

-(void)setHeadbyImg:(UIImage*)headimg username:(NSString*)name po:(float)h{
    //UIImage *headimg=[UIImage imageNamed:@"headimg.png"];
    UIImageView *userhead=[[UIImageView alloc]initWithFrame:CGRectMake(left_interval, top_interval, userLabel_size, userLabel_size)];
    userhead.layer.masksToBounds=YES;
    userhead.layer.cornerRadius=userhead.frame.size.width/2;
    userhead.image=headimg;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadimg:)];
    [userhead addGestureRecognizer:singleTap];
    userhead.userInteractionEnabled=YES;
    [self.contentView addSubview:userhead];//头像
    _headview=userhead;
    
    UILabel *username=[[UILabel alloc]initWithFrame:CGRectMake(left_interval+userLabel_size+left_interval, top_interval, 100, userLabel_size)];
    username.text=name;//should change by info
    [self.contentView addSubview:username];//用户名
}

-(void)setInfoPicBypic:(NSArray*)array po:(float)height{
    XRCarouselView *showview=[[XRCarouselView alloc]initWithFrame:CGRectMake(0, height+top_interval, screen_wid, infoPic_height)];
    [showview setImageArray:array];
    showview.imageClickBlock = ^(NSInteger index) {
        //图片的点击事件
    };
    [self.contentView addSubview:showview];
}

-(void)setIconBylikenum:(int)likenum commentnum:(int)commentnum po:(float)height{
    UIButton *like=[UIButton buttonWithType:UIButtonTypeCustom];
    like.frame=CGRectMake(left_interval, top_interval+height, icon_wid, icon_wid);
    [like setImage:[self image:[UIImage imageNamed:@"xihuan_white.png"] byScalingToSize:CGSizeMake(icon_wid, icon_wid)] forState:UIControlStateNormal];
    [like addTarget:self action:@selector(likeAdd) forControlEvents:UIControlEventTouchUpInside];
    UILabel *like_num=[[UILabel alloc]initWithFrame:CGRectMake(left_interval, top_interval+height+icon_wid, icon_wid, icon_wid/2)];
    like_num.text=[NSString stringWithFormat:@"%d",likenum];
    like_num.textColor=[UIColor blackColor];
    like_num.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:like_num];
    [self.contentView addSubview:like];
    _like_num=like_num;
    _like_click=false;
    _like=like;
    _like_number=likenum;//喜欢按钮与数量
    
    UIButton *comment=[UIButton buttonWithType:UIButtonTypeCustom];
    comment.frame=CGRectMake(left_interval*2+icon_wid, top_interval+height, icon_wid, icon_wid);
    [comment setImage:[self image:[UIImage imageNamed:@"pinglun_white.png"] byScalingToSize:CGSizeMake(icon_wid, icon_wid)] forState:UIControlStateNormal];
    //[comment addTarget:self action:@selector(commentWindow:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *comment_num=[[UILabel alloc]initWithFrame:CGRectMake(top_interval*2+icon_wid, top_interval+height+icon_wid, icon_wid, icon_wid/2)];
    comment_num.text=[NSString stringWithFormat:@"%d",commentnum];
    comment_num.textColor=[UIColor blackColor];
    comment_num.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:comment_num];
    [self.contentView addSubview:comment];
    _like_num=like_num;
    _comment_click=false;
    _comment=comment;
    [_comment addTarget:self action:@selector(clickComment:) forControlEvents:UIControlEventTouchUpInside];
    _like_number=commentnum;//评论按钮与数量
}

//点击评论按钮
-(IBAction)clickComment:(id)sender{
    [_delegate commentWindow:sender];
}

//点击头像按钮
-(IBAction)clickHeadimg:(id)sender{
    [_delegate userInfoWindow];
}

//点击更多评论按钮
-(IBAction)clickMoreComment:(id)sender{
    [_delegate allCommentWindow];
}

-(void)likeAdd{
    if(_like_click==false){
        _like_click=true;
        
        _like_number++;
        _like_num.text=[NSString stringWithFormat:@"%ld",(long)_like_number];
        CGRect origin=_like.frame;
        [UIView animateWithDuration:0.25 animations:^{
            [self->_like setImage:[self image:[UIImage imageNamed:@"xihuan_red.png"] byScalingToSize:CGSizeMake(icon_wid+10, icon_wid+10)] forState:UIControlStateNormal];
            [self->_like setFrame:CGRectMake(origin.origin.x-5, origin.origin.y-5, origin.size.width+10, origin.size.height+10)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                [self->_like setImage:[self image:[UIImage imageNamed:@"xihuan_red.png"] byScalingToSize:CGSizeMake(icon_wid, icon_wid)] forState:UIControlStateNormal];
                [self->_like setFrame:origin];
            }];
        }];
        //NSLog(@"%ld", (long)_like_number);
    } else {
        _like_click=false;
        [_like setImage:[self image:[UIImage imageNamed:@"xihuan_white.png"] byScalingToSize:CGSizeMake(icon_wid, icon_wid)] forState:UIControlStateNormal];
        _like_number--;
        _like_num.text=[NSString stringWithFormat:@"%ld",(long)_like_number];
    }
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

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //NSLog(@"click to hid1");
    
    //[_commentTextField resignFirstResponder];
}

@end
