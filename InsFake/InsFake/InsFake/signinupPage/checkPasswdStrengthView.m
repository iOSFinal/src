//
//  checkPasswdStrengthView.m
//  InsFake
//
//  Created by z on 2019/12/24.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "checkPasswdStrengthView.h"

#define interval 30

@interface checkPasswdStrengthView()

@end

@implementation checkPasswdStrengthView

-(void)set_view{
    UIView *r=[[UIView alloc]initWithFrame:CGRectMake(50, 10, 10, 10)];
    r.backgroundColor=[UIColor grayColor];
    r.layer.cornerRadius=5;
    r.layer.masksToBounds=YES;
    [self addSubview:r];
    _r=r;
    
    UIView *y=[[UIView alloc]initWithFrame:CGRectMake(50+interval, 10, 10, 10)];
    y.backgroundColor=[UIColor grayColor];
    y.layer.cornerRadius=5;
    y.layer.masksToBounds=YES;
    [self addSubview:y];
    _y=y;
    
    UIView *g=[[UIView alloc]initWithFrame:CGRectMake(50+2*interval, 10, 10, 10)];
    g.backgroundColor=[UIColor grayColor];
    g.layer.cornerRadius=5;
    g.layer.masksToBounds=YES;
    [self addSubview:g];
    _g=g;
    
    UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(50+3*interval, 10, 200, 10)];
    //text.text=@"强密码";
    [text setFont:[UIFont fontWithName:@"Arial" size:14.0]];
    [self addSubview:text];
    _content=text;
    
    [self initShow];
}

-(void)initShow{
    _r.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1];
    _y.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1];
    _g.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1];
    _content.text=@"";
}

-(void)changeShow:(NSString *)passwd{
    [self initShow];
    switch ([self judgePasswordStrength:passwd]) {
        case 1:
            _r.backgroundColor=[UIColor redColor];
            _content.text=@"密码强度低，建议修改";
            _content.textColor=[UIColor redColor];
            break;
        case 2:
            _y.backgroundColor=[UIColor blueColor];
            _content.text=@"密码强度一般";
            _content.textColor=[UIColor blueColor];
            break;
        case 3:
            _g.backgroundColor=[UIColor greenColor];
            _content.text=@"密码强度高";
            _content.textColor=[UIColor greenColor];
            break;
        default:
            break;
    }
}

-(BOOL)judgeRange:(NSArray*) _termArray Password:(NSString*) _password
{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}

-(int)judgePasswordStrength:(NSString*) _password
{
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];
    
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];
    
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:_password]];
    
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:_password]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    
    int intResult=0;
    
    for (int j=0; j<[resultArray count]; j++)
    {
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
            
        {
            intResult++;
        }
    }
    
    NSString* resultString = [[NSString alloc] init];
    
    int f=0;
    if (intResult <2)
    {
        resultString = @"密码强度低，建议修改";
        f=1;
    }
    
    else if (intResult == 2&&[_password length]>=6)
    {
        resultString = @"密码强度一般";
        f=2;
    }
    
    if (intResult > 2&&[_password length]>=6)
    {
        resultString = @"密码强度高";
        f=3;
    }
    //return resultString;
    return f;
}


@end
