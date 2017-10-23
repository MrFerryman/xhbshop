//
//  UIImage+ZYQAddition.h
//  zhiyingfenzhang
//
//  Created by mac on 2017/1/16.
//  Copyright © 2017年 zhangyiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZYQAddition)

/**
 将图片渲染成其他颜色
 
 @param tintColor 渲染颜色
 @return 渲染颜色后的图片
 */
- (UIImage *) zyq_imageWithTintColor:(UIColor *)tintColor;


/**
 *  压缩图片到指定尺寸大小
 *
 *  @param image 原始图片
 *  @param size  目标大小
 *
 *  @return 生成图片
 */
-(UIImage *)zyq_compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
- (NSData *)zyq_compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

@end
