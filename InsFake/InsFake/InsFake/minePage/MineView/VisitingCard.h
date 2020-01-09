//
//  VisitingCard.h
//  InsFake
//
//  Created by big-R on 2019/12/22.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol alertChoose <NSObject>

-(void)chooseWindow;

@end

NS_ASSUME_NONNULL_BEGIN

@interface VisitingCard : UIView

@property(nullable,weak,nonatomic)id<alertChoose> delegate;
@property(nonatomic, retain)UIImageView* head_image;
@property(nonatomic, retain)UILabel* username;
@property(nonatomic, retain)UILabel* motto;


@end

NS_ASSUME_NONNULL_END
