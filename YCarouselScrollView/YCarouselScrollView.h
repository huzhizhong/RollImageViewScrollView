//
//  YCarouselScrollView.h
//  YCarouselScrollView
//

//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YCarouselScrollViewDirectionRight,           /** 向右滚动*/
    YCarouselScrollViewDirectionLeft,            /** 向左滚动*/
} YCarouselScrollViewDirection;

@protocol YCarouselScrollViewDelegate <NSObject>

/** 点击图片*/
- (void)yCarouselScrollViewDidSelectItemAtIndex:(NSInteger)index;

@end

@interface YCarouselScrollView : UIView

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) YCarouselScrollViewDirection scrollDirection;

@property (nonatomic, assign) id<YCarouselScrollViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSMutableArray *)imageArray titleArray:(NSMutableArray *)titleArray timeInterval:(NSTimeInterval)timeInterval;

@end
