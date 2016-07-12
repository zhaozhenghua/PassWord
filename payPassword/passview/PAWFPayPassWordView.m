//
//  PAWFPayPassWordView.m
//  弹框
//
//  Created by 赵正华 on 16/7/4.
//  Copyright © 2016年 赵正华. All rights reserved.
//

#import "PAWFPayPassWordView.h"
#import "PAWFSafeKeyboard.h"

@interface PAWFPayPassWordView ()<PAWFSafeKeyboardDelegate>

//保存密码的字符串
@property (nonatomic,strong)NSMutableString *passWordString;

@end

static NSString *const MONEYNUMBER = @"0123456789";
@implementation PAWFPayPassWordView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.passWordString = [NSMutableString string];
        //密码位数
        self.passWordNumber = 8;
        //密码框大小
        self.squareWidth = 40;
        //密码黑点的大小
        self.pointRadius = 6;
        //密码点的颜色
        self.pointColor = [UIColor blackColor];
        //边框的颜色
        self.borderColor = [UIColor redColor];
        //中间分割线的颜色
        self.lineColor =  [UIColor grayColor];
        [self becomeFirstResponder];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self becomeFirstResponder];
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}
/*
   设置密码框的边长
 */
-(void)setSquareWidth:(CGFloat)squareWidth{
    _squareWidth = squareWidth;
    [self setNeedsDisplay];
}
/*
 设置密码位数
 */
-(void)setPassWordNumber:(NSUInteger)passWordNumber{
    _passWordNumber = passWordNumber;
    [self setNeedsDisplay];
}
/*
 开始输入密码,成为第一响应
 */
-(BOOL)becomeFirstResponder{
    if ([self.delegate respondsToSelector:@selector(passWordViewBeginInput:)]) {
        [self.delegate passWordViewBeginInput:self];
    }
    return [super becomeFirstResponder];
}
/*
 是否成功第一响应者
 */
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(UIView *)inputView{
    PAWFSafeKeyboard *keyboard = [[PAWFSafeKeyboard alloc]initWithType:PAWFSafeKeyboardTypeDisorder];
    keyboard.delegate = self;
    return keyboard;
}
- (void)didSelectKeyboard:(NSString*)string indexPath:(NSIndexPath*)indexPath{

    if (self.passWordString.length < self.passWordNumber) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:MONEYNUMBER] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicText = [string isEqualToString:filtered];
        if (basicText) {
            [self.passWordString appendString:string];
            if ([self.delegate respondsToSelector:@selector(passWordViewDidChange:)]) {
                [self.delegate passWordViewDidChange:self];
            }
            if (self.passWordString.length == self.passWordNumber) {
                if ([self.delegate respondsToSelector:@selector(passWordViewCompleteInput:AndPassWordString:)]) {
                    [self.delegate passWordViewCompleteInput:self AndPassWordString:^(NSMutableString *password) {
                        password = self.passWordString;
                    }];
                }
            }
            [self setNeedsDisplay];
        }
    }

}

- (void)clickedKeyboardBackBtn{
    [self resignFirstResponder];
}

- (void)clickedKeyboardCleanBtn{
    if (self.passWordString.length > 0) {
        [self.passWordString deleteCharactersInRange:NSMakeRange(self.passWordString.length - 1, 1)];
        if ([self.delegate respondsToSelector:@selector(passWordViewDidChange:)]) {
            [self.delegate passWordViewDidChange:self];
        }
    }
    [self setNeedsDisplay];
}
- (void)clickedKeyboardComfirnBtn{

  NSLog(@"clickedKeyboardComfirnBtn");
}
/*
   返回是否具有文本对象
 */
-(BOOL)hasText{
    return self.passWordString.length > 0;
}

- (void)drawRect:(CGRect)rect {
    //计算整个会话区域
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    CGFloat widthV = width / self.passWordNumber;
    CGFloat x = (width - widthV*self.passWordNumber)/2.0;
    CGFloat y = (height - self.squareWidth)/2.0;
    //开启图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画外框
    CGFloat radius = 5;
    
    // 移动到初始点
    CGContextMoveToPoint(context, radius, 0);
    
    // 绘制第1条线和第1个1/4圆弧，右上圆弧
    CGContextAddLineToPoint(context, width - radius,0);
    CGContextAddArc(context, width - radius, radius, radius, -0.5 *M_PI,0.0,0);
    // 绘制第2条线和第2个1/4圆弧，右下圆弧
    CGContextAddLineToPoint(context, width, height - radius);
    CGContextAddArc(context, width - radius, height - radius, radius,0.0,0.5 *M_PI,0);
    // 绘制第3条线和第3个1/4圆弧，左下圆弧
    CGContextAddLineToPoint(context, radius, height);
    CGContextAddArc(context, radius, height - radius, radius,0.5 *M_PI,M_PI,0);
    // 绘制第4条线和第4个1/4圆弧，左上圆弧
    CGContextAddLineToPoint(context, 0, radius);
    CGContextAddArc(context, radius, radius, radius,M_PI,1.5 *M_PI,0);
    
    // 闭合路径
    CGContextClosePath(context);
    
    // 填充半透明红色
    CGContextSetLineWidth(context, 2.0);//线的宽度
    
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);//线框颜色
    
    CGContextDrawPath(context,kCGPathStroke);

    //画竖条
    for (int i = 1; i < self.passWordNumber; i++) {
        CGContextMoveToPoint(context, x+i*widthV, 0);
        CGContextAddLineToPoint(context, x+i*widthV, height);
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    }
    //画黑点
    CGContextSetFillColorWithColor(context, self.pointColor.CGColor);
    for (int i = 1; i <= self.passWordString.length; i++) {
        CGContextAddArc(context,  x+i*widthV - widthV/2.0, y+self.squareWidth/2, self.pointRadius, 0, M_PI*2, YES);
        CGContextDrawPath(context, kCGPathFill);
    }
}
@end
