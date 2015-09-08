
//
//  FlatZoomInteractivePopTransition.m
//  视图控制器过渡1
//
//  Created by GR on 15/9/8.
//  Copyright (c) 2015年 GR. All rights reserved.
//

#import "FlatZoomInteractivePopTransition.h"
@interface FlatZoomInteractivePopTransition ()
@property (nonatomic, strong) UIViewController *vc;
@end

@implementation FlatZoomInteractivePopTransition
- (instancetype)initWithController:(UIViewController *)vc
{
    if (self = [super init]) {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [vc.view addGestureRecognizer:panGestureRecognizer];
        self.vc = vc;
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    // 手指横向移动距离
    CGFloat translationx = [panGestureRecognizer translationInView:panGestureRecognizer.view].x;
    // 手势完成度
    CGFloat complatedRation = translationx / (screenWidth * 1);
    // 将比例限制在0~1之间
    complatedRation = MIN(1.0, MAX(0.0, complatedRation));
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        self.interactiving = YES;
        [self.vc.navigationController popViewControllerAnimated:YES];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        // 告知系统汇报进度
        [self updateInteractiveTransition:complatedRation];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateCancelled)
    {
        self.interactiving = NO;
        // 告知系统取消过渡
        [self cancelInteractiveTransition];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        self.interactiving = NO;
        // 手指从屏幕抬起时，手势进行一半即可认为是完成过渡，反则取消过渡
        if (complatedRation > 0.5) {
            [self finishInteractiveTransition];
        } else {
            [self cancelInteractiveTransition];
        }
    }}
@end
