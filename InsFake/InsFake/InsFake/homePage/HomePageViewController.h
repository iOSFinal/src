//
//  HomePageViewController.h
//  InsFake
//
//  Created by lelouch on 2019/12/20.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePageViewController : UIViewController

@property(nonatomic,strong)NSMutableDictionary *cellHeight;
@property(nonatomic,strong)UITextField *commentTextField;
@property(nonatomic,strong)UIView *comment_window,*recordCommentPo;
@property(nonatomic)CGPoint *commentcenter;
@property(nonatomic,strong)UIButton *commentButton;

@property(nonatomic)int test;

-(void)initData:(NSMutableArray*)arr;
-(void)refreshData;

@end

NS_ASSUME_NONNULL_END
