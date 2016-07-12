//
//  PAWFPayPassWordView.h
//  弹框
//
//  Created by 赵正华 on 16/7/4.
//  Copyright © 2016年 赵正华. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAWFPayPassWordView;
@protocol PAWFPayPassWordViewDelegate <NSObject>

@optional
/*
 监听开始输入
 */
-(void)passWordViewBeginInput:(PAWFPayPassWordView *)passWord;
/*
  监听输入改变
 */
-(void)passWordViewDidChange:(PAWFPayPassWordView *)passWord;
/*
 监听输入完成
 */
-(void)passWordViewCompleteInput:(PAWFPayPassWordView *)passWord AndPassWordString:(void (^)(NSMutableString *password))animations;

@end

IB_DESIGNABLE

@interface PAWFPayPassWordView : UIView
//密码位数
@property (nonatomic,assign)IBInspectable NSUInteger passWordNumber;
//密码框大小
@property (nonatomic,assign)IBInspectable CGFloat squareWidth;
//密码黑点的大小
@property (nonatomic,assign)IBInspectable CGFloat pointRadius;
//密码点的颜色
@property (nonatomic,strong)IBInspectable UIColor *pointColor;
//边框的颜色
@property (nonatomic,strong)IBInspectable UIColor *borderColor;
//中间分割线的颜色
@property (nonatomic,strong)IBInspectable UIColor *lineColor;

//代理
@property (nonatomic,weak)id <PAWFPayPassWordViewDelegate>delegate;
////保存密码的字符串
//@property (nonatomic,strong,readonly)NSMutableString *passWordString;

@end
