//
//  TabBarViewController.m
//  InsFake
//
//  Created by lelouch on 2019/12/20.
//  Copyright © 2019 lelouch. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomePageViewController.h"
#import "PublicationViewController.h"
#import "MineViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HomePageViewController* hvc=[[HomePageViewController alloc]init];
    UINavigationController* hnav=[[UINavigationController alloc]initWithRootViewController:hvc];
     
    hnav.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@"homepage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"homepageSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    hnav.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);
    
    PublicationViewController* pvc=[[PublicationViewController alloc]init];
    UINavigationController* pnav=[[UINavigationController alloc]initWithRootViewController:pvc];
    pnav.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"addSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    pnav.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);
     
    MineViewController* mvc=[[MineViewController alloc]init];
    UINavigationController* mnav=[[UINavigationController alloc]initWithRootViewController:mvc];
    mnav.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@"user"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"userSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    mnav.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);
     
    self.viewControllers=@[hnav,pnav,mnav];
    //[self.tabBar setTintColor:[UIColor orangeColor]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
