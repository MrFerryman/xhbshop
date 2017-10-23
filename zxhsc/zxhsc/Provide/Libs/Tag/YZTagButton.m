//
//  YZTagButton.m
//  Hobby
//
//  Created by yz on 16/8/14.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZTagButton.h"
extern CGFloat const imageViewWH;
@implementation YZTagButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.frame.size.width <= 0) return;
    
    CGFloat btnW = self.bounds.size.width;
    CGFloat btnH = self.bounds.size.height;

    self.titleLabel.frame = CGRectMake(_margin, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    
    CGFloat imageX = btnW - self.imageView.frame.size.width -  _margin;
    CGFloat imageY = (btnH - self.imageView.frame.size.height) / 2;
//    CGFloat imageX = btnW - 21.5;
    self.imageView.frame = CGRectMake(imageX, imageY, _imageW, _imageH);

}

- (void)setHighlighted:(BOOL)highlighted {}

@end
