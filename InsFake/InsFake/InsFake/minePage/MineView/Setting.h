//
//  Setting.h
//  InsFake
//
//  Created by big-R on 2019/12/22.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Setting : UIViewController

@property(nonatomic, retain)UILabel* back;
@property(nonatomic, retain)UIButton* save;
@property(nonatomic,strong)NSString* type;
@property(nonatomic,strong)UITextField *input;
@property(nonatomic,strong)UITextView *qianming;

@end

NS_ASSUME_NONNULL_END
