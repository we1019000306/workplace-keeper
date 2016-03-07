//
//  YKButtonNavigationController.m
//  58School
//
//  Created by YoKing on 15/9/10.
//  Copyright (c) 2015年 YunKu. All rights reserved.
//  拦截所有push进来的控制器 改变左右按钮
#define YKTabBarItemTitileColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#import "MYButtonNavigationController.h"
#import "UIBarButtonItem+Extension.h"
@interface MYButtonNavigationController ()

@end

@implementation MYButtonNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:YKTabBarItemTitileColor(76, 162, 247)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"left32" highImage:@"left32"];
        
        // 设置右边的更多按钮
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"item_ask" highImage:@"item_ask"];
        
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];

}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

@end
