//
//  ViewController.m
//  图片循环轮播
//
//  Created by WuChunlong on 16/8/2.
//  Copyright © 2016年 WuChunlong. All rights reserved.
//

#import "ViewController.h"
#import "CLProduct.h"
#import "CLLoopImageView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

/** 轮播图片  */
@property (nonatomic, strong)NSMutableArray *images;
/** 轮播标题  */
@property (nonatomic, strong)NSMutableArray *titles;
/** 存放CLProduct对象 */
@property (nonatomic, strong) NSMutableArray *products;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"imagesData.plist" ofType:nil];
    NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
    
    
    for (NSDictionary *dict in arr) {
        CLProduct *pro = [CLProduct productWithDict:dict];
        [self.images addObject:pro.image];
        [self.titles addObject:pro.title];
        [self.products addObject:pro];
    }
    
    // 添加轮播图
    [self setupLoopImageView];
}


#pragma mark - 添加轮播图控件
/** 创建轮播图控件 */
- (void)setupLoopImageView {
    // 创建轮播图
    CLLoopImageView *loopView = [CLLoopImageView loopImageViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 450 / 800) autoScroll:NO];
    // 设置图片
    loopView.images = self.images;
    
    // 设置标题
    loopView.titles = self.titles;
    
    // 设置点按手势时间
    [loopView tapCurrentImageWithHandler:^(NSInteger currentIndex) {
        NSLog(@"点击了第 %zd 张图片", currentIndex);
        
        // 获得当前点击的product
        CLProduct *pro = self.products[currentIndex];
        // 获得url连接地址
        NSURL *url = [NSURL URLWithString:pro.url];
        // 打开连接
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    
    // 添加到父控件
    [self.view addSubview:loopView];
    
    
}


#pragma mark - 懒加载方法
- (NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    
    return _images;
}

- (NSMutableArray *)titles {
    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    
    return _titles;
}

- (NSMutableArray *)products {
    if (_products == nil) {
        _products = [NSMutableArray array];
    }
    
    return _products;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
