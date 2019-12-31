//
//  MineViewController.h
//  InsFake
//
//  Created by lelouch on 2019/12/20.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineView/InfoCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface MineViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView* tableView;
    NSString* Username;
    NSString* Motto;
    NSString* Sex;
    NSString* Address;
    NSString* Birthday;
    UIImage* HeadImage;
    NSArray *Infomation;
}

@end

NS_ASSUME_NONNULL_END
