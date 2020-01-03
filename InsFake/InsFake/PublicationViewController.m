//
//  PublicationViewController.m
//  InsFake
//
//  Created by lelouch on 2019/12/20.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import "PublicationViewController.h"
#import "ZLDefine.h"

#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height

@interface PublicationViewController ()
// 相册单选
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
// 相册单选带裁剪
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Cut;
@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;

@end

@implementation PublicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    UIImage* head=[UIImage imageNamed:@"head.jpg"];
    UIImageView* imgView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 35, 35)];
    imgView.image=head;
    //UIImageView* imgView=[[UIImageView alloc]initWithImage:head];
    imgView.layer.masksToBounds=YES;
    imgView.layer.cornerRadius=imgView.frame.size.width/2;
    imgView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgView];
    
    UILabel* userName=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, 150, 35)];
    userName.text=@"卫宫家的饭桶";
    userName.textColor=[UIColor blackColor];
    [self.view addSubview:userName];
    
    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(6, 80, 160, 160)];
    [self.view addSubview:_imageView];
    
    UIButton* selectBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 350, 100, 40)];
    [selectBtn setTitle:@"相册单选" forState:UIControlStateNormal];
    selectBtn.backgroundColor=[UIColor colorWithRed:22.0/255.0 green:155.0/255.0 blue:213.0/255.0 alpha:1];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectBtn.titleLabel.font=[UIFont systemFontOfSize:20.0];
    selectBtn.layer.cornerRadius=5;
    [selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.tag=1;
    [self.view addSubview:selectBtn];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"发布";
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(deletePublishButtonAction:)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(finishPublishButtonAction:)];
}

- (IBAction)btnClick:(UIButton *)sender {
    NSInteger tag = sender.tag;
    switch (tag) {
        case 1:{ // 相册单选  不裁剪
            ZLOnePhoto *one = [ZLOnePhoto shareInstance];
            [one presentPicker:PickerType_Photo photoCut:PhotoCutType_NO target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
                self.imageView.image = image;
            }];}
            break;
        case 2:{ // 相册单选  裁剪
            ZLOnePhoto *one = [ZLOnePhoto shareInstance];
            [one presentPicker:PickerType_Photo photoCut:PhotoCutType_YES target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
                self.imageView_Cut.image = image;
            }];}
            break;
        case 3:{ // 相机  不裁剪
            ZLOnePhoto *one = [ZLOnePhoto shareInstance];
            [one presentPicker:PickerType_Camera photoCut:PhotoCutType_NO target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
                self.imageView.image = image;
            }];}
            break;
        case 4:{ // 相机  裁剪
            ZLOnePhoto *one = [ZLOnePhoto shareInstance];
            [one presentPicker:PickerType_Camera photoCut:PhotoCutType_YES target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
                self.imageView_Cut.image = image;
            }];}
            break;
        case 5:{ // 相册多选
            ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
            //设置照片最大选择数
            actionSheet.maxSelectCount = 5;
            [actionSheet showPhotoLibraryWithSender:self lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
                NSLog(@"%@", selectPhotos);
            }];}
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
