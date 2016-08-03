//
//  
//
//  Created by WuChunlong on 16/6/2.
//  Copyright © 2016年 WuChunlong. All rights reserved.
//

#import "CLLoopImageView.h"

@interface CLLoopImageView() <UIScrollViewDelegate> {
    NSInteger index;
}

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UILabel *indexLabel;

/**  自动轮播图计时器  */
@property (nonatomic, weak) NSTimer *timer;
/** 是否自动轮播 */
@property (nonatomic, assign) BOOL isAuto;
/** 当前播放的图片序号 */
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/** 回调block */
@property (nonatomic, strong) CLLoopImageViewBlock block;


@end

@implementation CLLoopImageView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame autoScroll:(BOOL)isAuto {
    CLLoopImageView *loopView = [self initWithFrame:frame];
    
    _isAuto = isAuto;
    if (isAuto) {
        [self startTimer];
    }
    
    return loopView;
}

+ (instancetype)loopImageViewWithFrame:(CGRect)frame autoScroll:(BOOL)isAuto {
    CLLoopImageView *loopView = [[self alloc] initWithFrame:frame autoScroll:isAuto];
    return loopView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 创建滚动视图
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        self.scrollView.frame = self.frame;
        
        // 创建显示页码的标签
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.frame = CGRectMake(self.bounds.size.width  - 30, self.bounds.size.height - 20, 0, 18);
        indexLabel.textColor = [UIColor yellowColor];
        indexLabel.font = [UIFont systemFontOfSize:12];
        indexLabel.backgroundColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:0.5];
        [self addSubview:indexLabel];
        self.indexLabel = indexLabel;
        

        index = 1;
        _currentIndex = 0;
        
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self.scrollView addGestureRecognizer:tap];
        
    }
    return self;
}

#pragma mark - 重写setter
//--------------------------  轮播图片 ------------------------------------
- (void)setImages:(NSArray *)images {
    _images = images;
    
    NSMutableArray *imagesArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *imageName in images) {
        [imagesArray addObject:imageName];
    }
    NSString *lastImageName = [images lastObject];
    [imagesArray insertObject:lastImageName atIndex:0];
    NSString *firstImageName = [images firstObject];
    [imagesArray addObject:firstImageName];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * imagesArray.count, self.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width, 0);
    

    for (int i = 0; i < imagesArray.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(self.scrollView.bounds.size.width * i, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        NSString *imageName = imagesArray[i];
        imageView.image = [UIImage imageNamed:imageName] ;
        [self.scrollView addSubview:imageView];

    }
    
    self.indexLabel.text = [NSString stringWithFormat:@"1 / %ld", images.count];
    [self.indexLabel sizeToFit];
}



//--------------------------  标题 ------------------------------------
- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    NSMutableArray *titlesArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *title in titles) {
        [titlesArray addObject:title];
    }
    NSString *lastTitle = [titles lastObject];
    [titlesArray insertObject:lastTitle atIndex:0];
    NSString *firstTitle = [titles firstObject];
    [titlesArray addObject:firstTitle];
    

    for (NSString *title in titlesArray) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        
        NSInteger i = [titlesArray indexOfObject:title];
        titleLabel.frame = CGRectMake(self.scrollView.bounds.size.width * i + 10, self.scrollView.frame.size.height - 22, 0, 20);
        titleLabel.text = title;
        titleLabel.textColor = [UIColor yellowColor];
        titleLabel.backgroundColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:0.5];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [titleLabel sizeToFit];
        titleLabel.hidden = (title.length == 0);
        [self.scrollView addSubview:titleLabel];
    }
    
}



#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x == scrollView.frame.size.width * 0) {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * (self.images.count), 0);
        
    } else if (scrollView.contentOffset.x == scrollView.frame.size.width * (self.images.count + 1)) {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * 1, 0);
        
    } else if (scrollView.contentOffset.x < scrollView.frame.size.width ) {
        index = scrollView.contentOffset.x / scrollView.frame.size.width + 1;
    } else {
        index = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
    
    self.indexLabel.text = [NSString stringWithFormat:@"%ld / %ld", index, self.images.count];
    [self.indexLabel sizeToFit];
    _currentIndex  = index - 1;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_isAuto) {
        [self stopTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (_isAuto) {
        [self startTimer];
    }
}


#pragma mark - 定时器处理
/** 启动定时器 */
- (void)startTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(timerSelect) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
    
}

/** 停止定时器 */
- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

/** 定时器处理事件 */
- (void)timerSelect {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.2f;
    
    CGFloat x = self.scrollView.contentOffset.x;
    self.scrollView.contentOffset = CGPointMake(x + self.scrollView.frame.size.width, 0);
    [self.scrollView.layer addAnimation:transition forKey:nil];
}

#pragma mark - 点按手势
- (void)tap {
    
    if (_block) {
        _block(_currentIndex);
    }
}

- (void)tapCurrentImageWithHandler:(CLLoopImageViewBlock)block {
    _block = block;
   
}

@end
