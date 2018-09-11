//
//  ViewController.m
//  TouchApiDemo
//
//  Created by luck on 2018/9/11.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "ViewController.h"
#import <PTFakeTouch/PTFakeTouch.h>
#import <PTFakeTouch/PTFakeMetaTouch.h>
@interface ViewController ()<UIWebViewDelegate>


@property(nonatomic,assign) BOOL  taskStart;

@property(nonatomic,assign) NSInteger  index;

@property(nonatomic,strong) UIWebView *webView;

@property(nonatomic,strong) NSString *searchUrl;


@property(nonatomic,strong) UIButton *searchBarBtn;

@property(nonatomic,strong) UIButton *beginTaskBtn;


@end
@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _searchUrl = @"https://a.m.taobao.com/i568668878625.htm?spm=0.0.0.0.pWuCwc&abtest=4&rn=0f3f12cb45d1db6b5150bd128ee0c931&sid=8faa46b65b7ee1cbfa097c98b8452dc6";
    _index = 1;
    _taskStart = NO;
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://h5.m.taobao.com/"]]];
    _webView.delegate = self;
    [self.view addSubview:_webView];

    [self.webView addSubview:self.searchBarBtn];
    [self.webView addSubview:self.beginTaskBtn];
    
    [self.searchBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-100);
    }];
    [self.beginTaskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBarBtn.mas_right).offset(10);
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(self.searchBarBtn);
        make.height.mas_equalTo(self.searchBarBtn);
        make.width.mas_equalTo(self.searchBarBtn.mas_width);
    }];
    
}
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == 888) {
        _taskStart = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self SimulateTouch:CGPointMake(200, 15)];
        });
    }
    else if (btn.tag == 999) {
        _taskStart = YES;
        
        UIView *test = [UIView new];
        test.center = CGPointMake(100, 120);

    }
}
- (void)SimulateTouch:(CGPoint)point{
    
    NSInteger pointId = [PTFakeMetaTouch fakeTouchId:[PTFakeMetaTouch getAvailablePointId] AtPoint:point withTouchPhase:UITouchPhaseBegan];
    [PTFakeMetaTouch fakeTouchId:pointId AtPoint:point withTouchPhase:UITouchPhaseEnded];
    
}
- (void)swipeTouchFrom:(CGPoint)fromPoint To:(CGPoint)toPoint{
    
    NSInteger pointId2 = [PTFakeMetaTouch fakeTouchId:[PTFakeMetaTouch getAvailablePointId] AtPoint:fromPoint withTouchPhase:UITouchPhaseBegan];
    [PTFakeMetaTouch fakeTouchId:pointId2 AtPoint:toPoint withTouchPhase:UITouchPhaseMoved];
    [PTFakeMetaTouch fakeTouchId:pointId2 AtPoint:toPoint withTouchPhase:UITouchPhaseEnded];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
//    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
//
//     NSString *currentHTML = [webView stringByEvaluatingJavaScriptFromString:lJs];

    
    NSMutableString *address = [NSMutableString string];
    // 6.1首先获取到该标签元素
//    [address appendString:@"var mark = document.getElementsByClassName(\"mark\")[0];"];
    // 6.2获取到该标签元素的文本内容
//    [address appendString:@"mark.height"];
    // 6.3输出内容
//    NSLog(@"======%@", [webView stringByEvaluatingJavaScriptFromString:address]);
    
    
    /*
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    NSString *urlResult = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    NSArray *urlArray = [NSMutableArray arrayWithArray:[urlResult componentsSeparatedByString:@"+"]];
    //urlResurlt 就是获取到得所有图片的url的拼接；mUrlArray就是所有Url的数组
    NSLog(@"--%@",urlArray);
     */
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
  
    if (_taskStart) {
        _index ++;
        if ([request.URL.absoluteString isEqualToString:_searchUrl]) {
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return YES;
    }
   
}

- (UIButton *)searchBarBtn{
    if (!_searchBarBtn) {
        _searchBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBarBtn setTitle:@"模拟点击搜索" forState:UIControlStateNormal];
        _searchBarBtn.backgroundColor = [UIColor grayColor];
        _searchBarBtn.tag = 888;
        [_searchBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchBarBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _searchBarBtn;
}

- (UIButton *)beginTaskBtn{
    if (!_beginTaskBtn) {
        _beginTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beginTaskBtn setTitle:@"开始查找商品" forState:UIControlStateNormal];
        _beginTaskBtn.backgroundColor = [UIColor grayColor];
        _beginTaskBtn.tag = 999;
        [_beginTaskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_beginTaskBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beginTaskBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
