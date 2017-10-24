//
//  ZYPlaceHolderTextView.h
//  zhiyingfenzhang
//
//  Created by yuanshi on 2016/12/12.
//  Copyright © 2016年 moviewisdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYPlaceHolderTextView : UITextView

// 占位文字
@property (nonatomic, copy) NSString *placeholder;
// 占位文字颜色
@property (nonatomic, copy) UIColor *placeholderColor;

- (void)textChanged:(NSNotification *)notification;
@end
