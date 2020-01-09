//
//  allCommentViewController.m
//  InsFake
//
//  Created by z on 2019/12/30.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "allCommentViewController.h"
#import "../commentList.h"
#import "commentCell.h"
#import <HDAlertView.h>
#import <AVOSCloud/AVOSCloud.h>
#import <LemonBubble.h>

@interface allCommentViewController()<UITableViewDelegate,UITableViewDataSource,commentCellClick_event>

@property(strong,nonatomic)IBOutlet UITableView *table;
@property(strong,nonatomic)NSMutableArray *commenArray;
@property(nonatomic,strong)NSMutableDictionary *cellHeight;

@end


@implementation allCommentViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
    
    self.cellHeight=@{}.mutableCopy;
    //[self loadCommentData];
    //_num=0;
    
    _table=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.tableFooterView = [[UIView alloc]init];
    self.table.dataSource=self;
    self.table.delegate=self;
    [self.view addSubview:_table];
    //[self.table reloadData];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1];
    self.navigationItem.title=@"评论";
}

-(void)setFeedId:(NSString *)feedId{
    _feedId=feedId;
}

-(void)setNumCell:(int)n{
    _num=n;
    [self.table reloadData];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    commentCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    cell=[[commentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    [cell loadData:indexPath.row feedId:_feedId];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selected=NO;
    
    [self.cellHeight setObject:@([cell getHeight]) forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
    cell.delegate=self;
    return cell;
}

-(void)deleteComment:(int)order{
    //NSLog(@"delete");
    HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"" andMessage:@"是否删除该评论"];
    [alertView setDefaultButtonTitleColor:[UIColor blackColor]];
    [alertView addButtonWithTitle:@"确认" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
        NSLog(@"ok");
        AVQuery *query=[AVQuery queryWithClassName:@"feedInfo"];
        [query whereKey:@"objectId" equalTo:self->_feedId];
        AVObject *obj=[query getFirstObject];
        [obj incrementKey:@"commentNum" byAmount:@(-1)];
        NSMutableArray *arr=obj[@"comments"];
        [arr removeObjectAtIndex:order];
        [obj setObject:arr forKey:@"comments"];
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                LKRightBubble(@"删除成功", 2);
                self->_num--;
            } else {
                LKErrorBubble(@"删除失败", 2);
            }
            [self.table reloadData];
        }];
    }];
    
    [alertView addButtonWithTitle:@"取消" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
        NSLog(@"cancel");
    }];
    
    [alertView show];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float t=[[self.cellHeight objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
    //NSLog(@"%f",t);
    return 100;
}

-(float)addCommentByName:(NSString*)name info:(NSString*)info height:(float)h{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"%d", _num);
    return _num;
}

@end
