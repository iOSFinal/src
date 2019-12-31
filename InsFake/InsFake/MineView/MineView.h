//
//  MineView.h
//  InsFake
//
//  Created by big-R on 2019/12/22.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineView : NSObject

@property (nonatomic,strong)UIView* visiting_card;
@property (nonatomic,strong)UIView* infomation_card;
@property (nonatomic,strong)UIView* setting_view;

- (BOOL)set_username;
- (BOOL)set_sex;
- (BOOL)set_birtyday;
- (BOOL)set_address;
- (BOOL)set_head_image;
- (BOOL)set_motto;

@end

NS_ASSUME_NONNULL_END
