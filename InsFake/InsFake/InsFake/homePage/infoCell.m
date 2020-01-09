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
#import <AVOSCloud/AVOSCloud.h>
#import <MWPhotoBrowser.h>

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

@property(nonatomic,strong)XRCarouselView* infopic;
@property(nonatomic,strong)UILabel* usernameLab;
//-(IBAction)clickComment:(id)sender;
@property(nonatomic,strong)NSMutableArray *mwarr;

@end

@implementation infoCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self initdata];
    }
    return self;
}

-(NSInteger)getheight{
    return _h+bottom_interval;
    //return 485;
}

-(void)loaddata:(int)num{
    AVQuery *query=[AVQuery queryWithClassName:@"feedInfo"];
    [query includeKey:@"pics"];
    [query orderByDescending:@"createdAt"];
    query.skip=num;
    query.limit=1;
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        NSString *userid=object[@"userId"];
        self->_userID=userid;
        self->_feedID=object[@"objectId"];
        NSString *username=[self getUsernameById:userid];
        self->_usernameLab.text=username;//设置用户名
        self->_like_num.text=[NSString stringWithFormat:@"%@",object[@"likeNum"]];
        self->_like_number=[self->_like_num.text intValue];
        self->_comment_num.text=[NSString stringWithFormat:@"%@",object[@"commentNum"]];
        //NSLog(@"ccc  %@", self->_comment_num.text);
        self->_comment_number=[self->_comment_num.text intValue];
        
        //获取头像
        AVQuery *query2=[AVQuery queryWithClassName:@"_User"];
        [query2 whereKey:@"objectId" equalTo:userid];
        [query2 includeKey:@"headImg"];
        NSArray *a=[query2 findObjects];
        //NSLog(@"%lu", (unsigned long)a.count);
        AVObject *avobj=a[0];
        AVFile *file=avobj[@"headImg"][0];
        [file downloadWithProgress:^(NSInteger number) {
            // 下载的进度数据，number 介于 0 和 100
            //NSLog(@"%ld", (long)number);
        } completionHandler:^(NSURL * _Nullable filePath, NSError * _Nullable error) {
            // filePath 是文件下载到本地的地址
            NSString* urlStr = [filePath absoluteString];
            NSString* cutpath=[urlStr substringWithRange:NSMakeRange(7, urlStr.length-7)];
            //NSLog(@"%@", cutpath);
            UIImage *i=[[UIImage alloc] initWithContentsOfFile:cutpath];
            self->_headview.image=i;
        }];
        AVUser *user=[AVUser currentUser];
        if([user.objectId isEqualToString:self->_userID]){
            float chaSize=20;
            UIButton *bu=[[UIButton alloc]initWithFrame:CGRectMake(375, top_interval+10, chaSize, chaSize)];
            [bu setImage:[self image:[UIImage imageNamed:@"chahao-3.png"] byScalingToSize:CGSizeMake(chaSize, chaSize)] forState:UIControlStateNormal];
            bu.layer.cornerRadius=5;
            //bu.tag=num;
            [bu addTarget:self action:@selector(deleteFeed) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:bu];
        }
        
        //获取图片信息流
        self->_mwarr=[[NSMutableArray alloc]init];
        NSArray *arr=object[@"pics"];
        NSMutableArray *imgs=[[NSMutableArray alloc]init];
        //NSLog(@"%lu", (unsigned long)arr.count);
        for(int j=0;j<arr.count;j++){
            AVFile *file=arr[j];
            [file downloadWithProgress:^(NSInteger number) {
                // 下载的进度数据，number 介于 0 和 100
            } completionHandler:^(NSURL * _Nullable filePath, NSError * _Nullable error) {
                // filePath 是文件下载到本地的地址
                NSString* urlStr = [filePath absoluteString];
                NSString* cutpath=[urlStr substringWithRange:NSMakeRange(7, urlStr.length-7)];
                //NSLog(@"%@",cutpath);
                UIImage *image = [[UIImage alloc] initWithContentsOfFile:cutpath];
                [imgs addObject:image];
                [self->_infopic setImageArray:imgs];
                MWPhoto *phos=[MWPhoto photoWithImage:image];
                [self->_mwarr addObject:phos];
            }];
        }
        
        //设置评论信息
        NSArray *commentsarr=object[@"comments"];
        float height=icon_wid+icon_wid/2+top_interval+top_interval+userLabel_size+top_interval+infoPic_height+20;
        //NSMutableArray *comments=[[NSMutableArray alloc]init];//储存评论信息
        for(int j=0;j<commentsarr.count;j++){
            if(j==2){
                break;//最多显示2条
            }
            NSMutableDictionary *dic=commentsarr[j];
            NSString *userid=dic[@"userId"];//评论者的id
            NSString *name=[self getUsernameById:userid];
            //UIImage *headimg=[self getUserImgById:userid];
            NSString *comment=dic[@"comment"];
            [self commentinfo:height byuser:name content:comment num:j];
            height+=30;
        }
        if(commentsarr.count>2){
            [self moreComment:height-30];
        }
        
        //查看喜欢人的列表
        
        NSArray *likeUser=object[@"likeUsers"];
        for(int j=0;j<likeUser.count;j++){
            NSMutableDictionary *dic=likeUser[j];
            NSString *name=dic[@"userId"];
            //NSLog(@"%@", dic[@"userId"]);
            if([name isEqualToString:user.objectId]){
                self->_like_click=true;
                [self->_like setImage:[self image:[UIImage imageNamed:@"xihuan_red.png"] byScalingToSize:CGSizeMake(icon_wid, icon_wid)] forState:UIControlStateNormal];
                break;
            }
        }
        
        
        
        height+=30;
        self->_h=height;
        //NSLog(@"load data height %ld",(long)self->_h);
        [self layoutIfNeeded];
    }];
}

-(NSString*)getUsernameById:(NSString*)Id{
    AVQuery *query=[AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:Id];
    NSArray *a=[query findObjects];
    NSString *name=a[0][@"username"];
    return name;
}

-(void)initdata{
    CGFloat height=0;
    
    [self setHeadbyImg:[UIImage imageNamed:@"loadPic.png"] username:@"" po:height];//设置头像及名称
    
    height+=top_interval+userLabel_size;
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    [arr addObject:[UIImage imageNamed:@"loadPic.png"]];
    [self setInfoPicBypic:arr po:height];//设置图片信息
    
    height+=top_interval+infoPic_height;
    [self setIconBylikenum:0 commentnum:0 po:height];//设置点赞与评论图标
    
    if(_h<height+icon_wid+icon_wid/2+top_interval){
        _h=height+icon_wid+icon_wid/2+top_interval;
    }
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
            [self commentinfo:height+20 byuser:temp.username content:temp.comment num:i];//添加评论
            height+=30;
        }
    } else {
        for(int i=0;i<2;i++){
            commentList *temp=commentListArray[i];
            [self commentinfo:height+20 byuser:temp.username content:temp.comment num:i];//添加评论
            height+=30;
        }
        [self moreComment:height];
        height+=30;
        _h=height;
    }
}

-(void)moreComment:(float)h{
    UILabel *more=[[UILabel alloc]initWithFrame:CGRectMake(325, h+25+20, 100, 10)];
    more.text=@"更多评论";
    more.textColor=[UIColor grayColor];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMoreComment:)];
    [more addGestureRecognizer:singleTap];
    more.userInteractionEnabled=YES;
    
    [self.contentView addSubview:more];
}

-(void)commentinfo:(CGFloat)offheight byuser:(NSString*)username content:(NSString*)content num:(int)num{
    UILabel *username_lab=[[UILabel alloc]initWithFrame:CGRectMake(25, offheight, self.frame.size.width-100, 20)];
    //username_lab.text=username;
    NSString *originName=username;
    username=[username stringByAppendingString:@"  "];
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:[username stringByAppendingString:content]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, username.length)];
    //[str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:20.0] range:NSMakeRange(0, username.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, username.length)];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:15.0] range:NSMakeRange(username.length, content.length)];
    //[str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30] range:NSMakeRange(username.length, content.length)];
    
    username_lab.attributedText=str;
    [self.contentView addSubview:username_lab];
    
    AVUser *user=[AVUser currentUser];
    if([originName isEqualToString:user.username]){
        //NSLog(@"find");
        float chaSize=20;
        UIButton *bu=[[UIButton alloc]initWithFrame:CGRectMake(375, offheight, chaSize, chaSize)];
        [bu setImage:[self image:[UIImage imageNamed:@"chahao-3.png"] byScalingToSize:CGSizeMake(chaSize, chaSize)] forState:UIControlStateNormal];
        bu.layer.cornerRadius=5;
        bu.tag=num;
        [bu addTarget:self action:@selector(deleteCom:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:bu];
    }
    
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
    _usernameLab=username;
}

-(void)setInfoPicBypic:(NSArray*)array po:(float)height{
    XRCarouselView *showview=[[XRCarouselView alloc]initWithFrame:CGRectMake(0, height+top_interval, screen_wid, infoPic_height)];//初始化组件
    [showview setImageArray:array];//添加显示图片
    showview.imageClickBlock = ^(NSInteger index) {
        //图片的点击事件
        [self openPics:index];
    };
    _infopic=showview;
    [self.contentView addSubview:showview];
}

-(void)openPics:(int)num{
    [_delegate openPicWindow:num pics:_mwarr];
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
    _comment_num=comment_num;
    _comment_click=false;
    _comment=comment;
    [_comment addTarget:self action:@selector(clickComment:) forControlEvents:UIControlEventTouchUpInside];
    _comment_number=commentnum;//评论按钮与数量
}

//删除feed信息
-(void)deleteFeed{
    [_delegate deleteFeed:_feedID];
}

//点击删除评论按钮
-(void)deleteCom:(UIButton*)bu{
    [_delegate deleteComment:_feedID order:bu.tag];
}

//点击评论按钮
-(IBAction)clickComment:(id)sender{
    [_delegate commentWindow:_feedID];
}

//点击头像按钮
-(IBAction)clickHeadimg:(id)sender{
    [_delegate userInfoWindow:_userID];
}

//点击更多评论按钮
-(IBAction)clickMoreComment:(id)sender{
    [_delegate allCommentWindow:self->_feedID];
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
        
        AVQuery *query=[AVQuery queryWithClassName:@"feedInfo"];
        [query whereKey:@"objectId" equalTo:_feedID];
        AVObject *obj=[query getFirstObject];
        NSMutableArray *likeUser=obj[@"likeUsers"];
        AVUser *user=[AVUser currentUser];
        NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
        [dic setObject:user.objectId forKey:@"userId"];
        [likeUser addObject:dic];
        NSInteger amount=1;
        [obj incrementKey:@"likeNum" byAmount:@(amount)];
        [obj setObject:likeUser forKey:@"likeUsers"];
        [obj saveInBackground];
    } else {
        _like_click=false;
        [_like setImage:[self image:[UIImage imageNamed:@"xihuan_white.png"] byScalingToSize:CGSizeMake(icon_wid, icon_wid)] forState:UIControlStateNormal];
        _like_number--;
        _like_num.text=[NSString stringWithFormat:@"%ld",(long)_like_number];
        
        AVQuery *query=[AVQuery queryWithClassName:@"feedInfo"];
        [query whereKey:@"objectId" equalTo:_feedID];
        AVObject *obj=[query getFirstObject];
        NSMutableArray *likeUser=obj[@"likeUsers"];
        AVUser *user=[AVUser currentUser];
        for(int j=0;j<likeUser.count;j++){
            NSMutableDictionary *dic=likeUser[j];
            NSString *name=dic[@"userId"];
            if([name isEqualToString:user.objectId]){
                [likeUser removeObjectAtIndex:j];
                break;
            }
        }
        NSInteger amount=-1;
        [obj incrementKey:@"likeNum" byAmount:@(amount)];
        [obj setObject:likeUser forKey:@"likeUsers"];
        [obj saveInBackground];
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
