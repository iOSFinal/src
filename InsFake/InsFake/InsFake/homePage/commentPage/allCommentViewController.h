//
//  allCommentViewController.h
//  InsFake
//
//  Created by z on 2019/12/30.
//  Copyright © 2019 lelouch. All rights reserved.
//

#ifndef allCommentViewController_h
#define allCommentViewController_h
#import <UIKit/UIKit.h>

@interface allCommentViewController : UIViewController

@property(nonatomic,strong)NSString *feedId;
@property(nonatomic)int num;

-(void)setFeedId:(NSString*)feedId;
-(void)setNumCell:(int)n;

@end

#endif /* allCommentViewController_h */
