//
//  ZYTabView.m
//  ZYPageControllerDemo
//
//  Created by Daniel Chuang on 2019/2/18.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "ZYTabView.h"

#define SelectAlpha 1.0f
#define NormalAlpha 0.4f

#define SelectScale 1.0f
#define NormalScale 0.98f

static const NSInteger kBastTag          = 100;

@interface ZYTabViwe ()
@property (nonatomic ,strong) UIScrollView *itemScrollView;
@property (nonatomic ,strong) NSArray      *titlesArray;
@property (nonatomic ,strong) UIView       *lineView;
@property (nonatomic ,assign) BOOL         isHaveImages;
@end

@implementation ZYTabViwe

- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titlesArray = titlesArray;
        
        self.margin = 15;
        self.lineHeight = 4;
        self.lineBottomGap = 0;
        self.gapBetweenImageViewAndLabel = 5;
        self.unitImageWidth = 15.0f;
        self.unitImageHeight = 15.0f;
        
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:16.f];
        
        self.lineBackgroundColor = [UIColor redColor];
        
        self.isHaveImages = NO;
    }
    return self;
}

- (void)initalUI
{
    // 所有item总长度
    CGFloat totalWidth = 0.f;
    
    for (NSInteger i = 0; i < self.titlesArray.count; i++) {
        NSString *title = self.titlesArray[i];
        CGFloat titleWidth = widthForValue(title, self.titleFont, self.frame.size.height);
        if (self.isHaveImages) {
            totalWidth += titleWidth + self.unitImageWidth + self.gapBetweenImageViewAndLabel;
        } else {
            totalWidth += titleWidth;
        }
    }
    
    CGFloat gap = (self.frame.size.width-totalWidth-self.margin*2)/(self.titlesArray.count-1);
    // 如果屏幕放不下, 就可以滚动
    if (gap < 15) {
        gap = 15;
    }
    
    self.itemScrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.itemScrollView.center = CGPointMake(CGRectGetWidth(self.frame)/2.f, self.itemScrollView.center.y);
    self.itemScrollView.showsHorizontalScrollIndicator = NO;
    self.itemScrollView.backgroundColor = self.backgroundColor;
    [self addSubview:self.itemScrollView];
    
    //起点位置
    CGFloat startX = self.margin;
    for (NSInteger i = 0; i < self.titlesArray.count; i++) {
        CGFloat titleWidth = widthForValue(self.titlesArray[i], self.titleFont, self.frame.size.height);
        CGFloat unitW = 0;
        if (self.isHaveImages) {
            unitW = titleWidth + self.unitImageWidth + self.gapBetweenImageViewAndLabel;
        } else {
            unitW = titleWidth;
        }
        
        // unit view
        UIView *unitView = [[UIView alloc] initWithFrame:CGRectMake(startX, 0, unitW, self.frame.size.height)];
        if (i == 0) {
            unitView.alpha = SelectAlpha;
            unitView.layer.transform = CATransform3DMakeScale(SelectScale, SelectScale, 1);
        } else {
            unitView.alpha = NormalAlpha;
            unitView.layer.transform = CATransform3DMakeScale(NormalScale, NormalScale, 1);
        }
        unitView.userInteractionEnabled = true;
        unitView.tag = kBastTag + i;
        [self.itemScrollView addSubview:unitView];
        
        UIImageView *imageView = nil;
        UILabel *titleLabel = nil;
        if (self.isHaveImages) {
            // iamgeview
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-self.unitImageHeight)/2, self.unitImageWidth, self.unitImageHeight)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = [UIImage imageNamed:self.imagesArray[i]];
            [unitView addSubview:imageView];
            
            // label
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.unitImageWidth + self.gapBetweenImageViewAndLabel, 0, titleWidth, self.frame.size.height)];
        } else {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, self.frame.size.height)];
        }
        
        
        titleLabel.textColor = self.titleColor;
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.userInteractionEnabled = YES;
        titleLabel.text = self.titlesArray[i];
        titleLabel.font = self.titleFont;
        
        [unitView addSubview:titleLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapGesture:)];
        [unitView addGestureRecognizer:tapGesture];
        
        startX += (unitW + gap);
        
        if (i == 0) {
            self.lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(unitView.frame), self.frame.size.height - self.lineBottomGap-self.lineHeight, unitW, self.lineHeight)];
            self.lineView.layer.masksToBounds = YES;
            self.lineView.layer.cornerRadius = self.lineHeight/2.0;
            [self.lineView setBackgroundColor:self.lineBackgroundColor];
            [self.itemScrollView insertSubview:self.lineView atIndex:0];
        }
        
        if (i == self.titlesArray.count-1) {
            self.itemScrollView.contentSize = CGSizeMake(CGRectGetMaxX(unitView.frame)+self.margin, self.frame.size.height);
        }
    }
}

- (void)changeAlpha:(UIView *)view {
    for (NSInteger y = 0; y < self.titlesArray.count; y++) {
        UILabel *tempView = (UILabel *)[self.itemScrollView viewWithTag:kBastTag + y];
        
        if (y == view.tag - kBastTag) {
            tempView.alpha = SelectAlpha;
            tempView.layer.transform = CATransform3DMakeScale(SelectScale, SelectScale, 1);
        } else {
            tempView.alpha = NormalAlpha;
            tempView.layer.transform = CATransform3DMakeScale(NormalScale, NormalScale, 1);
        }
    }
}

CGFloat widthForValue(NSString *value, UIFont *font, CGFloat height) {
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return sizeToFit.size.width;
}

- (CGRect)lineFrameWithUnitView:(UIView *)view {
    return CGRectMake(CGRectGetMinX(view.frame), CGRectGetMinY(self.lineView.frame), view.frame.size.width, self.lineHeight);
}

- (void)externalScrollView:(UIScrollView *)scrollView totalPage:(NSInteger)totalPage startOffsetX:(CGFloat)startOffsetX
{
    //滚动的百分比
    CGFloat progress = 0;
    
    //初始Index
    NSInteger sourceIndex = 0;
    
    //目标Index
    NSInteger targetIndex = 0;
    
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    
    //左滑
    if (currentOffsetX > startOffsetX)
    {
        progress = currentOffsetX / scrollViewW - floorf(currentOffsetX / scrollViewW);
        sourceIndex = (NSInteger)(currentOffsetX / scrollViewW);
        targetIndex = sourceIndex + 1;
        
        if (targetIndex >= totalPage)
        {
            targetIndex = totalPage - 1;
        }
        
        if (currentOffsetX - startOffsetX == scrollViewW)
        {
            progress = 1;
            targetIndex = sourceIndex;
            
            //目标Label
            UIView *targetView = [self.itemScrollView viewWithTag:kBastTag + targetIndex];
            CGFloat targetMaxX = CGRectGetMaxX(targetView.frame);
            
            [self changeAlpha:targetView];
            
            if (targetMaxX > self.itemScrollView.contentOffset.x + self.itemScrollView.bounds.size.width)
            {
                [self.itemScrollView setContentOffset:CGPointMake(targetMaxX - self.itemScrollView.bounds.size.width, 0.f) animated:YES];
            }
        }
    }
    //右滑
    else
    {
        progress = 1 - (currentOffsetX / scrollViewW - floorf(currentOffsetX / scrollViewW));
        targetIndex = (NSInteger)(currentOffsetX / scrollViewW);
        sourceIndex = targetIndex + 1;
        
        //scrollView的页码
        if (sourceIndex >= totalPage) {
            sourceIndex = totalPage - 1;
        }
        
        //如果targetView在屏幕外面，则拉回来
        NSDecimalNumber *progressNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",progress]];
        if ([progressNumber compare:@(1)] == NSOrderedSame)
        {
            //目标Label
            UIView *targetView = [self.itemScrollView viewWithTag:kBastTag + targetIndex];
            CGFloat targetMinX = CGRectGetMinX(targetView.frame) - (self.isHaveImages ? self.unitImageWidth : 0.f);
            
            [self changeAlpha:targetView];
            
            if (self.itemScrollView.contentOffset.x > targetMinX)
            {
                [self.itemScrollView setContentOffset:CGPointMake(targetMinX, 0.f) animated:YES];
            }
        }
    }
    
    [self pageViewProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}

#pragma mark -- 本视图上的元素受外层ScrollView的滚动影响
- (void)pageViewProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex
{
    //初始label
    UIView *sourceView = [self.itemScrollView viewWithTag:kBastTag + sourceIndex];
    
    //目标Label
    UIView *targetView = [self.itemScrollView viewWithTag:kBastTag + targetIndex];
    
    // trans可能会对label的frame有影响, 先设置transform 再使用label的frame
    CGFloat sourceScale = SelectScale - (SelectScale - NormalScale) * progress;
    CGFloat targetScale = NormalScale + (SelectScale - NormalScale) * progress;
    sourceView.layer.transform = CATransform3DMakeScale(sourceScale, sourceScale, 1);
    targetView.layer.transform = CATransform3DMakeScale(targetScale, targetScale, 1);
    
    CGFloat spacing = targetView.frame.origin.x - sourceView.frame.origin.x;
    
    //两者长度差值
    CGFloat lengthDiffer = CGRectGetWidth(targetView.frame) - CGRectGetWidth(sourceView.frame);
    
    CGRect sourcelineFrame = [self lineFrameWithUnitView:sourceView];
    sourcelineFrame.size.width += lengthDiffer * progress;
    sourcelineFrame.origin.x += spacing*progress;
    self.lineView.frame = sourcelineFrame;
    
    CGFloat sourceAlpha = SelectAlpha - (SelectAlpha - NormalAlpha) * progress;
    CGFloat targetAlpha = NormalAlpha + (SelectAlpha - NormalAlpha) * progress;
    sourceView.alpha = sourceAlpha;
    targetView.alpha = targetAlpha;
}

#pragma mark -
#pragma mark 点击事件
- (void)itemTapGesture:(UITapGestureRecognizer *)tapGesture {
    UIView *view = tapGesture.view;
    
    [self changeAlpha:view];
    CGRect newLineFrame = [self lineFrameWithUnitView:view];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.lineView setFrame:newLineFrame];
    }];
    
    [self.itemScrollView scrollRectToVisible:CGRectMake(view.frame.origin.x, 0, view.frame.size.width, self.itemScrollView.bounds.size.width) animated:false];
    [self.delegate pageViewSelectdIndex:view.tag - kBastTag];
}

- (void)setImagesArray:(NSArray *)imagesArray
{
    _imagesArray = imagesArray;
    _isHaveImages = imagesArray.count;
}

@end
