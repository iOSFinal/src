//
//  commentCell.h
//  InsFake
//
//  Created by z on 2019/12/31.
//  Copyright © 2019 lelouch. All rights reserved.
//

#ifndef commentCell_h
#define commentCell_h
#import <UIKit/UIKit.h>

@interface commentCell : UITableViewCell

-(void)set_data:(UIImage*)headImg username:(NSString*)username info:(NSString*)info;
-(unsigned long int)getHeight;

@end

#endif /* commentCell_h */
