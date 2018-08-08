//
//  WebTableViewController.m
//  XLTest
//
//  Created by admin on 2018/6/1.
//  Copyright © 2018年 xinle. All rights reserved.
//

#import "WebTableViewController.h"
#import <WebKit/WebKit.h>
#import "UIView+Extension.h"

@interface WebTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *containerScrollView;
@property (nonatomic, strong) UIView    *contentView;

@end

@implementation WebTableViewController{
    CGFloat _lastWebViewContentHeight;
    CGFloat _lastTableViewContentHeight;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initValue];
    [self initView];
    
    NSString *path = @"https://www.jianshu.com/p/3721d736cf68";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [self.webView loadRequest:request];
    [self addObservers];
}


- (void)dealloc{
    [self removeObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initValue{
    _lastWebViewContentHeight = 0;
    _lastTableViewContentHeight = 0;
}

- (void)initView{
    
    //xinle 测试 2018.06.01
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor yellowColor];
    label.text = @"大标题我就是想看看~~~";
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
    CGFloat lblH = 80;
    label.frame = CGRectMake(0, 0, 375, lblH);
    
    [self.contentView addSubview:label];
    [self.contentView addSubview:self.webView];
    [self.contentView addSubview:self.tableView];
    
    [self.view addSubview:self.containerScrollView];
    [self.containerScrollView addSubview:self.contentView];
    
    self.contentView.frame = CGRectMake(0, 0, self.view.width, self.view.height * 2 + lblH);
    self.webView.y = label.bottom;
    self.webView.height = self.view.height;
    self.tableView.y = self.webView.bottom;
}


#pragma mark - Observers
- (void)addObservers{
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers{
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == _webView) {
        if ([keyPath isEqualToString:@"scrollView.contentSize"]) {
            [self updateContainerScrollViewContentSize:0 webViewContentHeight:0];
        }
    }else if(object == _tableView) {
        if ([keyPath isEqualToString:@"contentSize"]) {
            [self updateContainerScrollViewContentSize:0 webViewContentHeight:0];
        }
    }
}


- (void)updateContainerScrollViewContentSize:(NSInteger)flag webViewContentHeight:(CGFloat)inWebViewContentHeight{
    
    CGFloat webViewContentHeight = flag==1 ?inWebViewContentHeight :self.webView.scrollView.contentSize.height;
    CGFloat tableViewContentHeight = self.tableView.contentSize.height;
    
    if (webViewContentHeight == _lastWebViewContentHeight && tableViewContentHeight == _lastTableViewContentHeight) {
        return;
    }
    
    _lastWebViewContentHeight = webViewContentHeight;
    _lastTableViewContentHeight = tableViewContentHeight;
    
    self.containerScrollView.contentSize = CGSizeMake(self.view.width, webViewContentHeight + tableViewContentHeight);
    
    CGFloat webViewHeight = (webViewContentHeight < self.view.height) ?webViewContentHeight :self.view.height ;
    CGFloat tableViewHeight = tableViewContentHeight < self.view.height ?tableViewContentHeight :self.view.height;
    self.webView.height = webViewHeight <= 0.1 ?self.view.height :webViewHeight;
    self.contentView.height = webViewHeight + tableViewHeight;
    self.tableView.height = tableViewHeight;
    self.tableView.y = self.webView.bottom;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_containerScrollView != scrollView) {
        return;
    }
    CGFloat topH = 80;
    CGFloat offsetY = scrollView.contentOffset.y;
    offsetY = offsetY - topH;//处理头部增加 xinle

    CGFloat webViewHeight = self.webView.height;
    CGFloat tableViewHeight = self.tableView.height;
    
    CGFloat webViewContentHeight = self.webView.scrollView.contentSize.height;
    CGFloat tableViewContentHeight = self.tableView.contentSize.height;
    
    //title展示~~~
    if (offsetY >= - 64) {
        self.title = @"展示~~";
    }else{
        self.title = @"";
    }
    
    if (offsetY <= 0) {
        self.contentView.y = 0;
        self.webView.scrollView.contentOffset = CGPointZero;
        self.tableView.contentOffset = CGPointZero;
    }else if(offsetY < webViewContentHeight - webViewHeight){
        self.webView.scrollView.contentOffset = CGPointMake(0, offsetY);
        self.contentView.y = offsetY;
    }else if(offsetY < webViewContentHeight){
        self.tableView.contentOffset = CGPointZero;
        self.webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
    }else if(offsetY < webViewContentHeight + tableViewContentHeight - tableViewHeight){
        self.contentView.y = offsetY - webViewHeight;
        self.tableView.contentOffset = CGPointMake(0, offsetY - webViewContentHeight + topH);//xinle 处理顶部自定义控件
        self.webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
    }else if(offsetY <= webViewContentHeight + tableViewContentHeight){
        self.webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
        self.tableView.contentOffset = CGPointMake(0, tableViewContentHeight - tableViewHeight + topH);
        self.contentView.y = self.containerScrollView.contentSize.height - self.contentView.height;
    }else {
        //do nothing
        NSLog(@"do nothing");
    }
    
}

#pragma mark - UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor redColor];
    }
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
}

#pragma mark - private
- (WKWebView *)webView{
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.scrollView.scrollEnabled = NO;
        _webView.navigationDelegate = self;
    }
    
    return _webView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
        
    }
    return _tableView;
}

- (UIScrollView *)containerScrollView{
    if (_containerScrollView == nil) {
        _containerScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _containerScrollView.delegate = self;
        _containerScrollView.alwaysBounceVertical = YES;
    }
    
    return _containerScrollView;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

@end

