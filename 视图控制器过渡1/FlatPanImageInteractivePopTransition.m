//
//  FlatPanImageInteractivePopTransition.m
//  视图控制器过渡1
//
//  Created by GR on 15/9/8.
//  Copyright (c) 2015年 GR. All rights reserved.
//

#import "FlatPanImageInteractivePopTransition.h"
#import "FirstCollectionViewController.h"
#import "SecondViewController.h"
#import "FirstCellCollectionViewCell.h"

@interface FlatPanImageInteractivePopTransition ()
@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, assign) FirstCellCollectionViewCell *selectedCell;
@property (nonatomic, assign) UIView *sanpShotView;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> contextTransition;

@property (nonatomic, assign) CGPoint lastPoint;
// 记录手指移动的距离
@property (nonatomic, assign) CGPoint changePoint;
@end

@implementation FlatPanImageInteractivePopTransition
- (instancetype)initWithController:(UIViewController *)vc
{
    if (self = [super init]) {
        SecondViewController *secondVc = (SecondViewController *)vc;
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [secondVc.imageInSecond addGestureRecognizer:panGestureRecognizer];
        self.vc = vc;
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    // 计算移动距离
    CGFloat distance = sqrtf(translation.x * translation.x + translation.y * translation.y);
    // 200是比例基数，可根据需要设置
    CGFloat progress = distance / 200;
    // 向上移动才有效
    progress = translation.y > 0 ? 0 : MIN(progress, 1.0f);
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        self.interactiving = YES;
        
        // 记录初始手指位置
        self.lastPoint = [panGestureRecognizer locationInView:panGestureRecognizer.view];
        
        [self.vc.navigationController popViewControllerAnimated:YES];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint currentPoint = [panGestureRecognizer locationInView:panGestureRecognizer.view];
        // 手指的位移
        self.changePoint = CGPointMake(currentPoint.x - self.lastPoint.x, currentPoint.y - self.lastPoint.y);
        self.lastPoint = currentPoint;
        [self updateInteractiveTransition:progress];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateCancelled)
    {
        self.interactiving = NO;
        [self cancelInteractiveTransition];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        self.interactiving = NO;
        if (progress > 0.5f) {
            [self finishInteractiveTransition];
        } else {
            [self cancelInteractiveTransition];
        }
    }
}


- (SecondViewController *)fromVc
{
    return (SecondViewController *)[self.contextTransition viewControllerForKey:UITransitionContextFromViewControllerKey];
}
- (FirstCollectionViewController *)toVc
{
    return (FirstCollectionViewController *)[self.contextTransition viewControllerForKey:UITransitionContextToViewControllerKey];
}
- (UIView *)containerView
{
    return [self.contextTransition containerView];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.contextTransition = transitionContext;
    
    // 1. 获取源和目标控制器
    SecondViewController *fromVc = [self fromVc];
    FirstCollectionViewController *toVc = [self toVc];
    UIView *containerView = [self containerView];
    
    // 2. 截图，并初始化截图状态
    UIView *sanpShotView = [fromVc.imageInSecond snapshotViewAfterScreenUpdates:NO];
    self.sanpShotView = sanpShotView;
    sanpShotView.frame = [containerView convertRect:fromVc.imageInSecond.frame fromView:fromVc.view];
    fromVc.imageInSecond.hidden = YES;
    
    // 3. 初始化目标控制器的状态
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    FirstCellCollectionViewCell *cell = (FirstCellCollectionViewCell *)[toVc.collectionView cellForItemAtIndexPath:toVc.seletedIndexPath];
    self.selectedCell = cell;
    cell.imageInCell.hidden = YES;
    
    [containerView insertSubview:toVc.view belowSubview:fromVc.view];
    [containerView addSubview:sanpShotView];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    [super updateInteractiveTransition:percentComplete];
    
    // 1. 淡化当前视图控制器的view
    SecondViewController *fromVc = [self fromVc];
    fromVc.view.alpha = 1 - percentComplete;
    
    // 2. 随手指移动截图
    self.sanpShotView.transform = CGAffineTransformTranslate(self.sanpShotView.transform, self.changePoint.x, self.changePoint.y);
    
}

- (void)cancelInteractiveTransition
{
    [super cancelInteractiveTransition];
    
    [UIView animateWithDuration:self.duration
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.sanpShotView.transform = CGAffineTransformIdentity;
                         self.fromVc.view.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         self.fromVc.imageInSecond.hidden = NO;
                         self.selectedCell.imageInCell.hidden = NO;
                         [self.sanpShotView removeFromSuperview];
                         [self.contextTransition completeTransition:NO];
                     }];
}

- (void)finishInteractiveTransition
{
    [super finishInteractiveTransition];
    
    // 截图收缩到被点击的cell的位置
    CGRect finialFrame = [self.containerView convertRect:self.selectedCell.imageInCell.frame fromView:self.selectedCell];
    [UIView animateWithDuration:self.duration
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.fromVc.view.alpha = 0.0f;
                         self.sanpShotView.frame = finialFrame;
                     } completion:^(BOOL finished) {
                         self.selectedCell.imageInCell.hidden = NO;
                         [self.sanpShotView removeFromSuperview];
                         [self.contextTransition completeTransition:YES];
                     }];
}

- (CGFloat)duration
{
    return 0.5;
}
@end
