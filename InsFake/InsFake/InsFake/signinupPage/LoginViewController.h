//
//  LoginViewController.h
//  InsFake
//
//  Created by lelouch on 2019/12/20.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
NS_ASSUME_NONNULL_BEGIN


@interface LoginViewController : UIViewController

@property(strong,nonatomic)UITextField *username,*passwd;
@property(strong,nonatomic)NSString *username_sign,*passwd_sign;
@property(nonatomic) BOOL isset;

@property(nonatomic,strong)UIImageView *testimg;

-(void)setname:(NSString*)n passwd:(NSString*)m;

@end

NS_ASSUME_NONNULL_END
