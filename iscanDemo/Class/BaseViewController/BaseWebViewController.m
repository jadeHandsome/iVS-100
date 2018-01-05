//
//  BaseWebViewController.m
//  WisdomRiver
//
//  Created by 曾洪磊 on 2017/12/18.
//  Copyright © 2017年 曾洪磊. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
    }];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    self.webView.delegate = self;
    self.navigationItem.title = @"加载中...";
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadingHUD];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHUD];
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
