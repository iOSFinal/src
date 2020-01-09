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

-(void)commentWindow:(NSString* _Nullable)feedId;
-(void)userInfoWindow:(NSString* _Nullable)userId;
-(void)allCommentWindow:(NSString* _Nullable)feedId;
-(void)deleteComment:(NSString* _Nullable )feedId order:(int)order;
-(void)deleteFeed:(NSString*_Nullable)feedId;
-(void)openPicWindow:(int)currentnum pics:(NSArray*_Nullable)pics;
//-(void)test;

@end

@interface infoCell : UITableViewCell

@property(nullable,weak,nonatomic)id<cellClick_event> delegate;
@property(nonatomic,strong) UIButton * _Nonnull like,* _Nonnull comment;
@property(nonatomic,strong) UILabel * _Nonnull like_num,* _Nonnull comment_num;
@property(nonatomic) BOOL like_click,comment_click;
@property(nonatomic) NSInteger like_number,comment_number,h;
@property(nonatomic,strong)UIImageView * _Nullable headview;

@property(nonatomic,strong)NSString * _Nullable userID, * _Nullable feedID;

-(NSInteger)getheight;
-(void)set_dataByHeadImg:(UIImage*_Nullable)headImg username:(NSString*_Nullable)username infoPic:(NSArray*_Nullable)picArray likeNum:(int)likeNum commentNum:(int)commentNum commentList:(NSArray*_Nullable)commentListArray;
-(void)loaddata:(int)num;
@end

#endif /* infoCell_h */
