//
//  MineViewController.m
//  InsFake
//
//  Created by lelouch on 2019/12/20.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import "MineViewController.h"

#define SettingView 4396

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    Username = @"卫宫家的饭桶";
    Sex = @"不明";
    Birthday = @"1997.07.21";
    Address = @"大不列颠帝国";
    HeadImage = [UIImage imageNamed:@"IMG_0015.jpg"];
    Motto = @"你就是劳资的骂死他吗?";
    Infomation = [[NSArray alloc] initWithObjects:Username, Sex, Birthday, Address,nil];
    
    UIView* visiting_card = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    visiting_card.backgroundColor = [UIColor whiteColor];
    UIImageView* head_image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 140, 110, 110)];
    head_image.image = HeadImage;
    head_image.layer.masksToBounds = YES;
    head_image.layer.cornerRadius = 10;
    head_image.userInteractionEnabled = YES;
    UITapGestureRecognizer *acta = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upAnimation)];
    [head_image addGestureRecognizer:acta];
    UILabel* username = [[UILabel alloc]initWithFrame:CGRectMake(140, 145, self.view.bounds.size.width-160, 30)];
    username.text = Username;
    username.font = [UIFont boldSystemFontOfSize:20];
    username.userInteractionEnabled = YES;
    UILabel* motto = [[UILabel alloc]initWithFrame:CGRectMake(140, 165, self.view.bounds.size.width-160, 70)];
    motto.text = Motto;
    [visiting_card addSubview:head_image];
    [visiting_card addSubview:username];
    [visiting_card addSubview:motto];
    [self.view addSubview:visiting_card];
    
    UIView* detail_card = [[UIView alloc] initWithFrame:CGRectMake(0, 325, self.view.bounds.size.width, 200)];
    detail_card.backgroundColor = [UIColor whiteColor];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [detail_card addSubview:tableView];
    [self.view addSubview:detail_card];
    
    UIView* settingview = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    settingview.backgroundColor = [UIColor whiteColor];
    [settingview setTag:SettingView];
    UILabel* back = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 50, 50)];
    back.text = @"<";
    back.font = [UIFont boldSystemFontOfSize:20];
    back.userInteractionEnabled = YES;
    UITapGestureRecognizer *act = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downAnimation)];
    [back addGestureRecognizer:act];
    UIButton* save = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-120, 130, 90, 40)];
    [save setTitle:@"完成" forState:UIControlStateNormal];
    save.titleLabel.textColor = [UIColor whiteColor];
    save.backgroundColor = [UIColor colorWithRed:0.086 green:0.608 blue:0.835 alpha:1];
    save.layer.masksToBounds = YES;
    save.layer.cornerRadius = 5;
    UITextField* input = [[UITextField alloc]initWithFrame:CGRectMake(20, 230, self.view.bounds.size.width-40, 50)];
    [settingview addSubview:input];
    [settingview addSubview:back];
    [settingview addSubview:save];
    [self.view addSubview:settingview];
}

- (void)upAnimation {
    UIView* sv = [self.view viewWithTag:SettingView];
    [UIView animateWithDuration:0.5 animations:^{
        sv.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
}

- (void)downAnimation {
    UIView* sv = [self.view viewWithTag:SettingView];
    [UIView animateWithDuration:0.5 animations:^{
        sv.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"我的";
}


#pragma mark - Table view data source
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}
//组中行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 4;
}

//cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //cell复用，唯一标识
    NSString *identifier = [NSString stringWithFormat:@"%d",indexPath.row];
    //先在缓存池中取
    InfoCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //没有再创建，添加标识，cellc移出屏幕时放入缓存池以复用
    if (cell == nil) {
        cell= [[InfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NSArray *a1 = [[NSArray alloc] initWithObjects:@"用户名",@"性别",@"生日",@"地址",nil];
    NSArray *a2 = [[NSArray alloc] initWithObjects:@"卫宫家的饭桶",@"不明",@"1997.07.21",@"大不列颠帝国",nil];
    cell.attribute.text = a1[indexPath.row];
    cell.value.text = Infomation[indexPath.row];
    cell.button.userInteractionEnabled = YES;
    UITapGestureRecognizer *act = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upAnimation)];
    [cell.button addGestureRecognizer:act];
    return cell;
}

//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
