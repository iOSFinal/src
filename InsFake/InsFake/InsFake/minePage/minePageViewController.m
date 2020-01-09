//
//  minePageViewController.m
//  InsFake
//
//  Created by z on 2020/1/5.
//  Copyright © 2020 lelouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "minePageViewController.h"
#import "MineView/VisitingCard.h"
#import "MineView/InfoCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MineView/Setting.h"
#import <LemonBubble.h>
#import "../signinupPage/LoginViewController.h"
#import "../PhotoBrowser/ZLDefine.h"

@interface MineViewController()<UITableViewDelegate,UITableViewDataSource,clickEventPro,alertChoose,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(strong,nonatomic)IBOutlet UITableView *table;
@property(strong,nonatomic)NSString* Username,* Sex,* Address,* Birthday,*qianming;
@property(strong,nonatomic)VisitingCard* card;

@end

@implementation MineViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden=NO;
    self.navigationItem.title=@"我的";
    [self loadData];
    _card.username.text=_Username;
    _card.motto.text=_qianming;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1];
    VisitingCard* visiting_card = [[VisitingCard alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    visiting_card.motto.userInteractionEnabled = YES;
    //[visiting_card.motto addGestureRecognizer:act[4]];
    visiting_card.head_image.userInteractionEnabled = YES;
    //[visiting_card.head_image addGestureRecognizer:act[5]];
    visiting_card.delegate=self;
    [self.view addSubview:visiting_card];
    _card=visiting_card;
    
    float offh=340;
    _table=[[UITableView alloc]initWithFrame:CGRectMake(0, offh, self.view.frame.size.width, self.view.frame.size.height-offh) style:UITableViewStylePlain];
    _table.tableFooterView = [[UIView alloc]init];
    self.table.dataSource=self;
    self.table.delegate=self;
    [self.view addSubview:_table];
    
    float wid=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    float buwid=100;
    UIButton *bu=[[UIButton alloc]initWithFrame:CGRectMake(wid/2-buwid/2, height-150, buwid, 50)];
    [self.view addSubview:bu];
    bu.layer.cornerRadius=5;
    [bu setBackgroundColor:[UIColor redColor]];
    [bu setTitle:@"退出登录" forState:UIControlStateNormal];
    [bu addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchDown];
    
    [self loadData];
}

-(void)loadData{
    AVUser *user=[AVUser currentUser];
    //NSLog(@"name %@", user.username);
    _Username = user.username;
    _Sex = user[@"sex"];
    _Birthday = user[@"birthday"];
    _Address = user[@"address"];
    _qianming=user[@"qianming"];
    [self.table reloadData];
}

-(void)chooseWindow{
    NSLog(@"openchoose");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"action Default did clicked");
        //为了防止循环引用，在这里需要进行弱引用设置，下面如果有用到alertController的也需要做相同的处理
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;            //协议
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    [alertController addAction:actionDefault];
    
    UIAlertAction *actionPho = [UIAlertAction actionWithTitle:@"照相" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"action Default did clicked");
        //为了防止循环引用，在这里需要进行弱引用设置，下面如果有用到alertController的也需要做相同的处理
        ZLOnePhoto *one = [ZLOnePhoto shareInstance];
        [one presentPicker:PickerType_Camera photoCut:PhotoCutType_YES target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
            if(!isCancel){
                self->_card.head_image.image=image;
            } else {
                NSLog(@"cancel");
            }
        }];
    }];
    [alertController addAction:actionPho];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"action cancel did clicked");
    }];
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

-(void)logOut{
    LoginViewController *login=[[LoginViewController alloc]init];
    //[self.navigationController popoverPresentationController];
    [AVUser logOut];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return _array.count;
    //return 0;
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InfoCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    //if(cell==NULL){
        cell=[[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        //[cell loaddata:indexPath.row];
        cell.delegate=self;
    NSArray *a = [[NSArray alloc] initWithObjects:@"用户名",@"性别",@"生日",@"地址",@"个性签名",nil];
        cell.attribute.text = a[indexPath.row];
        cell.button.userInteractionEnabled = YES;
        //UITapGestureRecognizer *act = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downAnimation)];
        //cell.tag = indexPath.row;
        cell.delegate=self;
        switch (indexPath.row) {
            case 0:
                cell.value.text = _Username;
                break;
            case 1:
                cell.value.text = _Sex;
                break;
            case 2:
                cell.value.text = _Birthday;
                break;
            case 3:
                cell.value.text = _Address;
                break;
            case 4:
                cell.value.text=_qianming;
            default:
                break;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //}
    return cell;
}

-(void)settingEvent:(NSString *)which{
    NSLog(@"%@",which);
    Setting *setpage=[[Setting alloc]init];
    setpage.type=which;
    //UINavigationController *nav=[[UINavigationController alloc]init];
    //UIApplication.shared.keyWindow?: .rootViewController = nav;
    //UIApplication.sharedApplication.keyWindow.rootViewController=nav;
    
    //self.tabBarController.removeFromParentViewController;
    
    [self.navigationController pushViewController:setpage animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];//获取到所选择的照片
    _card.head_image.image = img;
    UIImage *compressImg = [self imageWithImageSimple:img scaledToSize:CGSizeMake(60, 60)];//对选取的图片进行大小上的压缩
    AVUser *user=[AVUser currentUser];
    UIImage *headimg=compressImg;
    NSData *headdata=UIImageJPEGRepresentation(headimg, 1.0);
    AVFile *file=[AVFile fileWithData:headdata name:@"headimg"];
    NSMutableArray *arr=user[@"headImg"];
    [arr removeAllObjects];
    [arr addObject:file];
    [user setObject:arr forKey:@"headImg"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            LKRightBubble(@"上传头像成功", 2);
        }
    }];
    //[self transportImgToServerWithImg:compressImg]; //将裁剪后的图片上传至服务器
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//用户取消选取时调用,可以用来做一些事情
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
