//
//  aipaoView.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/5.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "aipaoView.h"

#define kArrorHeight 8


@implementation aipaoView

- (void)drawRect:(CGRect)rect {
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor clearColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}


-(void)drawInContext:(CGContextRef)context{
    //设置当前图形的宽度
    CGContextSetLineWidth(context, 2.0);
    //填充泡泡颜色并设置透明度
    // CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    //填充的颜色
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:0.7].CGColor);
    
    //
    [self getDrawPath:context];
    
    //填充形状内的颜色
    CGContextFillPath(context);
}

-(void)getDrawPath:(CGContextRef)context{
    //取出当前的图形大小
    CGRect rrect = self.bounds;
    NSLog(@"%f", self.frame.size.width);
    NSLog(@"%f", self.frame.size.height);
    
    //设置园弧度
    CGFloat radius = 1.0;
    
    CGFloat minx = CGRectGetMinX(rrect),//0
    //中点
    midx = CGRectGetMidX(rrect),//100
    //最大的宽度的X
    maxx = CGRectGetMaxX(rrect);//200
    CGFloat miny = CGRectGetMinY(rrect),//0
    //最大的高度Y
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;//60
    
    //1.画向下的三角形
    //2.设置起点三角形的右边点为起点
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    //3.连线 右边点  －>连最下面上下面的点
    CGContextAddLineToPoint(context, midx, maxy+kArrorHeight);//画直线
    //4.最下面的点连上  最左边的点。
    CGContextAddLineToPoint(context, midx-kArrorHeight, maxy);
    
    //画4个圆弧
    //    CGContextAddArcToPoint(context, x1, y1, x2, y2, CGfloat radius );//画完后 current point不在minx,miny，而是在圆弧结束的地方
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);//画完后 current point不在minx,miny，而是在圆弧结束的地方
    CGContextAddArcToPoint(context, minx, miny, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
