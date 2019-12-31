//
//  signupController.m
//  os_final
//
//  Created by z on 2019/12/21.
//  Copyright © 2019 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "signupController.h"
//#import "signinController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "checkPasswdStrengthView.h"

@interface signupViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)checkPasswdStrengthView *strengthView;

@end

@implementation signupViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _baseView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_baseView];
    [self.baseView setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self load_view];
}

-(void)load_view{
    float screen_wid=self.view.frame.size.width;
    //float screen_height=self.view.frame.size.height;
    float lab_height=60;
    float input_wid=screen_wid-100;
    float signin_button_wid=200;
    UIColor *blue=[UIColor colorWithRed:22.0/255.0 green:155.0/255.0 blue:213.0/255.0 alpha:1];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 180, screen_wid, lab_height)];
    //[lab setText:@"Social APP"];//设置标签内容
    [lab setTextAlignment:NSTextAlignmentCenter];//设置标签居中
    //lab.font=[UIFont boldSystemFontOfSize:20];
    
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:@"用户注册"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:30.0] range:NSMakeRange(0, 4)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:40] range:NSMakeRange(0, 4)];
    
    lab.attributedText=str;
    [self.baseView addSubview:lab];
    
    _username=[[UITextField alloc]initWithFrame:CGRectMake(screen_wid/2-input_wid/2, 330, input_wid, lab_height-10)];
    _username.placeholder=@"  用户名";
    _username.backgroundColor=[UIColor whiteColor];
    [self.baseView addSubview:_username];
    _username.delegate=self;
    
    UITextField *passwd=[[UITextField alloc]initWithFrame:CGRectMake(screen_wid/2-input_wid/2, 410, input_wid, lab_height-10)];
    passwd.placeholder=@"  登录密码";
    passwd.backgroundColor=[UIColor whiteColor];
    passwd.secureTextEntry=YES;
    [self.baseView addSubview:passwd];
    _passwd=passwd;
    _passwd.delegate=self;
    
    UITextField *passwd_appead=[[UITextField alloc]initWithFrame:CGRectMake(screen_wid/2-input_wid/2, 490, input_wid, lab_height-10)];
    passwd_appead.placeholder=@"  确认密码";
    passwd_appead.backgroundColor=[UIColor whiteColor];
    passwd_appead.secureTextEntry=YES;
    [self.baseView addSubview:passwd_appead];
    _passwd_appead=passwd_appead;
    _passwd_appead.delegate=self;
    
    
    UILabel *signup_lab=[[UILabel alloc]initWithFrame:CGRectMake(screen_wid/2+80, 550, input_wid/2+50, lab_height/2)];
    NSMutableAttributedString *signup_str=[[NSMutableAttributedString alloc]initWithString:@"返回登录"];
    NSRange range={0,[signup_str length]};
    //[signup_str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [signup_str addAttribute:NSForegroundColorAttributeName value:blue range:range];
    [signup_str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:15.0] range:range];
    signup_lab.attributedText=signup_str;
    
    UITapGestureRecognizer *signup_clik=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signinPage)];
    [signup_lab addGestureRecognizer:signup_clik];
    signup_lab.userInteractionEnabled=YES;
    
    [self.baseView addSubview:signup_lab];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(screen_wid/2+80, 580, input_wid/2-100, 0.5)];
    line.backgroundColor=blue;
    [self.baseView addSubview:line];
    
    UIButton *signin=[[UIButton alloc]initWithFrame:CGRectMake(screen_wid/2-signin_button_wid/2, 610, signin_button_wid, lab_height)];
    [signin setTitle:@"注册" forState:UIControlStateNormal];
    signin.backgroundColor=blue;
    [signin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signin.titleLabel.font=[UIFont systemFontOfSize:20.0];
    signin.layer.cornerRadius=5;
    [signin addTarget:self action:@selector(signupOver) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:signin];
    
    //460
    checkPasswdStrengthView *v=[[checkPasswdStrengthView alloc]initWithFrame:CGRectMake(0, 460, screen_wid, 30)];
    [v set_view];
    [self.baseView addSubview:v];
    _strengthView=v;
    
    //NSLog(@"%f %f",screen_wid,screen_height);
}

-(void)signinPage{
    //跳转至登录页面
    //NSLog(@"click to signin");
    [self.navigationController popViewControllerAnimated:YES];
}

//显示窗口
-(void)showwindow:(NSString*)info{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.baseView animated:YES];
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

//检查输入
-(BOOL)checkinput{
    if(_username.text.length==0){
        [self showwindow:@"用户名不能为空"];
        return false;
    }
    else if(_passwd.text != _passwd_appead.text){
        [self showwindow:@"重复密码错误"];
        return false;
    }
    else if(_passwd.text.length==0){
        [self showwindow:@"密码不能为空"];
        return false;
    }
    return true;
}

//点击注册按钮事件
-(void)signupOver{
    //跳转至登录页面
    //NSLog(@"click to signup Page");
    if([self checkinput]==true){
        AVUser *user = [AVUser user];
        user.username=_username.text;
        user.password=_passwd.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                //[self performSegueWithIdentifier:@"fromSignUpToProducts" sender:nil];
                //跳转至登录页面
                NSMutableArray *controllers=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                LoginViewController *con=[[LoginViewController alloc]init];
                [con setname:self->_username.text passwd:self->_passwd.text];
                controllers[0]=con;
                
                [self.navigationController setViewControllers:controllers];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"注册失败 %@", error);
                [self showwindow:@"用户名已存在"];
            }
        }];
        //此处需要将数据传到后台，检验返回
        //中间等待过程使用hud加载动画
        //注册成功后显示成功
        
        
    }
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

//触摸事件结束
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_username resignFirstResponder];
    [_passwd resignFirstResponder];
    [_passwd_appead resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
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
        self.baseView.center = CGPointMake(self.baseView.center.x, self.baseView.center.y - spaceHeight);
        
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        }];
        
    }else{
        NSLog(@"键盘未挡住输入框");
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //结束编辑
    [self.view endEditing:YES];
    if(_passwd.text.length>0){
        //NSLog(@"%@", [self judgePasswordStrength:_passwd.text]);
        [_strengthView changeShow:_passwd.text];
    } else {
        [_strengthView initShow];
    }
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification *)notification{
    self.baseView.center = self.view.center;
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
