//
//  HomePageViewController.m
//  InsFake
//
//  Created by lelouch on 2019/12/20.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import "HomePageViewController.h"
#import <IGListKit.h>

#import "infoCell.h"
#import "userInfoViewController.h"
#import "commentList.h"
#import "allCommentViewController.h"

@interface HomePageViewController ()<UITableViewDataSource,UITableViewDelegate,cellClick_event,UITextFieldDelegate,UIGestureRecognizerDelegate>

@property(strong,nonatomic)IBOutlet UITableView *table;

@end

@implementation HomePageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //self.title=@"首页";
    self.navigationItem.title=@"首页";
    self.navigationItem.hidesBackButton=YES;
    self.tabBarController.tabBar.hidden=NO;
    
    self.cellHeight=@{}.mutableCopy;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    _table=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.dataSource=self;
    self.table.delegate=self;
    
    [self.view addSubview:_table];
    //NSLog(@"out %f",self.view.frame.size.height);
    UITapGestureRecognizer *tablegesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentkeydown)];
    tablegesture.numberOfTapsRequired=1;
    tablegesture.cancelsTouchesInView=NO;
    tablegesture.delegate=self;
    [self.table addGestureRecognizer:tablegesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)load_view{
    //_numOfcell=10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    infoCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    cell=[[infoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    NSMutableArray *picArray=[[NSMutableArray alloc]init];
    [picArray addObject:[UIImage imageNamed:@"back.jpg"]];
    [picArray addObject:[UIImage imageNamed:@"head.jpg"]];
    
    NSMutableArray *commentArray=[[NSMutableArray alloc]init];
    //[commentArray addObject:[[commentList alloc]setUsername:@"小明" comment:@"好好看"]];
    //[commentArray addObject:[[commentList alloc]setUsername:@"小明" comment:@"好好看"]];
    [commentArray addObject:[[commentList alloc]setUsername:@"小明" comment:@"好好看"]];
    [commentArray addObject:[[commentList alloc]setUsername:@"小明" comment:@"好好看"]];
    [cell set_dataByHeadImg:[UIImage imageNamed:@"head.jpg"] username:@"紫罗兰" infoPic:picArray likeNum:0 commentNum:0 commentList:commentArray];
    [self.cellHeight setObject:@([cell getheight]) forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
    cell.delegate=self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)allCommentWindow{
    allCommentViewController *commentView=[[allCommentViewController alloc]init];
    [self.navigationController pushViewController:commentView animated:YES];
}

-(void)userInfoWindow{
    NSLog(@"open user info window");
    userInfoViewController *userinfo=[[userInfoViewController alloc]init];
    [userinfo set_dataByimg:[UIImage imageNamed:@"head.jpg"] username:@"卫宫家的饭桶" sex:@"女" birthday:@"2000.1.1" address:@"地球" qianming:@"你就是劳资的骂死他吗？999999999999adwd大王大王我我"];
    [self.navigationController pushViewController:userinfo animated:YES];
}
-(void)test{
    NSLog(@"test");
}

-(void)commentWindow:(UIButton *)bu{
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
    
    UIButton *b=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 10, 70, 40)];
    b.backgroundColor=[UIColor grayColor];
    [b setTitle:@"发送" forState:UIControlStateNormal];
    b.layer.cornerRadius=5;
    [b addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:b];
    _commentButton=b;
    
    _comment_window=view;
    [self.view addSubview:view];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.comment_window.frame=CGRectMake(0, height-140, self.view.frame.size.width, 60);
    }];
}

-(void)sendComment{
    [self commentkeydown];
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
    NSLog(@"key down");
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
    return [[self.cellHeight objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
}

@end
