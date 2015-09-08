//
//  FlatPanImageInteractivePopTransition.h
//  视图控制器过渡1
//
//  Created by GR on 15/9/8.
//  Copyright (c) 2015年 GR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlatPanImageInteractivePopTransition : UIPercentDrivenInteractiveTransition
- (instancetype)initWithController:(UIViewController *)vc;
@property (nonatomic, assign) BOOL interactiving;
@end
