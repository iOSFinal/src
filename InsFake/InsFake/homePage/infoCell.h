//
//  infoCell.h
//  InsFake
//
//  Created by z on 2019/12/22.
//  Copyright © 2019 lelouch. All rights reserved.
//

#ifndef infoCell_h
#define infoCell_h
#import <UIKit/UIKit.h>

@protocol cellClick_event<NSObject>

-(void)commentWindow:(UIButton* _Nonnull )bu;
-(void)userInfoWindow;
-(void)allCommentWindow;
//-(void)test;

@end

@interface infoCell : UITableViewCell

@property(nullable,weak,nonatomic)id<cellClick_event> delegate;
@property(nonatomic,strong) UIButton * _Nonnull like,* _Nonnull comment;
@property(nonatomic,strong) UILabel * _Nonnull like_num,* _Nonnull comment_num;
@property(nonatomic) BOOL like_click,comment_click;
@property(nonatomic) NSInteger like_number,comment_number,h;
@property(nonatomic,strong)UIImageView * _Nullable headview;

-(NSInteger)getheight;
-(void)set_dataByHeadImg:(UIImage*_Nullable)headImg username:(NSString*_Nullable)username infoPic:(NSArray*_Nullable)picArray likeNum:(int)likeNum commentNum:(int)commentNum commentList:(NSArray*_Nullable)commentListArray;

@end

#endif /* infoCell_h */
