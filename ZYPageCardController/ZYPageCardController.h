//
//  ZYPageCardController.h
//  PageCardControllerDemo
//
//  Created by Daniel on 16/7/15.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZYPageCardControllerDelegate <NSObject>

- (UIViewController *)viewControllerAtIndex:(NSInteger)index;

@optional
- (void)scrollPageScrollPercent:(CGFloat)percent toNext:(BOOL)next;
- (void)scrollPageDidScrollTo:(NSInteger)index;
@end


@interface ZYPageCardController : UIViewController

@property (nonatomic) UICollectionView * collectionView;

@property (nonatomic) NSInteger currentIndex;

@property (nonatomic) NSUInteger totalCount;

@property (nonatomic, weak) id<ZYPageCardControllerDelegate> delegate;

/**
 *  作为子控制器添加到父控制器上
 *
 *  @param view                  [view addSubView:self.view]
 *  @param parentViewController [parentViewController addChildViewController:self];
 */
- (void)setupParentView:(UIView *)view andParentViewController:(UIViewController *)parentViewController;

- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated newViewController:(UIViewController *)vc;

@end
