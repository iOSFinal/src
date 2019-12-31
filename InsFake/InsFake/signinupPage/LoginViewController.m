//
//  LoginViewController.m
//  InsFake
//
//  Created by lelouch on 2019/12/20.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "signupController.h"

#import <AFNetworking.h>
#import <AFNetworking/AFNetworking.h>
#import "MBProgressHUD.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //_isset=NO;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self load_view];
    //NSLog(@"get %@", _username_sign);
    [self autosetText];
    
    //_testimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 200, 100, 100)];
    //[self.view addSubview:_testimg];
    //[_testimg setBackgroundColor:[UIColor whiteColor]];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1]];
    
}

-(void)setname:(NSString*)n passwd:(NSString *)m{
    _username_sign=n;
    _passwd_sign=m;
    //_isset=YES;
    //NSLog(@"set ");
    //[self autosetText];
    //NSLog(@"getinfo %@", _username_sign);
}

-(void)autosetText{
    
    //if(_isset==YES){
    //NSLog(@" auto");
    _username.text=_username_sign;
    _passwd.text=_passwd_sign;
}

-(void)load_view{
    float screen_wid=self.view.frame.size.width;
    //float screen_height=self.view.frame.size.height;
    float lab_height=60;
    float input_wid=screen_wid-100;
    float signin_button_wid=200;
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 180, screen_wid, lab_height)];
    //[lab setText:@"Social APP"];//设置标签内容
    [lab setTextAlignment:NSTextAlignmentCenter];//设置标签居中
    //lab.font=[UIFont boldSystemFontOfSize:20];
    
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:@"Social APP"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 10)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:30.0] range:NSMakeRange(0, 10)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:40] range:NSMakeRange(0, 10)];
    
    lab.attributedText=str;
    [self.view addSubview:lab];
    
    UITextField *username=[[UITextField alloc]initWithFrame:CGRectMake(screen_wid/2-input_wid/2, 330, input_wid, lab_height-10)];
    username.placeholder=@"  用户名";
    username.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:username];
    _username=username;
    _username.delegate=self;
    
    UITextField *passwd=[[UITextField alloc]initWithFrame:CGRectMake(screen_wid/2-input_wid/2, 410, input_wid, lab_height-10)];
    passwd.placeholder=@"  登录密码";
    passwd.backgroundColor=[UIColor whiteColor];
    passwd.secureTextEntry=YES;
    [self.view addSubview:passwd];
    _passwd=passwd;
    _passwd.delegate=self;
    
    UIColor *blue=[UIColor colorWithRed:22.0/255.0 green:155.0/255.0 blue:213.0/255.0 alpha:1];
    
    UILabel *signup_lab=[[UILabel alloc]initWithFrame:CGRectMake(screen_wid/2, 470, input_wid/2+50, lab_height/2)];
    NSMutableAttributedString *signup_str=[[NSMutableAttributedString alloc]initWithString:@"没有账号？马上注册"];
    NSRange range={0,[signup_str length]};
    //[signup_str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [signup_str addAttribute:NSForegroundColorAttributeName value:blue range:range];
    [signup_str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:15.0] range:range];
    signup_lab.attributedText=signup_str;
    
    UITapGestureRecognizer *signup_clik=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signupPage)];
    [signup_lab addGestureRecognizer:signup_clik];
    signup_lab.userInteractionEnabled=YES;
    
    [self.view addSubview:signup_lab];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(screen_wid/2, 500, input_wid/2-20, 0.5)];
    line.backgroundColor=blue;
    [self.view addSubview:line];
    
    UIButton *signin=[[UIButton alloc]initWithFrame:CGRectMake(screen_wid/2-signin_button_wid/2, 530, signin_button_wid, lab_height)];
    [signin setTitle:@"登录" forState:UIControlStateNormal];
    signin.backgroundColor=blue;
    [signin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signin.titleLabel.font=[UIFont systemFontOfSize:20.0];
    signin.layer.cornerRadius=5;
    [signin addTarget:self action:@selector(toMainPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signin];
    
    //NSLog(@"%f %f",screen_wid,screen_height);
}

-(void)signupPage{
    //跳转至注册页面
    NSLog(@"click to signup");
    signupViewController *signup=[[signupViewController alloc]init];
    [self.navigationController pushViewController:signup animated:YES];
}

//显示窗口
-(void)showwindow:(NSString*)info{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeCustomView;
    hud.label.text=info;
    
    //hud.labelColor=[UIColor whiteColor];
    hud.minShowTime=2;
    hud.bezelView.backgroundColor=[UIColor grayColor];
    hud.customView=[[UIImageView alloc]initWithImage:[self image:[UIImage imageNamed:@"chahao.png"] byScalingToSize:CGSizeMake(50, 50)]];
    hud.removeFromSuperViewOnHide=YES;
    hud.label.textColor=[UIColor whiteColor];
    [hud hideAnimated:YES];
    //[self.baseView addSubview:hud];
}

//登录按钮点击事件
-(void)toMainPage{
    //跳转至主页
    NSLog(@"click to mainPage");
    
    //[self testTransform];
    [AVUser logInWithUsernameInBackground:_username.text password:_passwd.text block:^(AVUser *user, NSError *error) {
        if (error) {
            NSLog(@"登录失败 %@", error);
            [self showwindow:@"密码错误"];
        } else {
            //[self performSegueWithIdentifier:@"fromLoginToProducts" sender:nil];
            //跳转至主页
            TabBarViewController* vc=[[TabBarViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_username resignFirstResponder];
    [_passwd resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//another
- (IBAction)onClickLogin:(id)sender{
    TabBarViewController* vc=[[TabBarViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
