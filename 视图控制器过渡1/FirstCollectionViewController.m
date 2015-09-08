//
//  FirstCollectionViewController.m
//  视图控制器过渡1
//
//  Created by GR on 15/9/8.
//  Copyright (c) 2015年 GR. All rights reserved.
//

#import "FirstCollectionViewController.h"
#import "FirstCellCollectionViewCell.h"
#import "SecondViewController.h"
#import "FlatZoomPushTransition.h"
#import "FlatZoomInteractivePopTransition.h"

@interface FirstCollectionViewController () <UINavigationControllerDelegate>

@end

@implementation FirstCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UICollectionViewFlowLayout *flowLY = [[UICollectionViewFlowLayout alloc] init];
    flowLY.itemSize = CGSizeMake(screenWidth * 0.47, 240);
    flowLY.minimumInteritemSpacing = 1;
    return [super initWithCollectionViewLayout:flowLY];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"NavigationBar";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FirstCellCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"collectionView viewWillAppear");
    self.navigationController.delegate = self;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FirstCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SecondViewController *secondVc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondVc animated:YES];
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        FlatZoomPushTransition *pushTransition = [[FlatZoomPushTransition alloc] init];
        return pushTransition;
    }
    return nil;
}

- (void)dealloc
{
    NSLog(@"firstCollectionView dead");
}
@end
