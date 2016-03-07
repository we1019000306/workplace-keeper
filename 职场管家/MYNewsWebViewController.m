//
//  MYNewsWebViewController.m
//  职场管家
//
//  Created by Jackie Liu on 16/2/9.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "MYNewsWebViewController.h"
@interface MYNewsWebViewController()
@property(nonatomic, strong) UIWebView *newsWebView;
@end

@implementation MYNewsWebViewController
-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)loadWebViewWithURL:(NSURL *)url{
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [self.newsWebView loadRequest:request];
}

-(UIWebView *)newsWebView{
    if (!_newsWebView) {
        _newsWebView = [[UIWebView alloc]init];
        [self.view addSubview:_newsWebView];
        [_newsWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    return _newsWebView;
}
@end
