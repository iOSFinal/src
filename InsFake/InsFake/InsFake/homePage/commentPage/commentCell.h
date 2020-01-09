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

@protocol commentCellClick_event<NSObject>

-(void)deleteComment:(int)order;

@end

@interface commentCell : UITableViewCell

@property(nullable,weak,nonatomic)id<commentCellClick_event> delegate;

-(void)set_data:(UIImage*_Nullable)headImg username:(NSString*_Nullable)username info:(NSString*_Nullable)info;
-(unsigned long int)getHeight;
-(void)loadData:(int)order feedId:(NSString*_Nullable)feedId;


@end

#endif /* commentCell_h */
