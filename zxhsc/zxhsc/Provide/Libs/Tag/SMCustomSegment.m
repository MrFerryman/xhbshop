//
//  SMCustomSegment.m
//  分段直接实现
//
//  Created by 志恒李-ly on 16/9/18.
//  Copyright © 2016年 mac. All rights reserved.
//
#define CustomSegmentBtnTag 888
#define CustomSegmentLineViewTag 275

#import "SMCustomSegment.h"

@interface SMCustomSegment ()

@property (nonatomic, strong) NSArray * titleArray;

@end

@implementation SMCustomSegment

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    if (self = [super initWithFrame:frame]) {
        _titleArray = titleArray;
        if (_titleArray.count <= 0) return self;
        
        self.cornerRadius = frame.size.height/2;
        self.borderWidth = 0.0f;
        _normalBackgroundColor = [UIColor whiteColor];
        _selectBackgroundColor = [UIColor redColor];
        _titleNormalColor = [UIColor lightGrayColor];
        _titleSelectColor = [UIColor blueColor];
        _selectIndex = 0;
        _normalTitleFont = 14.0f;
        _selectTitleFont = 14.0f;
        _automaticWidth = YES;
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    self.clipsToBounds = YES;
    self.layer.borderColor = self.selectBackgroundColor.CGColor;
//    _automaticWidth = _automaticWidth;
    CGFloat itemWidth = 1.0 * self.frame.size.width / _titleArray.count;
    NSMutableArray *mutableArray = [[NSMutableArray alloc]init];
    CGFloat totalTitleWidth = 0 ;
    CGFloat spaceOfTitle;
    for (int i = 0; i<_titleArray.count; i++) {
        
        CGFloat titleWidth = [_titleArray[i] sizeWithFont:[UIFont systemFontOfSize:_normalTitleFont]].width;
                totalTitleWidth += titleWidth;
        [mutableArray addObject: [NSString stringWithFormat:@"%f",titleWidth ]];

    }
    spaceOfTitle = (self.frame.size.width - totalTitleWidth) /(_titleArray.count *2);
    NSLog(@"space = %f",spaceOfTitle);
    for (int i = 0; i < _titleArray.count; i ++) {
        
         UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (_automaticWidth) {
            
            CGFloat width = 2 * spaceOfTitle +  [mutableArray[i] floatValue];
            if (i == 0) {
                 button.frame = CGRectMake(0 , 1, width, self.frame.size.height-2);
                button.layer.shadowOffset = CGSizeMake(-1, 1);
                button.layer.shadowRadius = 1.5;
                button.layer.shadowOpacity = 0.2;
                
            }
            else{
                CGFloat btnX = 0 ;
                for (int j = 0; j<i; j++) {
                    btnX += (2 * spaceOfTitle + [mutableArray[j] floatValue]);
                }
                button.layer.shadowOffset = CGSizeMake(1, 1);
                button.layer.shadowRadius = 1.5;
                button.layer.shadowOpacity = 0.2;
                button.frame = CGRectMake(2*spaceOfTitle + [mutableArray[i-1] floatValue], 1, width, self.frame.size.height - 2);
            }
           
        }else{
            button.frame = CGRectMake(itemWidth * i, 1, itemWidth, self.frame.size.height-2);

        }
        button.clipsToBounds = YES;
        button.tag = CustomSegmentBtnTag + i;
        
        
        [self setBtnTitleNormalOrSelectFont:button buttonTitle:_titleArray[i] state:UIControlStateNormal font:_normalTitleFont color:_titleNormalColor];
        [self setBtnTitleNormalOrSelectFont:button buttonTitle:_titleArray[i] state:UIControlStateSelected font:_selectTitleFont color:_titleSelectColor];
        
        [button setBackgroundImage:[self createImageWithColor:_normalBackgroundColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[self createImageWithColor:_normalBackgroundColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[self createImageWithColor:_selectBackgroundColor] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        [self sendSubviewToBack:button];
        
        if (_selectIndex == i) {
            button.selected = YES;
            button.userInteractionEnabled = NO;
        }
        
        if (i == _titleArray.count - 1) continue;
        
//        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * (i + 1), 0, 1, self.frame.size.height)];
//        lineView.tag = CustomSegmentLineViewTag + i;
//        lineView.backgroundColor = _selectBackgroundColor;
//        [self addSubview:lineView];
        
    }
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag - CustomSegmentBtnTag == _selectIndex) return;
    
    UIButton * oldButton = (UIButton *)[self viewWithTag:_selectIndex + CustomSegmentBtnTag];
    if (oldButton) {
        oldButton.selected = NO;
        oldButton.userInteractionEnabled = YES;
    }
    
    button.selected = YES;
    button.userInteractionEnabled = NO;
    
    _selectIndex = button.tag - CustomSegmentBtnTag;
    
    if (_delegate && [_delegate respondsToSelector:@selector(customSegmentSelectIndex:)]) {
        [_delegate customSegmentSelectIndex:_selectIndex];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}
- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}
#pragma mark - 设置item背景颜色
- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor
{
    if (normalBackgroundColor == _normalBackgroundColor) return;
    
    _normalBackgroundColor = normalBackgroundColor;
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton * button = (UIButton *)[self viewWithTag:CustomSegmentBtnTag + i];
        if (button) {
            [button setBackgroundImage:[self createImageWithColor:normalBackgroundColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[self createImageWithColor:normalBackgroundColor] forState:UIControlStateHighlighted];
        }
    }
}

- (void)setSelectBackgroundColor:(UIColor *)selectBackgroundColor
{
    if (selectBackgroundColor == _selectBackgroundColor) return;
    
    _selectBackgroundColor = selectBackgroundColor;
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton * button = (UIButton *)[self viewWithTag:CustomSegmentBtnTag + i];
        if (button) {
            [button setBackgroundImage:[self createImageWithColor:selectBackgroundColor] forState:UIControlStateSelected];
        }
        
        UIView * lineView = [self viewWithTag:CustomSegmentLineViewTag + i];
        if (lineView) {
            lineView.backgroundColor = selectBackgroundColor;
        }
    }
    
    self.layer.borderColor = selectBackgroundColor.CGColor;
}


#pragma mark - 设置item背景图片
- (void)setNormalBackgroundImage:(UIImage *)normalBackgroundImage{
    if (normalBackgroundImage == _normalBackgroundImage) return;
    
    _normalBackgroundImage = normalBackgroundImage;
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton * button = (UIButton *)[self viewWithTag:CustomSegmentBtnTag + i];
        if (button) {
            [button setBackgroundImage:_normalBackgroundImage forState:UIControlStateNormal];
            [button setBackgroundImage:_normalBackgroundImage forState:UIControlStateHighlighted];
        }
    }
}

- (void)setSelectBackgroundImage:(UIImage *)selectBackgroundImage
{
    if (selectBackgroundImage == _selectBackgroundImage) return;
    
    _selectBackgroundImage = selectBackgroundImage;
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton * button = (UIButton *)[self viewWithTag:CustomSegmentBtnTag + i];
        if (button) {
            [button setBackgroundImage:_selectBackgroundImage forState:UIControlStateSelected];
        }
    }
    

}




#pragma mark - 设置字体颜色
- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    if (titleNormalColor == _titleNormalColor) return;
    
    _titleNormalColor = titleNormalColor;
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton * button = (UIButton *)[self viewWithTag:CustomSegmentBtnTag + i];
        if (button) {
            
            [self setBtnTitleNormalOrSelectFont:button buttonTitle:_titleArray[i] state:UIControlStateNormal font:_normalTitleFont color:titleNormalColor];
        }
    }
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor
{
    if (titleSelectColor == _titleSelectColor) return;
    
    _titleSelectColor = titleSelectColor;
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton * button = (UIButton *)[self viewWithTag:CustomSegmentBtnTag + i];
        if (button) {
            
            [self setBtnTitleNormalOrSelectFont:button buttonTitle:_titleArray[i] state:UIControlStateSelected font:_selectTitleFont color:titleSelectColor];
        }
    }
}
#pragma mark - 设置字体大小
- (void)setNormalTitleFont:(CGFloat)normalTitleFont
{
    if (normalTitleFont == _normalTitleFont) return;
    
    _normalTitleFont = normalTitleFont;
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton * button = (UIButton *)[self viewWithTag:CustomSegmentBtnTag + i];
        if (button) {
            
            [self setBtnTitleNormalOrSelectFont:button buttonTitle:_titleArray[i] state:UIControlStateNormal font:normalTitleFont color:_titleNormalColor];
        }
    }
}
- (void)setSelectTitleFont:(CGFloat)selectTitleFont
{
    if (selectTitleFont == _selectTitleFont) return;
    
    _selectTitleFont = selectTitleFont;
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton * button = (UIButton *)[self viewWithTag:CustomSegmentBtnTag + i];
        if (button) {
            
            [self setBtnTitleNormalOrSelectFont:button buttonTitle:_titleArray[i] state:UIControlStateSelected font:selectTitleFont color:_titleSelectColor];
        }
    }
}

- (void)setBtnTitleNormalOrSelectFont:(UIButton *)button buttonTitle:(NSString *)buttonTitle state:(UIControlState)state font:(CGFloat )font color:(UIColor *)color
{
    NSDictionary * dic = @{
                           NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:font],
                           NSForegroundColorAttributeName : color
                           };
    NSAttributedString * attributedTitle = [[NSAttributedString alloc] initWithString:buttonTitle attributes:dic];
    [button setAttributedTitle:attributedTitle forState:state];
}
#pragma mark - 选中的item
- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (selectIndex >= _titleArray.count || _selectIndex == selectIndex) return;
    
    _selectIndex = selectIndex;
    for (int i = 0; i < _titleArray.count; i ++) {
        UIButton * button = (UIButton *)[self viewWithTag:CustomSegmentBtnTag + i];
        if (button) {
            button.selected = selectIndex == i ? YES : NO;
            button.userInteractionEnabled = selectIndex == i ? NO : YES;
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
