//
//  SecondViewController.m
//  视图控制器过渡1
//
//  Created by GR on 15/9/8.
//  Copyright (c) 2015年 GR. All rights reserved.
//

#import "SecondViewController.h"
#import "FlatZoomPopTransition.h"
#import "FlatZoomInteractivePopTransition.h"
#import "FlatPanImageInteractivePopTransition.h"

@interface SecondViewController () <UINavigationControllerDelegate>
@property (nonatomic, strong) FlatZoomInteractivePopTransition *popInteractiveTransition;
@property (nonatomic, strong) FlatPanImageInteractivePopTransition *panTransition;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Detail";
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"500.jpg"];
    imageView.center = CGPointMake(self.view.center.x, 200);
    imageView.bounds = CGRectMake(0, 0, 250, 250);
    [self.view addSubview:imageView];
    self.imageInSecond = imageView;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = @"我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子我需要一段很长的句子";
    label.textColor = [UIColor blackColor];
    CGFloat y = CGRectGetMaxY(imageView.frame);
    CGFloat h = self.view.frame.size.height - y;
    CGFloat x = 10;
    CGFloat w = self.view.frame.size.width - 2 * x;
    label.frame = CGRectMake(x, y, w, h);
    [self.view addSubview:label];
    
//    self.popInteractiveTransition = [[FlatZoomInteractivePopTransition alloc] initWithController:self];
    self.panTransition = [[FlatPanImageInteractivePopTransition alloc] initWithController:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"secondView viewWillAppear");
    self.navigationController.delegate = self;
}
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        FlatZoomPopTransition *popTransition = [[FlatZoomPopTransition alloc] init];
        return popTransition;
    }
    return nil;
}
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([animationController isKindOfClass:[FlatZoomPopTransition class]]) {
//        return self.popInteractiveTransition.interactiving ? self.popInteractiveTransition : nil;
        return self.panTransition.interactiving ? self.panTransition : nil;
    }
    
    return nil;
}

- (void)dealloc
{
    NSLog(@"secondView dead");
}
@end
