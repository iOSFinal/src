//
//  commentList.h
//  InsFake
//
//  Created by z on 2019/12/27.
//  Copyright © 2019 lelouch. All rights reserved.
//

#ifndef commentList_h
#define commentList_h
#import <UIKit/UIKit.h>

@interface commentList : NSObject

@property(nonatomic,strong)NSString* username, *comment;
@property(nonatomic,strong)UIImage* headImg;

-(commentList*)setUsername:(NSString*)name comment:(NSString*)com;
-(commentList*)setUsername:(NSString*)name comment:(NSString*)com headImg:(UIImage*)img;

@end

#endif /* commentList_h */
