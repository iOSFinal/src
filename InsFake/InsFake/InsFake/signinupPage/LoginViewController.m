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

#import "../homePage/commentList.h"

//#import <AFNetworking.h>
//#import <AFNetworking/AFNetworking.h>
//#import "MBProgressHUD.h"
#import <LemonBubble.h>

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //_isset=NO;
    
    [self.navigationController setNavigationBarHidden:YES];
    //self.tabBarController.tabBar.hidden=YES;
    
    //NSLog(@"get %@", _username_sign);
    [self autosetText];
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1]];
    
    float wid=self.view.frame.size.width;
    float picwid=300;
    UIImageView *imgv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"signinLogo.png"]];
    [imgv setFrame:CGRectMake(wid/2-picwid/2, 50, picwid, picwid)];
    [self.view addSubview:imgv];
    
    AVUser *user=[AVUser currentUser];
    if(user!=nil){
        TabBarViewController* vc=[[TabBarViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [self load_view];
}

-(void)setname:(NSString*)n passwd:(NSString *)m{
    _username_sign=n;
    _passwd_sign=m;
}

-(void)autosetText{
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
    //[self.view addSubview:lab];
    
    UITextField *username=[[UITextField alloc]initWithFrame:CGRectMake(screen_wid/2-input_wid/2, 330, input_wid, lab_height-10)];
    username.placeholder=@"  用户名";
    username.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:username];
    _username=username;
    _username.delegate=self;
    _username.clearButtonMode = UITextFieldViewModeWhileEditing;
    _username.keyboardType = UIKeyboardTypeDefault;//设置键盘类型
    
    UITextField *passwd=[[UITextField alloc]initWithFrame:CGRectMake(screen_wid/2-input_wid/2, 410, input_wid, lab_height-10)];
    passwd.placeholder=@"  登录密码";
    passwd.backgroundColor=[UIColor whiteColor];
    passwd.secureTextEntry=YES;
    [self.view addSubview:passwd];
    _passwd=passwd;
    _passwd.delegate=self;
    _passwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    
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

//登录按钮点击事件
-(void)toMainPage{
    //跳转至主页
    //NSLog(@"click to mainPage");
    
    //[self testTransform];
    [AVUser logInWithUsernameInBackground:_username.text password:_passwd.text block:^(AVUser *user, NSError *error) {
        if (error) {
            NSLog(@"登录失败 %@", error);
            if(error.code==211){
                //[self showwindow:@"没有该用户"];
                LKErrorBubble(@"没有该用户", 2);
            } else if(error.code==210){
                //[self showwindow:@"密码错误"];
                LKErrorBubble(@"密码错误", 2);
            } else{
                //[self showwindow:@"密码错误次数超出限制，请15z分钟后尝试"];
                LKErrorBubble(@"密码错误次数超出限制，请15分钟后尝试", 4);
            }
        } else {
            LKRightBubble(@"登录成功", 1);
            //[self performSegueWithIdentifier:@"fromLoginToProducts" sender:nil];
            //跳转至主页
            
            int64_t delayInSeconds = 1.0;      // 延迟的时间
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // do something
                TabBarViewController* vc=[[TabBarViewController alloc]init];
                
                [self.navigationController pushViewController:vc animated:YES];
            });
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
