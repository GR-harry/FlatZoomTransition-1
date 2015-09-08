
//
//  FlatZoomPushTransition.m
//  视图控制器过渡1
//
//  Created by GR on 15/9/8.
//  Copyright (c) 2015年 GR. All rights reserved.
//

#import "FlatZoomPushTransition.h"
#import "FirstCollectionViewController.h"
#import "SecondViewController.h"
#import "FirstCellCollectionViewCell.h"

@implementation FlatZoomPushTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8f;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 1. 获取源和目标控制器
    FirstCollectionViewController *fromVc = (FirstCollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    SecondViewController *toVc = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    // 2. 将cell中的imageView截图，并对截图设置frame
    // 1) 找到选中的cell
    NSIndexPath *seletedIndexPath = [[fromVc.collectionView indexPathsForSelectedItems] firstObject];
    // pop时会用到
    fromVc.seletedIndexPath = seletedIndexPath;
    FirstCellCollectionViewCell *cell = (FirstCellCollectionViewCell *)[fromVc.collectionView cellForItemAtIndexPath:seletedIndexPath];
    // 2) 截图
    UIView *snapShotView = [cell.imageInCell snapshotViewAfterScreenUpdates:NO];
    cell.imageInCell.hidden = YES;
    // 3) 转换坐标系
    CGRect snapShotFrame = [containerView convertRect:cell.imageInCell.frame fromView:cell];
    snapShotView.frame = snapShotFrame;
    
    // 3. 设置目标控制器的view的初始状态
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    toVc.view.alpha = 0.0f;
    toVc.imageInSecond.hidden = YES;
    
    // 注意顺序
    [containerView addSubview:toVc.view];
    [containerView addSubview:snapShotView];
    
    // 4. 动画
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    CGRect snapShotFinialFrame = [containerView convertRect:toVc.imageInSecond.frame fromView:toVc.view];
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         snapShotView.frame = snapShotFinialFrame;
                         toVc.view.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         cell.imageInCell.hidden = NO;
                         toVc.imageInSecond.hidden = NO;
                         [snapShotView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}
@end
