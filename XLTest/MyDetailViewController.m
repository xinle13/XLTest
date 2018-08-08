//
//  MyDetailViewController.m
//  XLTest
//
//  Created by admin on 2018/3/12.
//  Copyright © 2018年 xinle. All rights reserved.
//

#import "MyDetailViewController.h"
#import "UIButton+XLBlock.h"
#import "UITextField+XLBlock.h"
#import "UIAlertView+XLBlock.h"
#import "UIView+Extension.h"
#import <WebKit/WKWebView.h>

// 颜色
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGBColor(r, g, b)     RGBAColor((r), (g), (b), 1.0)
#define RandomColor           RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#define HEX_COLOR(rgb)  RGBAColor(((float)((rgb & 0xFF0000) >> 16)), ((float)((rgb & 0xFF00) >> 8)), ((float)(rgb & 0xFF)), 1.0)

@interface MyDetailViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong)UILabel *testLbl;
@property (nonatomic, strong)UILabel *testLbl1;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation MyDetailViewController

-(void)dealloc{
    NSLog(@"~~~MyDetailViewController销毁~~");
}

-(UILabel *)testLbl{
    
    if (_testLbl == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = 100;
        label.text = @"我就测试看看~~";
        label.textColor = HEX_COLOR(0x73c4f6);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        _testLbl = label;
    }
    return _testLbl;
}

-(UILabel *)testLbl1{
    
    if (_testLbl1 == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = HEX_COLOR(0xf1f9fe);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        _testLbl1 = label;
    }
    return _testLbl1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.testLbl1];
    [self.view addSubview:self.testLbl];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 375, 667)];
    [self.view addSubview:scroll];
    scroll.delegate = self;
    scroll.contentSize = CGSizeMake(375 * 3, 0);
    scroll.pagingEnabled = YES;
    
    //注意测试一下内存(时间换空间,空间换时间)
    for (int i = 0; i < 2; i++) {
        //黑色底部
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(100 + 375 * i, 100, 100, 100)];
        backView.backgroundColor = [UIColor colorWithRed:(random() % 255 / 255.0) green:(random() % 255 / 255.0) blue:(random() % 255 / 255.0) alpha:1.0];
        [scroll addSubview:backView];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

    CGFloat imgW = 262 * 0.5;
    CGFloat imgH = 147 * 0.5;
    btn.frame = CGRectMake(15, 64, imgW, imgH);
    [btn setTitle:@"block测试" forState:UIControlStateNormal];
    
//    btn.xl_frame(CGRectMake(100, 300, 100, 30))
//       .xl_title(@"我就是嘚瑟");
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [btn addActionBlock:^(UIButton *btn) {
        
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cocoachina.com/ios/20180503/23267.html"]]];
        
//        [UIView animateWithDuration:0.5 animations:^{
//            btn.frame = CGRectMake(0, 250, 375, 300);
//        } completion:^(BOOL finished) {
//
//        }];
        
//        CGAffineTransformScale实现以一个已经存在的形变为基准,在x轴方向上缩放x倍,在y轴方向上缩放y倍
//        // 格式
//        CGAffineTransformScale(CGAffineTransform t, CGFloat sx, CGFloat sy)
//        // 样例
//        CGAffineTransform transform = CGAffineTransformMakeScale(2, 0.5);
//        self.demoImageView.transform = CGAffineTransformScale(transform, 2, 1);
//
        
        //中间字形变的动画
        self.testLbl.hidden = NO;
        self.testLbl.frame = CGRectMake(0, 100, 375, 34);
        self.testLbl.transform = CGAffineTransformScale(self.testLbl.transform, 0.125, 0.125);
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            self.testLbl.transform = CGAffineTransformScale(self.testLbl.transform, 8.0, 8.0);
        } completion:^(BOOL finished) {
            self.testLbl.hidden = YES;
        }];
        
        //底部背景形变动画
        self.testLbl1.hidden = NO;
        self.testLbl1.frame = CGRectMake(0, 100, 375, 34);
        self.testLbl1.transform = CGAffineTransformScale(self.testLbl1.transform, 0.125, 1);
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            self.testLbl1.transform = CGAffineTransformScale(self.testLbl1.transform, 8.0, 1);
        } completion:^(BOOL finished) {
            self.testLbl1.hidden = YES;
        }];
        
        
    } forControlEvents:(UIControlEventTouchUpInside)];
    
    [scroll addSubview:btn];
    btn.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        btn.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            btn.frame = CGRectMake(0, 250, 375, 300);
        } completion:^(BOOL finished) {
            
        }];
    });
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(100 , 500, 100, 30)];
    tf.placeholder = @"Block Test";
    tf.backgroundColor = [UIColor yellowColor];
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    [tf addAactionBlock:^(NSString *str) {
        NSLog(@"~~~UIControlEventEditingDidBegin:%@",str);
    } forControlEvents:(UIControlEventEditingDidBegin)];
    
    [tf addAactionBlock:^(NSString *str) {
        NSLog(@"~~~UIControlEventEditingChanged:%@",str);
    } forControlEvents:(UIControlEventEditingChanged)];
    
    [tf addAactionBlock:^(NSString *str) {
        NSLog(@"~~~UIControlEventEditingDidEnd:%@",str);
    } forControlEvents:(UIControlEventEditingDidEnd)];
   
    [tf addAactionBlock:^(NSString *str) {
        NSLog(@"~~~UIControlEventEditingDidEndOnExit:%@",str);
    } forControlEvents:(UIControlEventEditingDidBegin)];
    
    [scroll addSubview:tf];
    
    
    
    //**************************
    //webView测试
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, 375, 180)];
    _webView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_webView];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
   
    //**************************
    
    
}

-(void)tap{
    
    NSLog(@"~~~点击事件~~~");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tap" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.returnBlock) {
            self.returnBlock(@"block返回~~~");
        }
    }];
    
}

#pragma mark -- scrollView代理事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
//    NSLog(@"~~~~scrollViewDidScroll:%f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x > 375 * 2) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"~~~~scrollViewDidEndDecelerating:%f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x >= 375 * 2) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    NSLog(@"~~~~scrollViewDidEndDragging:%f",scrollView.contentOffset.x);
//    if (scrollView.contentOffset.x >= 375 * 2) {
//        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
