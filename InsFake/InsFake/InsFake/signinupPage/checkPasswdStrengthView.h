//
//  checkPasswdStrengthView.h
//  InsFake
//
//  Created by z on 2019/12/24.
//  Copyright © 2019 lelouch. All rights reserved.
//

#ifndef checkPasswdStrengthView_h
#define checkPasswdStrengthView_h
#import <UIKit/UIKit.h>

@interface checkPasswdStrengthView : UIView

@property(nonatomic,strong)UIView *r,*y,*g;
@property(nonatomic,strong)UILabel *content;

-(void)set_view;
-(void)changeShow:(NSString*)passwd;
-(void)initShow;

@end

#endif /* checkPasswdStrengthView_h */
