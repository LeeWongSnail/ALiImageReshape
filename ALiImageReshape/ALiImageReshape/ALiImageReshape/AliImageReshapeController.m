//
//  AliImageReshapeController.m
//  ALiImageReshape
//
//  Created by LeeWong on 2016/10/29.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "AliImageReshapeController.h"
#import "ALiImageShapeView.h"
#import "UIImage+ALi.h"

@interface AliImageReshapeController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *frameView;
@property (nonatomic, strong) ALiImageShapeView *shapeView;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation AliImageReshapeController

#pragma mark - Custom Method



- (void)cancelDidClick
{
    if ([self.delegate respondsToSelector:@selector(imageReshaperControllerDidCancel:)]) {
        [self.delegate imageReshaperControllerDidCancel:self];
    }
}

- (void)selectDidClick
{
    if ([self.delegate respondsToSelector:@selector(imageReshaperController:didFinishPickingMediaWithInfo:)]) {
        [self.delegate imageReshaperController:self didFinishPickingMediaWithInfo:self.shapeImage];
    }
}

#pragma mark - Load View

- (void)configUI
{
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.bounds;
    [self.view addSubview:self.frameView];
    self.frameView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width / self.scale);
    self.frameView.center = self.view.center;
    [self.view addSubview:self.shapeView];
    self.shapeView.frame = self.view.bounds;
    [self.view addSubview:self.cancelButton];
    self.cancelButton.frame = CGRectMake(15, [UIScreen mainScreen].bounds.size.height - 50, 50, 25);
    [self.view bringSubviewToFront:self.cancelButton];
    [self.view addSubview:self.selectButton];
    self.selectButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - 15, self.cancelButton.frame.origin.y, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
    [self.view bringSubviewToFront:self.selectButton];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)layoutScrollView
{
    self.imageView.image = self.sourceImage;
    self.imageView.frame = CGRectMake(0, 0, self.sourceImage.size.width, self.sourceImage.size.height);
    
    CGSize imageSize = self.sourceImage.size;
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = imageSize;
    [self.scrollView addSubview:self.imageView];
    
    CGFloat scale = 0.0f;
    
    // 计算 图片适应屏幕的 size
    CGSize cropBoxSize = self.frameView.bounds.size;
    
    //以cropboxsize 宽或者高最大的那个为基准
    scale = MAX(cropBoxSize.width/imageSize.width, cropBoxSize.height/imageSize.height);
    
    //按照比例算出初次展示的尺寸
    CGSize scaledSize = (CGSize){floorf(imageSize.width * scale), floorf(imageSize.height * scale)};
    
    //配置scrollview
    self.scrollView.minimumZoomScale = scale;
    self.scrollView.maximumZoomScale = 5.0f;
    
    //初始缩放系数
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    self.scrollView.contentSize = scaledSize;
    
    CGRect cropBoxFrame = self.frameView.frame;
    //调整位置 使其居中
    if (cropBoxFrame.size.width < scaledSize.width - FLT_EPSILON || cropBoxFrame.size.height < scaledSize.height - FLT_EPSILON) {
        CGPoint offset = CGPointZero;
        offset.x = -floorf((CGRectGetWidth(self.scrollView.frame) - scaledSize.width) * 0.5f);
        offset.y = -floorf((CGRectGetHeight(self.scrollView.frame) - scaledSize.height) * 0.5f);
        self.scrollView.contentOffset = offset;
    }
    
    // 以cropBoxFrame为基准设施 scrollview 的insets 使其与cropBoxFrame 匹配 防止 缩放时突变回顶部
    self.scrollView.contentInset = (UIEdgeInsets){CGRectGetMinY(cropBoxFrame),
        CGRectGetMinX(cropBoxFrame),
        CGRectGetMaxY(self.view.bounds) - CGRectGetMaxY(cropBoxFrame),
        CGRectGetMaxX(self.view.bounds) - CGRectGetMaxX(cropBoxFrame)};
}

//最后裁剪时图片位置确定
- (CGRect)imageCropFrame
{
    CGSize imageSize = self.imageView.image.size;
    CGSize contentSize = self.scrollView.contentSize;
    CGRect cropBoxFrame = self.frameView.frame;
    CGPoint contentOffset = self.scrollView.contentOffset;
    UIEdgeInsets edgeInsets = self.scrollView.contentInset;
    
    CGRect frame = CGRectZero;
    frame.origin.x = floorf((contentOffset.x + edgeInsets.left) * (imageSize.width / contentSize.width));
    frame.origin.x = MAX(0, frame.origin.x);
    
    frame.origin.y = floorf((contentOffset.y + edgeInsets.top) * (imageSize.height / contentSize.height));
    frame.origin.y = MAX(0, frame.origin.y);
    
    frame.size.width = ceilf(cropBoxFrame.size.width * (imageSize.width / contentSize.width));
    frame.size.width = MIN(imageSize.width, frame.size.width);
    
    frame.size.height = ceilf(cropBoxFrame.size.height * (imageSize.height / contentSize.height));
    frame.size.height = MIN(imageSize.height, frame.size.height);
    
    return frame;
}

#pragma mark - Life Cylce
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self layoutScrollView];
    
    self.shapeView.shapePath = [UIBezierPath bezierPathWithRect:self.frameView.frame];
    self.shapeView.coverColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.shapeView setNeedsDisplay];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - Lazy Load

- (UIImage *)shapeImage
{
    return [self.imageView.image croppedImageWithFrame:[self imageCropFrame]];
}

- (CGFloat)scale
{
    return self.reshapeScale == 0? 1 : self.reshapeScale;
}

- (UIScrollView *)scrollView
{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if(!_imageView){
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}


- (UIImageView *)frameView
{
    if(!_frameView){
        _frameView = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:@"icon_frame"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        _frameView.image = image;
        _frameView.backgroundColor = [UIColor clearColor];
    }
    return _frameView;
}

- (ALiImageShapeView *)shapeView
{
    if(!_shapeView){
        _shapeView = [[ALiImageShapeView alloc] init];
        _shapeView.backgroundColor = [UIColor clearColor];
        _shapeView.coverColor = [UIColor colorWithWhite:0. alpha:0.5];
        _shapeView.userInteractionEnabled = NO;
        [self.view addSubview:_shapeView];
    }
    return _shapeView;
}

- (UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UIButton *)selectButton
{
    if (_selectButton == nil) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setTitle:@"使用" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_selectButton];
    }
    return _selectButton;
}


@end
