//
//  ViewController.m
//  ZYPageControllerDemo
//
//  Created by Daniel Chuang on 2019/2/18.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "ViewController.h"
#import "ZYTabView.h"
#import "ZYPageCardController.h"

@interface ViewController ()<ZYTabViewDelegate,ZYPageCardControllerDelegate>
@property (nonatomic,strong)ZYTabViwe *topView;
@property (nonatomic,strong) ZYPageCardController *pageVC;
@property (nonatomic,copy) NSArray *subViewControllers;
@property (nonatomic,assign) CGFloat startOffsetX;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat topViewH = 30;
    
    self.topView = [[ZYTabViwe alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, topViewH) titlesArray:@[@"啊啊",@"啊啊啊",@"啊啊啊啊",@"啊啊",@"啊啊啊"]];
    self.topView.lineBackgroundColor = [UIColor cyanColor];
    //topView.imagesArray = @[@"mine_authen",@"mine_authen",@"mine_authen",@"mine_authen",@"mine_authen"];
    self.topView.delegate = self;
    [self.topView initalUI];
    [self.view addSubview:self.topView];
    
    UIViewController *listVC1 = [UIViewController new];
    UIViewController *listVC2 = [UIViewController new];
    UIViewController *listVC3 = [UIViewController new];
    UIViewController *listVC4 = [UIViewController new];
    UIViewController *listVC5 = [UIViewController new];
    
    listVC1.view.backgroundColor = [UIColor redColor];
    listVC2.view.backgroundColor = [UIColor yellowColor];
    listVC3.view.backgroundColor = [UIColor blueColor];
    listVC4.view.backgroundColor = [UIColor purpleColor];
    listVC5.view.backgroundColor = [UIColor greenColor];
    
    _subViewControllers = @[listVC1,listVC2,listVC3,listVC4,listVC5];
    
    UIView *contentView = [[UIView alloc] initWithFrame:
                           CGRectMake(0, topViewH+44, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:contentView];
    _pageVC = [ZYPageCardController new];
    _pageVC.delegate = self;
    _pageVC.totalCount = _subViewControllers.count;
    _pageVC.currentIndex = 0;
    
    [_pageVC setupParentView:contentView andParentViewController:self];
    
}

#pragma mark -- ZYPageCardControllerDelegate
// 手滑动viewController回调
- (void)scrollPageDidScrollTo:(NSInteger)index {
    self.startOffsetX = _pageVC.collectionView.contentOffset.x;
}

- (void)scrollPageScrollPercent:(CGFloat)percent toNext:(BOOL)next {
    if (_pageVC.collectionView.isDragging || _pageVC.collectionView.isDecelerating) {
        [self.topView externalScrollView:_pageVC.collectionView totalPage:5 startOffsetX:self.startOffsetX];
    }
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    return _subViewControllers[index];
}

#pragma mark -- ZYTabViewDelegate
- (void)pageViewSelectdIndex:(NSInteger)index {
    [_pageVC setCurrentIndex:index animated:true newViewController:nil];
}

@end
