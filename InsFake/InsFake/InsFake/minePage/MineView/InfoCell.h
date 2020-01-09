//
//  InfoCell.h
//  InsFake
//
//  Created by big-R on 2019/12/21.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol clickEventPro <NSObject>

-(void)settingEvent:(NSString*_Nullable)which;

@end

NS_ASSUME_NONNULL_BEGIN

@interface InfoCell : UITableViewCell

@property(nullable,weak,nonatomic)id<clickEventPro> delegate;

@property(nonatomic, retain)UILabel *attribute;
@property(nonatomic, retain)UILabel *value;
@property(nonatomic, retain)UILabel *button;

@end

NS_ASSUME_NONNULL_END
