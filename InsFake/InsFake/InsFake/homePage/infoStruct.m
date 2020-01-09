//
//  infoStruct.m
//  InsFake
//
//  Created by z on 2019/12/31.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "infoStruct.h"

@interface infoStruct()

@end

@implementation infoStruct

-(void)setdata:(UIImage *)img username:(NSString *)username info:(NSMutableArray *)info comments:(NSMutableArray *)arry{
    _headImg=img;
    _infoArray=info;
    _username=username;
    _commentArray=arry;
}

@end
