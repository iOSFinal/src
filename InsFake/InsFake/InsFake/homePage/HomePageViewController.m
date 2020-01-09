//
//  HomePageViewController.m
//  InsFake
//
//  Created by lelouch on 2019/12/20.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import "HomePageViewController.h"
//#import <IGListKit.h>
#import <MJRefresh.h>
#import <AVOSCloud/AVOSCloud.h>

#import "infoCell.h"
#import "infoStruct.h"
#import "userInfoViewController.h"
#import "commentList.h"
#import "allCommentViewController.h"

#import "myButton.h"

#import <UITableView+FDTemplateLayoutCell.h>
#import <HDAlertView.h>
#import <LemonBubble.h>
#import <MWPhotoBrowser.h>
#import "waterFleedPage/waterFleedViewController.h"

@interface HomePageViewController ()<UITableViewDataSource,UITableViewDelegate,cellClick_event,UITextFieldDelegate,UIGestureRecognizerDelegate,MWPhotoBrowserDelegate>

@property(strong,nonatomic)IBOutlet UITableView *table;
@property(strong,nonatomic)NSMutableArray *array;
@property(nonatomic)int numOfcell;
@property(nonatomic)BOOL refresh;
@property(nonatomic,strong)UIButton *topBu;
@property(nonatomic)BOOL topbuFlag;

@property(nonatomic,strong)NSArray* picsArr;
@property(nonatomic)CGFloat offcontent;

@end

@implementation HomePageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    /*for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }*/
    self.navigationItem.title=@"InsFake";
    self.navigationItem.hidesBackButton=YES;
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont fontWithName:@"Arial" size:20]}];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发现" style:UIBarButtonItemStylePlain target:self action:@selector(openFleed)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    //NSLog(@"test %d", _test);
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    _numOfcell=0;
    _refresh=false;
    self.cellHeight=@{}.mutableCopy;
    [self load10data];
    //self.title=@"首页";
    
    _table=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.tableFooterView = [[UIView alloc]init];
    self.table.dataSource=self;
    self.table.delegate=self;
    //_table.rowHeight = UITableViewAutomaticDimension;
    self.table.estimatedRowHeight = 0;
    self.table.estimatedSectionFooterHeight = 0;
    self.table.estimatedSectionHeaderHeight = 0;
    //_table.estimatedRowHeight=450.0;
    //[self.table registerClass:[infoCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:_table];
    UITapGestureRecognizer *tablegesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentkeydown)];
    tablegesture.numberOfTapsRequired=1;
    tablegesture.cancelsTouchesInView=NO;
    tablegesture.delegate=self;
    [self.table addGestureRecognizer:tablegesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.table.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.table.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    _topbuFlag=false;
    
    
}

-(void)openFleed{
    //NSLog(@"click");
    waterFleedViewController *con=[[waterFleedViewController alloc]init];
    [self.navigationController pushViewController:con animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //CGFloat height = scrollView.frame.size.height;
    [self commentkeydown];
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if(_refresh==false)
    _offcontent=contentOffsetY;
    if (contentOffsetY>100)
    {
        //在最底部
        if(_topbuFlag==false){
            [self addToTop];
            _topbuFlag=true;
        }
    } else {
        _topbuFlag=false;
        [_topBu removeFromSuperview];
    }
}

-(void)addToTop{
    UIButton *bu=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-140, 30, 30)];
    [bu setImage:[UIImage imageNamed:@"toTop.png"] forState:UIControlStateNormal];
    bu.layer.cornerRadius=15;
    bu.backgroundColor=[UIColor whiteColor];
    [bu addTarget:self action:@selector(toTop) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:bu];
    _topBu=bu;
}

-(void)toTop{
    [self.table setContentOffset:CGPointMake(0,-80) animated:YES];
}

-(void)load10data{
    AVQuery *query=[AVQuery queryWithClassName:@"feedInfo"];//need to change
    query.limit=10+_numOfcell;//only 10 data
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self->_numOfcell=objects.count;
        //NSLog(@"cell %d", self->_numOfcell);
        for(int i=0;i<objects.count;i++){
            NSNumber *num=objects[i][@"commentNum"];
            int n=num.intValue;
            float h;
            if(n>2){
                h=505;
            } else if(n==2){
                h=475;
            } else if(n==1){
                h=445;
            } else {
                h=415;
            }
            //NSLog(@"height %f",h);
            [self.cellHeight setObject:@(h) forKey:[NSString stringWithFormat:@"%d",i]];
        }
        [self->_table reloadData];
    }];
}

-(NSString*)getUsernameById:(NSString*)Id{
    AVQuery *query=[AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:Id];
    NSArray *a=[query findObjects];
    NSString *name=a[0][@"username"];
    return name;
}

-(void)loadMore{
    NSLog(@"load more");
    //[_array addObject:@"s"];
    [self load10data];
    _refresh=true;
    [_table reloadData];
    [_table.mj_footer endRefreshing];
}

-(void)uploadDataByUserId:(NSString*)userId pics:(NSArray*)pics{
    AVObject *obj=[AVObject objectWithClassName:@"feedInfo"];
    [obj setObject:userId forKey:@"userId"];//设置发帖人id
    NSNumber *number = [NSNumber numberWithInt:0];
    [obj setObject:number forKey:@"likeNum"];//设置喜欢与点赞数量为0
    [obj setObject:number forKey:@"commentNum"];
    for(int i=0;i<pics.count;i++){
        UIImage *temp=pics[i];
        NSData *data=UIImageJPEGRepresentation(temp, 1.0);
        AVFile *file=[AVFile fileWithData:data name:@"1.jpg"];
        [obj addObject:file forKey:@"pics"];
    }
    
    NSMutableArray *com=[[NSMutableArray alloc]init];
    [obj setObject:com forKey:@"comments"];//初始化评论
    [obj saveInBackground];
}

-(void)refreshData{
    _numOfcell=0;
    _refresh=true;
    [self load10data];
    [_table reloadData];
    [_table.mj_header endRefreshing];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return _array.count;
    //return 0;
    return _numOfcell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    infoCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if(cell==NULL||_refresh==true){
        cell=[[infoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        [cell loaddata:indexPath.row];
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if(indexPath.row==_numOfcell-1){
        _refresh=false;
    }
    return cell;
}

//删除某一条feed信息
-(void)deleteFeed:(NSString *)feedId{
    HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"" andMessage:@"是否删除"];
    [alertView setDefaultButtonTitleColor:[UIColor blackColor]];
    [alertView addButtonWithTitle:@"确认" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
        NSLog(@"ok");
        AVQuery *query=[AVQuery queryWithClassName:@"feedInfo"];
        [query whereKey:@"objectId" equalTo:feedId];
        AVObject *obj=[query getFirstObject];
        [obj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                LKRightBubble(@"删除成功", 2);
                self->_numOfcell--;
            } else {
                LKErrorBubble(@"删除失败", 2);
            }
            [self refreshData];
        }];
    }];
    
    [alertView addButtonWithTitle:@"取消" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
        NSLog(@"cancel");
    }];
    
    [alertView show];
}

//删除某一条评论
-(void)deleteComment:(NSString *)feedId order:(int)order{
    HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"" andMessage:@"是否删除该评论"];
    [alertView setDefaultButtonTitleColor:[UIColor blackColor]];
    [alertView addButtonWithTitle:@"确认" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
        NSLog(@"ok");
        AVQuery *query=[AVQuery queryWithClassName:@"feedInfo"];
        [query whereKey:@"objectId" equalTo:feedId];
        AVObject *obj=[query getFirstObject];
        [obj incrementKey:@"commentNum" byAmount:@(-1)];
        NSMutableArray *arr=obj[@"comments"];
        [arr removeObjectAtIndex:order];
        [obj setObject:arr forKey:@"comments"];
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                LKRightBubble(@"删除成功", 2);
            } else {
                LKErrorBubble(@"删除失败", 2);
            }
            [self refreshData];
        }];
    }];
    
    [alertView addButtonWithTitle:@"取消" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
        NSLog(@"cancel");
    }];
    
    [alertView show];
}

//打开所有评论页面
-(void)allCommentWindow:(NSString*)feedId{
    allCommentViewController *commentView=[[allCommentViewController alloc]init];
    AVQuery *query=[AVQuery queryWithClassName:@"feedInfo"];
    [query whereKey:@"objectId" equalTo:feedId];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        NSString* numOfCom=object[@"commentNum"];
        //NSLog(@"numofcell %d",numOfCom);
        [commentView setNumCell:[numOfCom intValue]];
        //NSLog(@"%d",[numOfCom intValue]);
        [commentView setFeedId:feedId];
        [self.navigationController pushViewController:commentView animated:YES];
    }];
    
}

//打开用户详情界面
-(void)userInfoWindow:(NSString*)userId{
    NSLog(@"open user info window");
    userInfoViewController *userinfo=[[userInfoViewController alloc]init];
    //[userinfo set_dataByimg:[UIImage imageNamed:@"head.jpg"] username:@"卫宫家的饭桶" sex:@"女" birthday:@"2000.1.1" address:@"地球" qianming:@"你就是劳资的骂死他吗？999999999999adwd大王大王我我"];
    [userinfo loadDataById:userId];
    [self.navigationController pushViewController:userinfo animated:YES];
}

//打开评论界面
-(void)commentWindow:(NSString*)feedId{
    float height=self.view.frame.size.height;
    //NSLog(@"%f",height);
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, height, self.view.frame.size.width, 60)];
    _recordCommentPo=[[UIView alloc]initWithFrame:CGRectMake(0, height-140, self.view.frame.size.width, 60)];
    view.backgroundColor=[UIColor whiteColor];
    //10,10
    UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-100, 40)];
    text.placeholder=@"评论";
    text.borderStyle=UITextBorderStyleRoundedRect;
    text.clearButtonMode=UITextFieldViewModeWhileEditing;
    //[self.view addSubview:text];
    [view addSubview:text];
    _commentTextField=text;
    _commentTextField.delegate=self;
    //self.commentcenter=view.center;
    
    myButton *b=[[myButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 10, 70, 40)];
    b.backgroundColor=[UIColor grayColor];
    [b setTitle:@"发送" forState:UIControlStateNormal];
    b.layer.cornerRadius=5;
    b.Id=feedId;
    [b addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:b];
    _commentButton=b;
    
    _comment_window=view;
    [self.view addSubview:view];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.comment_window.frame=CGRectMake(0, height-140, self.view.frame.size.width, 60);
    }];
}

-(void)initData:(NSMutableArray *)arr{
    _array=arr;
}

-(void)sendComment:(myButton*)bu{
    AVQuery *query=[AVQuery queryWithClassName:@"feedInfo"];
    [query whereKey:@"objectId" equalTo:bu.Id];
    AVObject *q=[query getFirstObject];
    [q incrementKey:@"commentNum" byAmount:@1];
    NSMutableArray *arr=q[@"comments"];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:self->_commentTextField.text forKey:@"comment"];
    AVUser *user=[AVUser currentUser];
    [dic setObject:user.objectId forKey:@"userId"];
    [arr addObject:dic];
    [q setObject:arr forKey:@"comments"];
    [q saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            LKRightBubble(@"发表成功", 2);
            [self commentkeydown];
            [self refreshData];
            //NSLog(@"off %f",self->_offcontent);
            [self.table setContentOffset:CGPointMake(0,self->_offcontent) animated:NO];
            //[self.table reloadData];
            
        } else {
            LKErrorBubble(@"发表失败", 2);
        }
    }];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //NSLog(@"%lu and range %lu", (unsigned long)_commentTextField.text.length,range.location);
    if(textField==_commentTextField){
        if(textField.text.length==1&&range.location==0){
            _commentButton.backgroundColor=[UIColor grayColor];
            _commentButton.enabled=NO;
        } else {
            _commentButton.backgroundColor=[UIColor colorWithRed:22.0/255.0 green:155.0/255.0 blue:213.0/255.0 alpha:1];
            _commentButton.enabled=YES;
        }
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘高度 keyboardHeight
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    //当前屏幕高度，无论横屏竖屏
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    //主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //获取当前响应者
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    NSLog(@"firstResponder:%@",firstResponder);
    
    // Twitter 网络登录时上移问题
    Class clName = NSClassFromString(@"UIWebBrowserView");
    if ([firstResponder isKindOfClass:clName]) return;
    if (![firstResponder respondsToSelector:@selector(center)]) return;
    
    //当前响应者在其父视图的中点(x居中 y最下点)
    CGPoint firstCPoint = CGPointMake(firstResponder.center.x, CGRectGetMaxY(firstResponder.frame));
    //当前响应者在屏幕中的point
    CGPoint convertPoint = [keyWindow convertPoint:firstCPoint fromView:firstResponder.superview];
    //[firstResponder convertPoint:firstCPoint toView:keyWindow];
    //当前响应者的最大y值
    CGFloat firstRespHeight = convertPoint.y;
    
    //键盘最高点的y值
    CGFloat topHeighY = screenH - keyboardHeight;//顶部高度的Y值
    if (topHeighY < firstRespHeight) { //键盘挡住了当前响应的控件 需要上移
        CGFloat spaceHeight = firstRespHeight - topHeighY;
        self.comment_window.center = CGPointMake(self.comment_window.center.x, self.comment_window.center.y - spaceHeight);
        
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        }];
        
    }else{
        NSLog(@"键盘未挡住输入框");
    }
    
    
    NSLog(@"show");
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    self.comment_window.center = _recordCommentPo.center;
    
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    NSLog(@"hide");
    //[_commentTextField resignFirstResponder];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"click to hid");
    //[_commentTextField resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"click to hid");
    //[_commentTextField resignFirstResponder];
}

//点击屏幕事件
-(void)commentkeydown{
    //NSLog(@"key down");
    [_commentTextField resignFirstResponder];
    [UIView animateWithDuration:1.0 animations:^{
        self.comment_window.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 60);
        
    } completion:^(BOOL finished) {
        //[self.comment_window removeFromSuperview];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //infoCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"height %ld", (long)[cell getheight]);
    //return [cell getheight];//这里应该根据具体内容调整高度
    CGFloat temp=[[self.cellHeight objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
    if(temp<100){
        return 500;
    }
    return temp;
}

-(void)openPicWindow:(int)currentnum pics:(NSArray*)pics{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [browser setCurrentPhotoIndex:currentnum];//设置当前阅读的图片
    _picsArr=pics;
    [self.navigationController pushViewController:browser animated:YES];
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _picsArr.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _picsArr.count)
        return [_picsArr objectAtIndex:index];
    return nil;
}

@end
