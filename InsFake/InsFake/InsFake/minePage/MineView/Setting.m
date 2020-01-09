//
//  Setting.m
//  InsFake
//
//  Created by big-R on 2019/12/22.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import "Setting.h"
#import <LemonBubble.h>
#import <AVOSCloud/AVOSCloud.h>
#import <WSDatePickerView.h>

@interface Setting()

@property(nonatomic,strong)NSMutableArray *buArr;

@property(nonatomic,strong)NSString* birthday;
@property(nonatomic,strong)UILabel *birthLab;
@property(nonatomic,strong)UITextField *oldpass,*newpass,*appeadpass;

@end

@implementation Setting

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title=_type;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1];
    
    _back = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 50, 50)];
    _back.text = @"<";
    _back.font = [UIFont boldSystemFontOfSize:20];
    
    _save = [[UIButton alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-120, 130, 90, 40)];
    [_save setTitle:@"完成" forState:UIControlStateNormal];
    _save.titleLabel.textColor = [UIColor whiteColor];
    _save.backgroundColor = [UIColor colorWithRed:0.086 green:0.608 blue:0.835 alpha:1];
    _save.layer.masksToBounds = YES;
    _save.layer.cornerRadius = 5;
    [_save addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchDown];
    
    //[self.view addSubview:_back];
    //[self.view addSubview:_save];
    
    [self inputViewBytype];
    [self initData];
}

-(void)initData{
    AVUser *user=[AVUser currentUser];
    if([_type isEqualToString:@"用户名"]){
        _input.text=user.username;
    } else if([_type isEqualToString:@"地址"]){
        _input.text=user[@"address"];
    } else if([_type isEqualToString:@"个性签名"]){
        _qianming.text=user[@"qianming"];
    } else if([_type isEqualToString:@"生日"]){
        _birthday=user[@"birthday"];
        _birthLab.text=_birthday;
        [self chooseDate];
    } else if([_type isEqualToString:@"性别"]){
        NSString *sex=user[@"sex"];
        if([sex isEqualToString:@"男"]){
            [self stateToYes:_buArr[0]];
        } else if([sex isEqualToString:@"女"]){
            [self stateToYes:_buArr[1]];
        } else {
            [self stateToYes:_buArr[2]];
        }
    }
}

//初始化页面显示
-(void)inputViewBytype{
    if([_type isEqualToString:@"用户名"]||[_type isEqualToString:@"地址"]){
        _input=[[UITextField alloc]initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-20*2, 50)];
        _input.placeholder=@"输入更改内容";
        _input.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_input];
    } else if([_type isEqualToString:@"性别"]){
        float wid=self.view.frame.size.width;
        float buwid=50;
        float off=80;
        _buArr=[[NSMutableArray alloc]init];
        [self addBu:@"man.png" tag:1 x:wid/2-1.5*buwid-off];
        [self addBu:@"woman.png" tag:2 x:wid/2-0.5*buwid];
        [self addBu:@"unknown.png" tag:3 x:wid/2+off+0.5*buwid];
        //[self stateToYes:_buArr[0]];
    } else if([_type isEqualToString:@"生日"]){
        //[self chooseDate:_birthday];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 100, 100, 50)];
        label.text=@"     生日";
        label.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:label];
        UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(120, 100, self.view.frame.size.width-20*2-100, 50)];
        _birthLab=lab2;
        lab2.backgroundColor=[UIColor whiteColor];
        UITapGestureRecognizer *clik=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDate)];
        [lab2 addGestureRecognizer:clik];
        lab2.userInteractionEnabled=YES;
        [self.view addSubview:lab2];
    } else if([_type isEqualToString:@"个性签名"]){
        UITextView *textview=[[UITextView alloc]initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-20*2, 150)];
        textview.keyboardType=UIKeyboardTypeEmailAddress;
        [self.view addSubview:textview];
        [textview setFont:[UIFont fontWithName:@"Arial" size:18]];
        _qianming=textview;
    } else if([_type isEqualToString:@"更改密码"]){
        _oldpass=[self addText:@"     原密码" place:@"请输入原密码" po:100];
        _newpass=[self addText:@"     新密码" place:@"请输入新密码" po:180];
        _appeadpass=[self addText:@"    重复密码" place:@"重复新密码" po:260];
    }
}

-(UITextField*)addText:(NSString*)title place:(NSString*)place po:(float)h{
    UILabel *oldpasswd=[[UILabel alloc]initWithFrame:CGRectMake(20, h, 100, 50)];
    oldpasswd.text=title;
    [self.view addSubview:oldpasswd];
    UITextField *old=[[UITextField alloc]initWithFrame:CGRectMake(120, h, self.view.frame.size.width-20*2-100, 50)];
    old.backgroundColor=[UIColor whiteColor];
    old.placeholder=place;
    old.clearsOnBeginEditing=NO;
    [self.view addSubview:old];
    old.keyboardType = UIKeyboardTypeASCIICapable;
    old.secureTextEntry=YES;//密文
    old.clearButtonMode = UITextFieldViewModeAlways;//删除清空按钮
    old.autocorrectionType = UITextAutocorrectionTypeNo;//不自动纠错
    return old;
}

-(void)chooseDate{
    //NSLog(@"%@", date1);
    NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
    [minDateFormater setDateFormat:@"yyyy年MM月dd日"];
    NSDate *scrollToDate = [minDateFormater dateFromString:_birthday];
    WSDatePickerView *dateview=[[WSDatePickerView alloc]initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *select) {
        NSString *date = [select stringWithFormat:@"yyyy年MM月dd日"];
        NSLog(@"选择的月日时分：%@",date);
        self->_birthday=date;
        self->_birthLab.text=self->_birthday;
    }];
    [dateview show];
}

-(void)addBu:(NSString*)imgName tag:(int)tag x:(float)x{
    UIButton *bu1=[[UIButton alloc]initWithFrame:CGRectMake(x, 230, 50, 50)];
    [bu1 setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    bu1.layer.cornerRadius=25;
    [self.view addSubview:bu1];
    bu1.adjustsImageWhenHighlighted=NO;
    bu1.tag=tag;
    [bu1 addTarget:self action:@selector(clickbu:) forControlEvents:UIControlEventTouchDown];
    [_buArr addObject:bu1];
}

-(void)clickbu:(UIButton*)bu{
    if(bu.tag<10){
        [self stateToYes:bu];
        for(int i=0;i<_buArr.count;i++){
            UIButton *temp=_buArr[i];
            if(temp.tag!=bu.tag&&temp.tag>10){
                [self stateToNo:temp];
            }
        }
    }
}

-(void)stateToNo:(UIButton*)bu{
    //CGRect size=bu.frame;
    [UIView animateWithDuration:0.25 animations:^{
        if(bu.tag==11){
            [bu setImage:[UIImage imageNamed:@"man.png"] forState:UIControlStateNormal];
        } else if(bu.tag==12){
            [bu setImage:[UIImage imageNamed:@"woman.png"] forState:UIControlStateNormal];
        } else if(bu.tag==13){
            [bu setImage:[UIImage imageNamed:@"unknown.png"] forState:UIControlStateNormal];
        }
        bu.tag-=10;
    } completion:^(BOOL finished) {
    }];
}

-(void)stateToYes:(UIButton*)bu{
    CGRect size=bu.frame;
    [UIView animateWithDuration:0.25 animations:^{
        bu.frame=CGRectMake(bu.frame.origin.x-5, bu.frame.origin.y-5, bu.frame.size.width+10, bu.frame.size.height+10);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            bu.frame=size;
            if(bu.tag==1){
                [bu setImage:[UIImage imageNamed:@"manChoose.png"] forState:UIControlStateNormal];
            } else if(bu.tag==2){
                [bu setImage:[UIImage imageNamed:@"womanChoose.png"] forState:UIControlStateNormal];
            } else {
                [bu setImage:[UIImage imageNamed:@"unknownChoose.png"] forState:UIControlStateNormal];
            }
            bu.tag+=10;
        }];
    }];
}

-(void)saveClick{
    if([_type isEqualToString:@"用户名"]||[_type isEqualToString:@"地址"]){
        [self changeUsernameAddress];
    } else if([_type isEqualToString:@"性别"]){
        [self changeSex];
    } else if([_type isEqualToString:@"个性签名"]){
        [self changeQianming];
    } else if([_type isEqualToString:@"生日"]){
        [self changeBirthday];
    } else if([_type isEqualToString:@"更改密码"]){
        [self changePasswd];
    }
}

-(void)changePasswd{
    AVUser *user=[AVUser currentUser];
    NSString *pas=user[@"password"];
    NSLog(@"%@", pas);
    [AVUser resetPasswordWithSmsCode:user.username newPassword:@"123" block:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"success");
        } else {
            NSLog(@"fail");
        }
    }];
}

-(void)changeBirthday{
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:date];
    NSComparisonResult re=[_birthday compare:dateStr];
    if(re==1){
        LKErrorBubble(@"生日必须比当前日期小", 2);
    } else {
        AVUser *user=[AVUser currentUser];
        [user setObject:_birthday forKey:@"birthday"];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                LKRightBubble(@"修改成功", 2);
                [self backPage];
            } else {
                LKErrorBubble(@"error", 2);
            }
        }];
    }
}

-(void)changeQianming{
    if(_qianming.text.length==0){
        LKErrorBubble(@"请输入内容", 2);
    } else {
        AVUser *user=[AVUser currentUser];
        [user setObject:_qianming.text forKey:@"qianming"];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                LKRightBubble(@"修改成功", 2);
                [self backPage];
            } else {
                //NSLog(@"error");
                LKErrorBubble(@"error", 2);
            }
        }];
    }
}

-(void)changeSex{
    int choose=0;
    for(int i=0;i<3;i++){
        UIButton *bu=_buArr[i];
        if(bu.tag>10){
            choose=bu.tag-10;
            break;
        }
    }
    //NSLog(@"%d", choose);
    AVUser *user=[AVUser currentUser];
    switch (choose) {
        case 1:
            [user setObject:@"男" forKey:@"sex"];
            break;
        case 2:
            [user setObject:@"女" forKey:@"sex"];
            break;
        case 3:
            [user setObject:@"不明" forKey:@"sex"];
            break;
        default:
            break;
    }
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            LKRightBubble(@"更改成功", 2);
            [self backPage];
        } else {
            LKErrorBubble(@"error", 2);
        }
    }];
}

-(void)changeUsernameAddress{
    if(_input.text.length==0){
        LKErrorBubble(@"请输入内容", 2);
    } else {
        if([_type isEqualToString:@"用户名"]){
            AVUser *user=[AVUser currentUser];
            [user setObject:_input.text forKey:@"username"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    LKRightBubble(@"修改成功", 2);
                    [self backPage];
                } else {
                    NSLog(@"error");
                    if(error.code==202){
                        LKErrorBubble(@"此用户名已被占用", 2);
                    } else {
                        LKErrorBubble(@"error", 2);
                    }
                }
            }];
        } else if([_type isEqualToString:@"地址"]){
            AVUser *user=[AVUser currentUser];
            [user setObject:_input.text forKey:@"address"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    LKRightBubble(@"修改成功", 2);
                    [self backPage];
                } else {
                    //NSLog(@"error");
                    LKErrorBubble(@"error", 2);
                }
            }];
        }
    }
}

-(void)backPage{
    int64_t delayInSeconds = 2.0;      // 延迟的时间
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // do something
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
