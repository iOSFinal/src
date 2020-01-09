
//
//  PublicationViewController.m
//  InsFake
//
//  Created by lelouch on 2019/12/20.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import "PublicationViewController.h"
#import "ZLDefine.h"
#import <AVOSCloud/AVOSCloud.h>
//#import <MBProgressHUD.h>
#import <LemonBubble.h>
#import "homePage/HomePageViewController.h"

#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height

@interface PublicationViewController ()
// 相册单选
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
// 相册单选带裁剪
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Cut;
@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;

@property(nonatomic,strong) NSArray<UIImage *>* pics;
@property(nonatomic,strong) UIButton *bu;
@property(nonatomic,strong) NSMutableArray* imgs;

@end

@implementation PublicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imgs=[[NSMutableArray alloc]init];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    UIImage* head=[UIImage imageNamed:@"loading.gif"];
    UIImageView* imgView=[[UIImageView alloc]initWithFrame:CGRectMake(12+20, 10+20, 55, 55)];
    imgView.image=head;
    
    AVQuery *query=[AVQuery queryWithClassName:@"_User"];
    AVUser *user=[AVUser currentUser];
    [query whereKey:@"objectId" equalTo:user.objectId];
    AVObject *obj=[query getFirstObject];
    NSString *name=obj[@"username"];
    //获取头像
    AVQuery *query2=[AVQuery queryWithClassName:@"_User"];
    [query2 whereKey:@"objectId" equalTo:user.objectId];
    [query2 includeKey:@"headImg"];
    NSArray *a=[query2 findObjects];
    //NSLog(@"%lu", (unsigned long)a.count);
    AVObject *avobj=a[0];
    AVFile *file=avobj[@"headImg"][0];
    [file downloadWithProgress:^(NSInteger number) {
        // 下载的进度数据，number 介于 0 和 100
        //NSLog(@"%ld", (long)number);
    } completionHandler:^(NSURL * _Nullable filePath, NSError * _Nullable error) {
        // filePath 是文件下载到本地的地址
        NSString* urlStr = [filePath absoluteString];
        NSString* cutpath=[urlStr substringWithRange:NSMakeRange(7, urlStr.length-7)];
        //NSLog(@"%@", cutpath);
        UIImage *i=[[UIImage alloc] initWithContentsOfFile:cutpath];
        imgView.image=i;
    }];
    
    //UIImageView* imgView=[[UIImageView alloc]initWithImage:head];
    imgView.layer.masksToBounds=YES;
    imgView.layer.cornerRadius=imgView.frame.size.width/2;
    imgView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgView];
    
    UILabel* userName=[[UILabel alloc]initWithFrame:CGRectMake(70+2*20, 10+25, 150, 35)];
    userName.text=name;
    userName.textColor=[UIColor blackColor];
    [self.view addSubview:userName];
    
    //_imageView=[[UIImageView alloc]initWithFrame:CGRectMake(6, 80, 160, 160)];
    //[self.view addSubview:_imageView];
    
    UIButton* selectBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 110, 100, 100)];
    [selectBtn setImage:[UIImage imageNamed:@"addpic.png"] forState:UIControlStateNormal];
    //[selectBtn setTitle:@"相册单选" forState:UIControlStateNormal];
    //selectBtn.backgroundColor=[UIColor colorWithRed:22.0/255.0 green:155.0/255.0 blue:213.0/255.0 alpha:1];
    //[selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //selectBtn.titleLabel.font=[UIFont systemFontOfSize:20.0];
    //selectBtn.layer.cornerRadius=5;
    [selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.tag=5;
    [self.view addSubview:selectBtn];
    _bu=selectBtn;
    [self setButtonPo:0];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"发布";
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(deletePublishButtonAction:)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(finishPublishButtonAction:)];
    
    //for (UIView *view in [self.view subviews]) {
    //    [view removeFromSuperview];
    //}
    //[self viewDidLoad];
}

-(void)deletePublishButtonAction:(UIButton*)bu{
    for(int i=0;i<_imgs.count;i++){
        UIImageView *v=_imgs[i];
        [v removeFromSuperview];
    }
    [_imgs removeAllObjects];
    [self setButtonPo:0];
    self.tabBarController.selectedIndex=0;
}

-(void)finishPublishButtonAction:(UIButton*)bu{
    //NSMutableArray *arr=[[NSMutableArray alloc]init];
    //[arr addObject:self->_imageView.image];
    if(_imgs.count==0){
        //内容为空
        LKErrorBubble(@"内容不能为空", 2);
        //[self showwindow:@"内容不能为空"];
    } else {
        AVUser *user=[AVUser currentUser];
        [self uploadDataByUserId:user.objectId pics:_pics];
        for(int i=0;i<_imgs.count;i++){
            UIImageView *v=_imgs[i];
            [v removeFromSuperview];
        }
        [_imgs removeAllObjects];
        [self setButtonPo:0];

        LKRightBubble(@"发表成功", 2);
        int64_t delayInSeconds = 2.0;      // 延迟的时间
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // do something
            
            UINavigationController *nav=[self.tabBarController.viewControllers objectAtIndex:0];
            HomePageViewController *home=[nav.viewControllers objectAtIndex:0];
            //controllers[0]=home;
            [home refreshData];
            home.test=10;
            //NSLog(@"%lu", (unsigned long)nav.viewControllers.count);
            self.tabBarController.selectedIndex=0;
        });
        
    }
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
    //NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    //[dic setObject:@"5e0d7537dd3c13006a551c05" forKey:@"userId"];
    //[dic setObject:@"so beautiful" forKey:@"comment"];
    //[com addObject:dic];
    [obj setObject:com forKey:@"comments"];//初始化评论
    NSMutableArray *likeuser=[[NSMutableArray alloc]init];
    [obj setObject:likeuser forKey:@"likeUsers"];//添加喜欢的列表
    [obj saveInBackground];
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
            actionSheet.maxSelectCount = 8;
            [actionSheet showPhotoLibraryWithSender:self lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
                NSLog(@"%@", selectPhotos);//
                for(int i=0;i<selectPhotos.count;i++){
                    [self addImageByOrder:i img:selectPhotos[i]];
                }
                [self setButtonPo:selectPhotos.count];
                self->_pics=selectPhotos;
            }];}
            break;
        default:
            break;
    }
}

-(void)setButtonPo:(int)order{
    float x,y;
    float wid=self.view.frame.size.width;
    float left=wid/2-150-25;
    x=(order%3)*125+left;
    y=(order/3)*125+110;
    [_bu setFrame:CGRectMake(x, y, 100, 100)];
}

-(void)addImageByOrder:(int)order img:(UIImage*)img{
    float x,y;
    float wid=self.view.frame.size.width;
    float left=wid/2-150-25;
    x=(order%3)*125+left;
    y=(order/3)*125+110;
    UIImageView *imgview=[[UIImageView alloc]initWithFrame:CGRectMake(x, y, 100, 100)];
    imgview.image=img;
    [self.view addSubview:imgview];
    [_imgs addObject:imgview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//改变图片大小
- (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}


@end
