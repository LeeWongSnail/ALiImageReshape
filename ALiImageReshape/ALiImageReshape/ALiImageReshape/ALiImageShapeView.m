//
//  ALiImageShapeView.m
//  ALiImageReshape
//
//  Created by LeeWong on 2016/10/29.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImageShapeView.h"

@implementation ALiImageShapeView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:self.bounds];
    
    [clipPath appendPath:self.shapePath];
    for (UIBezierPath *path in self.shapePaths) {
        [clipPath appendPath:path];
    }
    
    clipPath.usesEvenOddFillRule = YES;
    [clipPath addClip];
    
    if (!self.coverColor) {
        self.coverColor = [UIColor blackColor];
        CGContextSetAlpha(context, 0.7f);
    }
    [self.coverColor setFill];
    [clipPath fill];
}

@end
