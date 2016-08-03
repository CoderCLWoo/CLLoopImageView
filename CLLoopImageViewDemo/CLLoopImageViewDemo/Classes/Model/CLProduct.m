//
//  CLProduct.m
//  图片循环轮播
//
//  Created by WuChunlong on 16/8/2.
//  Copyright © 2016年 WuChunlong. All rights reserved.
//

#import "CLProduct.h"

@implementation CLProduct

+ (instancetype)productWithDict:(NSDictionary *)dict {
    CLProduct *product = [[self alloc] init];
    
    [product setValuesForKeysWithDictionary:dict];
    
    return product;
}

@end
