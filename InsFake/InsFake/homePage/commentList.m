//
//  commentList.m
//  InsFake
//
//  Created by z on 2019/12/27.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "commentList.h"

@interface commentList()

@end

@implementation commentList

-(commentList*)setUsername:(NSString *)name comment:(NSString *)com{
    _username=name;
    _comment=com;
    return self;
}

-(commentList*)setUsername:(NSString*)name comment:(NSString*)com headImg:(UIImage*)img{
    _username=name;
    _comment=com;
    _headImg=img;
    return self;
}

@end
