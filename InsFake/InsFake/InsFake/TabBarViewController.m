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
//#import "MineViewController.h"
#import "homePage/infoStruct.h"
#import "homePage/commentList.h"
#import <AVOSCloud/AVOSCloud.h>
#import "minePage/minePageViewController.h"

#import "SwipeTabBar/UITabBarController+Swipe.h"

@interface TabBarViewController ()<UITabBarControllerDelegate>

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
    self.tabBarController.selectedIndex=0;
    self.delegate=self;
    [self setupSwipeGestureRecognizersAllowCyclingThroughTabs:NO];
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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //获取选中的VC
    NSUInteger shouldSelectIndex = [tabBarController.viewControllers indexOfObject:viewController];
    if (tabBarController.selectedIndex == shouldSelectIndex) {
        return YES;
    }
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;//设置动画类型（可以试着换下看效果）
    
    //判断要选中的VC在已选中的左边还是右边，进行选择或左或右的push效果
    if (tabBarController.selectedIndex > shouldSelectIndex) {
        animation.subtype = kCATransitionFromLeft;
    } else {
        animation.subtype = kCATransitionFromRight;
    }
    // 下面这句可以换成[tabBarController.view.layer addAnimation:animation forKey:@"reveal"];  但是会导致tabBarController的整个标签栏也跟着一起有动画的效果，这样的效果并不是很好。
    [[[tabBarController valueForKey:@"_viewControllerTransitionView"] layer] addAnimation:animation forKey:@"animation"];
    
    return YES;
}

@end
