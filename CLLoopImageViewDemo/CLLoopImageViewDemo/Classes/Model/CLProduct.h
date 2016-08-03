//
//  CLProduct.h
//  图片循环轮播
//
//
//  Created  on 16/6/2.
//  Copyright © 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLProduct : NSObject

/**  图片名称 */
@property (nonatomic, copy) NSString *image;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 超链接 */
@property (nonatomic, copy) NSString *url;

/** 初始化方法 */
+ (instancetype)productWithDict:(NSDictionary *)dict;

@end
