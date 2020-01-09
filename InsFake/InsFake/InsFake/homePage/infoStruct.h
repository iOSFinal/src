//
//  infoStruct.h
//  InsFake
//
//  Created by z on 2019/12/31.
//  Copyright © 2019 lelouch. All rights reserved.
//

#ifndef infoStruct_h
#define infoStruct_h
#import <UIKit/UIKit.h>

@interface infoStruct : NSObject

@property(nonatomic,strong)UIImage *headImg;
@property(nonatomic,strong)NSString* username;
@property(nonatomic,strong)NSMutableArray *commentArray,*infoArray;

-(void)setdata:(UIImage*)img username:(NSString*)username info:(NSMutableArray*)info comments:(NSMutableArray*)arry;

@end

#endif /* infoStruct_h */
