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

@interface allCommentViewController()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)IBOutlet UITableView *table;
@property(strong,nonatomic)NSMutableArray *commenArray;
@property(nonatomic,strong)NSMutableDictionary *cellHeight;

@end


@implementation allCommentViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1];
    self.navigationItem.title=@"评论";
    
    self.cellHeight=@{}.mutableCopy;
    [self loadCommentData];
    
    _table=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.tableFooterView = [[UIView alloc]init];
    self.table.dataSource=self;
    self.table.delegate=self;
    [self.view addSubview:_table];
    
}

-(void)loadCommentData{
    _commenArray=[[NSMutableArray alloc]init];
    for(int i=0;i<10;i++){
        [_commenArray addObject:[[commentList alloc]setUsername:@"小明" comment:@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaab" headImg:[UIImage imageNamed:@"head.jpg"]]];
    }
    [_table reloadData];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    commentCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    cell=[[commentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if(_commenArray.count>indexPath.row){
        commentList *temp=_commenArray[indexPath.row];
        [cell set_data:temp.headImg username:temp.username info:temp.comment];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selected=NO;
    
    [self.cellHeight setObject:@([cell getHeight]) forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float t=[[self.cellHeight objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
    //NSLog(@"%f",t);
    return t;
}

-(float)addCommentByName:(NSString*)name info:(NSString*)info height:(float)h{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

@end
