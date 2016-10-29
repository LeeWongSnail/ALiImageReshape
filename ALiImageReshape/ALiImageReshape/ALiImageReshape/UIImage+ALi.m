//
//  UIImage+ALi.m
//  ALiImageReshape
//
//  Created by LeeWong on 2016/10/29.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "UIImage+ALi.h"

@implementation UIImage (ALi)

- (BOOL)hasAlpha
{
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    return (alphaInfo == kCGImageAlphaFirst || alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst || alphaInfo == kCGImageAlphaPremultipliedLast);
}

- (UIImage *)croppedImageWithFrame:(CGRect)frame
{
    UIImage *croppedImage = nil;
    UIGraphicsBeginImageContextWithOptions(frame.size, ![self hasAlpha], self.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(context, -frame.origin.x, -frame.origin.y);
        [self drawAtPoint:CGPointZero];
        
        croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:croppedImage.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}


@end
