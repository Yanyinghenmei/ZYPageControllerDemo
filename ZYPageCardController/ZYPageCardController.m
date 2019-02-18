//
//  ZYPageCardController.m
//  PageCardControllerDemo
//
//  Created by Daniel on 16/7/15.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYPageCardController.h"


// cell
@interface PageCell : UICollectionViewCell

@property (weak, nonatomic) UIViewController * pageViewController;

@property (weak, nonatomic) UIView * pageView;

@end

@implementation PageCell

@end


@interface ZYPageCardController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) UIView * parentView;

@property (nonatomic) NSMutableDictionary * vcDict;

@property (nonatomic) BOOL goingNext;

@end

@implementation ZYPageCardController

- (void)loadView {
    [super loadView];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.headerReferenceSize = CGSizeZero;
    layout.footerReferenceSize = CGSizeZero;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.scrollsToTop = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    self.view = _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _vcDict = [NSMutableDictionary dictionary];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[PageCell class] forCellWithReuseIdentifier:@"PageCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [_vcDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        UIViewController * vc = obj;
        [vc removeFromParentViewController];
    }];
    [_vcDict removeAllObjects];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = _collectionView.contentOffset.x;
    CGFloat width = _collectionView.bounds.size.width;
    NSInteger index = (NSInteger)offsetX/(NSInteger)width;
    
    _currentIndex = index;
    if ([self.delegate respondsToSelector:@selector(scrollPageDidScrollTo:)]) {
        [self.delegate scrollPageDidScrollTo:self.currentIndex];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != _collectionView) {
        return;
    }
    
    CGFloat offsetX = _collectionView.contentOffset.x;
    CGFloat width = _collectionView.bounds.size.width;
    CGFloat percent = (NSInteger)offsetX%(NSInteger)width/width;
    NSInteger index = (NSInteger)offsetX/(NSInteger)width;
    
    //NSLog(@"%ld %f", index, percent);
    CGPoint velocity = [_collectionView.panGestureRecognizer velocityInView:_collectionView];
    //NSLog(@"%@", NSStringFromCGPoint(velocity));
    if (velocity.x < 0) {
        _goingNext = YES;
    }
    if (velocity.x > 0) {
        _goingNext = NO;
    }
    if (percent == 0 && velocity.x == 0) {
        _currentIndex = index;
        if ([self.delegate respondsToSelector:@selector(scrollPageDidScrollTo:)]) {
            [self.delegate scrollPageDidScrollTo:self.currentIndex];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(scrollPageScrollPercent:toNext:)]) {
        if (!_goingNext) {
            percent = 1 - percent;
        }
        [self.delegate scrollPageScrollPercent:percent toNext:_goingNext];
    }
}

- (void)setupParentView:(UIView *)view andParentViewController:(UIViewController *)parentViewController {
    self.parentView = view;
    [parentViewController addChildViewController:self];
    [view addSubview:self.view];
    [self didMoveToParentViewController:parentViewController];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    [view addConstraints:@[top, left, bottom, right]];
    
}

- (void)setTotalCount:(NSUInteger)totalCount {
    _totalCount = totalCount;
    [_collectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    [self setCurrentIndex:currentIndex animated:NO newViewController:nil];
}

- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated newViewController:(UIViewController *)vc {
    _currentIndex = currentIndex;
    if (vc) {
        [_vcDict setObject:vc forKey:@(_currentIndex)];
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totalCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PageCell" forIndexPath:indexPath];
    
    UIViewController * vc = _vcDict[@(indexPath.item)];
    if (!vc) {
        vc = [self.delegate viewControllerAtIndex:indexPath.item];
        [_vcDict setObject:vc forKey:@(indexPath.item)];
    }
    cell.pageViewController = vc;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    PageCell * pageCell = (PageCell *)cell;
    [self addChildViewController:pageCell.pageViewController];
    pageCell.pageView = pageCell.pageViewController.view;
    pageCell.pageView.frame = cell.bounds;
    [pageCell.contentView addSubview:pageCell.pageView];
    [pageCell.pageViewController didMoveToParentViewController:self];

    // addChildViewController: will call [child willMoveToParentViewController:self] before adding the child. However, it will not call didMoveToParentViewController
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    PageCell * pageCell = (PageCell *)cell;
    [pageCell.pageViewController willMoveToParentViewController:nil];
    [pageCell.pageView removeFromSuperview];
    [pageCell.pageViewController removeFromParentViewController];
}


@end

