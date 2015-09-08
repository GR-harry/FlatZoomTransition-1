//
//  FlatZoomPopTransition.m
//  视图控制器过渡1
//
//  Created by GR on 15/9/8.
//  Copyright (c) 2015年 GR. All rights reserved.
//

#import "FlatZoomPopTransition.h"
#import "FirstCollectionViewController.h"
#import "SecondViewController.h"
#import "FirstCellCollectionViewCell.h"

@implementation FlatZoomPopTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 1. 获取源和目标控制器
    SecondViewController *fromVc = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    FirstCollectionViewController *toVc = (FirstCollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    // 2. 截图，并设置截图在containerView中的frame
    UIView *snapShotView = [fromVc.imageInSecond snapshotViewAfterScreenUpdates:NO];
    fromVc.imageInSecond.hidden = YES;
    CGRect currentFrame = [containerView convertRect:fromVc.imageInSecond.frame fromView:fromVc.view];
    snapShotView.frame = currentFrame;
    
    // 3. 设置目标控制器的初始状态
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    // 1). 获取cell隐藏图片
    FirstCellCollectionViewCell *cell =(FirstCellCollectionViewCell *)[toVc.collectionView cellForItemAtIndexPath:toVc.seletedIndexPath];
    cell.imageInCell.hidden = YES;
    
    // 注意放置顺序
    [containerView insertSubview:toVc.view belowSubview:fromVc.view];
    [containerView addSubview:snapShotView];
    
    // 4. 动画
    CGRect finialFrame = [containerView convertRect:cell.imageInCell.frame fromView:cell];
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         fromVc.view.alpha = 0.0f;
                         snapShotView.frame = finialFrame;
                     }
                     completion:^(BOOL finished) {
                         cell.imageInCell.hidden = NO;
                         fromVc.imageInSecond.hidden = NO;
                         [snapShotView removeFromSuperview];
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}
@end
