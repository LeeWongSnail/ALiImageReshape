//
//  AliImageReshapeController.h
//  ALiImageReshape
//
//  Created by LeeWong on 2016/10/29.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AliImageReshapeController;

@protocol ALiImageReshapeDelegate <NSObject>

- (void)imageReshaperControllerDidCancel:(AliImageReshapeController *)reshaper;

- (void)imageReshaperController:(AliImageReshapeController *)reshaper didFinishPickingMediaWithInfo:(UIImage *)image;

@end


@interface AliImageReshapeController : UIViewController

@property (nonatomic, strong) UIImage *sourceImage;

@property (nonatomic, assign) CGFloat reshapeScale; //宽高比

@property (nonatomic, weak) id <ALiImageReshapeDelegate> delegate;

@end
