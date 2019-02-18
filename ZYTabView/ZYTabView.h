//
//  ZYTabView.h
//  ZYPageControllerDemo
//
//  Created by Daniel Chuang on 2019/2/18.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZYTabViewDelegate <NSObject>

- (void)pageViewSelectdIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYTabViwe : UIView

@property (nonatomic ,weak) id <ZYTabViewDelegate> delegate;

/**
 图片数组，可不传
 **/
@property (nonatomic ,strong) NSArray *imagesArray;
@property (nonatomic ,strong) UIColor *titleColor;
@property (nonatomic ,strong) UIFont  *titleFont;


/**
 have default value
 */
@property (nonatomic ,strong) UIColor *lineBackgroundColor;
@property (nonatomic,assign) CGFloat lineHeight;
@property (nonatomic,assign) CGFloat lineBottomGap;
@property (nonatomic,assign) CGFloat gapBetweenImageViewAndLabel;
@property (nonatomic,assign) CGFloat unitImageWidth;
@property (nonatomic,assign) CGFloat unitImageHeight;
@property (nonatomic,assign) CGFloat margin;

/**
 titlesArray:标题数组，不能为空
 imagesArray:图片数组，可为空
 **/
- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray;

/**
 创建子视图
 **/
- (void)initalUI;

/**
 scrollView:外部滚动视图
 totalPage:外部滚动视图总页数
 startOffsetX:每次开始拖拽的起始点位
 
 注意：需要在外部滚动视图代理scrollViewDidScroll不停调用
 **/
- (void)externalScrollView:(UIScrollView *)scrollView totalPage:(NSInteger)totalPage startOffsetX:(CGFloat)startOffsetX;

@end

NS_ASSUME_NONNULL_END
