//
//
//
//  Created by WuChunlong on 16/6/2.
//  Copyright © 2016年 WuChunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CLLoopImageViewBlock)(NSInteger currentIndex);

@interface CLLoopImageView : UIView

/**  轮播图片名称  */
@property (nonatomic, strong) NSArray *images;
/**  轮播标题  */
@property (nonatomic, copy) NSArray *titles;

/** 初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame autoScroll:(BOOL)isAuto; // Default is NO.
+ (instancetype)loopImageViewWithFrame:(CGRect)frame autoScroll:(BOOL)isAuto; // Default is NO.

/** 点按手势回调block */
- (void)tapCurrentImageWithHandler:(CLLoopImageViewBlock)block;


@end
