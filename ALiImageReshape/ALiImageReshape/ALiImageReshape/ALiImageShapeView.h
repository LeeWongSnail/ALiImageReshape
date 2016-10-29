//
//  ALiImageShapeView.h
//  ALiImageReshape
//
//  Created by LeeWong on 2016/10/29.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALiImageShapeView : UIView

@property (nonatomic, strong) UIBezierPath *shapePath;

@property (nonatomic, strong) NSArray<UIBezierPath *> *shapePaths;

@property (nonatomic, strong) UIColor *coverColor; // default is black, alpha 0.7

@end
