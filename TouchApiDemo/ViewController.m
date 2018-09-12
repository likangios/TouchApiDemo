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
@interface ViewController ()<UIWebViewDelegate,UINavigationControllerDelegate>


@property(nonatomic,assign) BOOL  taskStart;

@property(nonatomic,assign) NSInteger  index;

@property(nonatomic,strong) UIWebView *webView;

@property(nonatomic,strong) NSString *searchUrl;

@property(nonatomic,assign) CGFloat firstItemCenterY;

@property(nonatomic,assign) CGFloat firstItemCenterX;

@property(nonatomic,assign) CGFloat cellHeight;

@property(nonatomic,assign) CGFloat adHeight;

@property(nonatomic,assign) CGFloat containerOffsetY;


@property(nonatomic,strong) UIButton *searchBarBtn;

@property(nonatomic,strong) UIButton *beginTaskBtn;


@end
@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstItemCenterX = 6 + 8 + 50;
    _searchUrl = @"https://a.m.taobao.com/i553286962768.htm?spm=0.0.0.0.hyfCSJ&abtest=16&rn=f66886f409d758bf040e601524211692&sid=c5c8536d86ea235b44af6853401a80c1";
    _index = 0;
    _taskStart = NO;
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://h5.m.taobao.com/"]]];
    _webView.delegate = self;
//    _webView.scrollView.decelerationRate = 0.001;
    _webView.scrollView.bouncesZoom = NO;
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
        [self longTouch:CGPointMake(self.firstItemCenterX+200, self.firstItemCenterY)];
        return;
        _taskStart = YES;
        CGPoint point = CGPointMake(self.firstItemCenterX, self.firstItemCenterY);
        UIView *test = [UIView new];
        test.center = point;
        test.backgroundColor = [UIColor redColor];
        test.bounds = CGRectMake(0, 0, 10, 10);
        [self.view addSubview:test];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [test removeFromSuperview];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self SimulateTouch:point];
        });



    }
}
- (void)SimulateTouch:(CGPoint)point{
    
    NSInteger pointId = [PTFakeMetaTouch fakeTouchId:[PTFakeMetaTouch getAvailablePointId] AtPoint:point withTouchPhase:UITouchPhaseBegan];
    [PTFakeMetaTouch fakeTouchId:pointId AtPoint:point withTouchPhase:UITouchPhaseEnded];
    
}
- (void)swipeTouchFrom:(CGPoint)fromPoint To:(CGPoint)toPoint{
    
    NSInteger pointId2 = [PTFakeMetaTouch fakeTouchId:[PTFakeMetaTouch getAvailablePointId] AtPoint:fromPoint withTouchPhase:UITouchPhaseBegan];
    [PTFakeMetaTouch fakeTouchId:pointId2 AtPoint:toPoint withTouchPhase:UITouchPhaseMoved];
    [PTFakeMetaTouch fakeTouchId:pointId2 AtPoint:toPoint withTouchPhase:UITouchPhaseCancelled];
    
    NSLog(@"swipe from:(%f,%f) to:(%f,%f)",fromPoint.x,fromPoint.y,toPoint.x,toPoint.y);
}
- (void)longTouch:(CGPoint)point{
    NSInteger pointId = [PTFakeMetaTouch fakeTouchId:[PTFakeMetaTouch getAvailablePointId] AtPoint:point withTouchPhase:UITouchPhaseBegan];
    [PTFakeMetaTouch fakeTouchId:pointId AtPoint:point withTouchPhase:UITouchPhaseStationary];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PTFakeMetaTouch fakeTouchId:pointId AtPoint:point withTouchPhase:UITouchPhaseCancelled];
    });

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    UIScrollView *scr = [webView valueForKeyPath:@"_UIWebViewScrollView"];
//    scr.decelerationRate = 0.01;
//    
//    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
//
//     NSString *currentHTML = [webView stringByEvaluatingJavaScriptFromString:lJs];
//    [self getInfoWithWebView:webView className:@"list-item"];
//    [self getInfoWithWebView:webView className:@"toolbar"];
//    [self getInfoWithWebView:webView className:@"page-container"];
    self.containerOffsetY = [self getValueWith:@"offsetTop" WebView:webView className:@"page-container"];
    self.cellHeight = [self getValueWith:@"clientHeight" WebView:webView className:@"mark"];
    self.adHeight = [self getValueWith:@"clientHeight" WebView:webView className:@"install-app"];
    self.firstItemCenterY = self.containerOffsetY + self.cellHeight/2.0;
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
- (CGFloat)getValueWith:(NSString *)key WebView:(UIWebView *)webView className:(NSString *)name{

    NSString *element = [NSString stringWithFormat:@"document.getElementsByClassName(\"%@\")[0].",name];
    NSString *js = [element stringByAppendingString:key];
    NSString *value = [webView stringByEvaluatingJavaScriptFromString:js];
    NSLog(@"%@.%@ = %@",name,key,value);
    return value.integerValue;
}

- (void)getInfoWithWebView:(UIWebView *)webView  className:(NSString *)name{
    
    NSString *url = webView.request.URL.absoluteString;
    NSLog(@"<<<<<<<<<<<<<<<<<<%@>>>>>>>>>>>>>>>>>>>>>",url);
    NSString *element = [NSString stringWithFormat:@"document.getElementsByClassName(\"%@\")[0].",name];
    NSString *offsetTop = [element stringByAppendingString:@"offsetTop"];
    NSString *offsetLeft = [element stringByAppendingString:@"offsetLeft"];
    NSString *clientWidth = [element stringByAppendingString:@"clientWidth"];
    NSString *clientHeight = [element stringByAppendingString:@"clientHeight"];

    NSLog(@"%@======offsetTop======%@", name,[webView stringByEvaluatingJavaScriptFromString:offsetTop]);
    NSLog(@"%@======offsetLeft======%@", name, [webView stringByEvaluatingJavaScriptFromString:offsetLeft]);
    NSLog(@"%@======clientWidth======%@", name, [webView stringByEvaluatingJavaScriptFromString:clientWidth]);
    NSLog(@"%@======clientHeight======%@", name, [webView stringByEvaluatingJavaScriptFromString:clientHeight]);
}
- (void)getInfoByTagNameWithWebView:(UIWebView *)webView  className:(NSString *)name{
    
    NSString *url = webView.request.URL.absoluteString;
    NSLog(@"<<<<<<<<<<<<<<<<<<%@>>>>>>>>>>>>>>>>>>>>>",url);
    NSString *element = [NSString stringWithFormat:@"document.getElementsByTagName(\"%@\")[0].",name];
    NSString *offsetTop = [element stringByAppendingString:@"offsetTop"];
    NSString *offsetLeft = [element stringByAppendingString:@"offsetLeft"];
    NSString *clientWidth = [element stringByAppendingString:@"clientWidth"];
    NSString *clientHeight = [element stringByAppendingString:@"clientHeight"];
    
    NSLog(@"%@======offsetTop======%@", name,[webView stringByEvaluatingJavaScriptFromString:offsetTop]);
    NSLog(@"%@======offsetLeft======%@", name, [webView stringByEvaluatingJavaScriptFromString:offsetLeft]);
    NSLog(@"%@======clientWidth======%@", name, [webView stringByEvaluatingJavaScriptFromString:clientWidth]);
    NSLog(@"%@======clientHeight======%@", name, [webView stringByEvaluatingJavaScriptFromString:clientHeight]);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
  
    if (_taskStart) {
        _index ++;
        NSLog(@"click url is %@",request.URL.absoluteString);
        if ([request.URL.absoluteString isEqualToString:_searchUrl]) {
            NSString *msg = [NSString stringWithFormat:@"找到了指定的商品在 %ld 位",_index];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"" delegate:msg cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return YES;
        }
        else{
            if (_index == 5) {
                CGPoint point = CGPointMake(self.firstItemCenterX, self.cellHeight);
                [self swipeTouchFrom:CGPointMake(point.x, point.y + self.adHeight) To:CGPointMake(point.x, 0)];
            }
            else{
                CGPoint point = CGPointMake(self.firstItemCenterX, self.adHeight);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self swipeTouchFrom:point To:CGPointMake(point.x, 0)];
                });
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self SimulateTouch:point];
//                });
            }
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
