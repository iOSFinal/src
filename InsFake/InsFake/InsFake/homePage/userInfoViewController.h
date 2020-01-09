//
//  userInfoViewController.h
//  InsFake
//
//  Created by z on 2019/12/26.
//  Copyright © 2019 lelouch. All rights reserved.
//

#ifndef userInfoViewController_h
#define userInfoViewController_h
#import <UIKit/UIKit.h>

@interface userInfoViewController : UIViewController

-(void)set_dataByimg:(UIImage*)img username:(NSString*)username sex:(NSString*)sex birthday:(NSString*)birthday address:(NSString*)address qianming:(NSString*)info;
-(void)loadDataById:(NSString*)Id;
@end

#endif /* userInfoViewController_h */
