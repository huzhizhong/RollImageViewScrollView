//
//  YCarouselScrollView.m
//  YCarouselScrollView
//

//

#import "YCarouselScrollView.h"

@interface YCarouselScrollView ()<UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    NSInteger currentPage;
    NSTimer *_timer;
    float lastContentOffset;
    UIPageControl *pageCtrl;
}

@end

@implementation YCarouselScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImageArray:(NSMutableArray *)imageArray
{
    if (_imageArray) {
        _imageArray = [NSMutableArray array];
    }
}

- (void)setTitleArray:(NSMutableArray *)titleArray
{
    if (_titleArray) {
        _titleArray = [NSMutableArray array];
    }
}



- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSMutableArray *)imageArray titleArray:(NSMutableArray *)titleArray timeInterval:(NSTimeInterval)timeInterval
{
    self = [super initWithFrame:frame];
    if (self) {
        _timeInterval = timeInterval;
        _imageArray = imageArray;
        _titleArray = titleArray;
        _scrollDirection = YCarouselScrollViewDirectionRight;
        [self markScrollView];
        [self setupTimer];
    }
    return self;
}

- (void)markScrollView
{
    currentPage = 1;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width*(_imageArray.count+2), 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
    
    [self markImageView];
    [self markPageControl];
}

- (void)markImageView
{
    for (int i = 0; i<_imageArray.count+2; i++) {
        UIImage *image;
        NSString *string;
        if (i == 0) {
            image = [UIImage imageNamed:_imageArray[_imageArray.count-1]];
            string = _titleArray[_titleArray.count-1];
        } else if (i == _imageArray.count+1) {
            image = [UIImage imageNamed:_imageArray[0]];
            string = _titleArray[0];
        } else {
            image = [UIImage imageNamed:_imageArray[i-1]];
            string = _titleArray[i-1];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = image;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:imageView];
        if (i == 0) {
            imageView.tag = _imageArray.count;
        } else if (i == _imageArray.count+1) {
            imageView.tag = 1;
        } else {
            imageView.tag = i;
        }
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectImageTapGesture:)];
        [imageView addGestureRecognizer:tapGesture];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, 100, 20)];
        label.text = string;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        [imageView addSubview:label];
    }
}

- (void)markPageControl
{
    pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, 160, 100, 20)];
    pageCtrl.numberOfPages = _imageArray.count;
    pageCtrl.currentPage = 0;
    pageCtrl.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:pageCtrl];
}

- (void)setupTimer
{
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)resetTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollToNextPage
{
    
    currentPage++;
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width*currentPage, 0) animated:YES];
    if (currentPage==_imageArray.count+1) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            currentPage = 1;
            [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        });
        
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self resetTimer];
    
    lastContentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    if (lastContentOffset < scrollView.contentOffset.x) {
        _scrollDirection = YCarouselScrollViewDirectionRight;
        
    }else{
        _scrollDirection = YCarouselScrollViewDirectionLeft;
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupTimer];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    currentPage = _scrollView.contentOffset.x/self.frame.size.width;
    pageCtrl.currentPage = currentPage-1;
    if (_scrollDirection == YCarouselScrollViewDirectionLeft) {
        if (currentPage==0) {
            CGFloat x = _scrollView.contentOffset.x/self.frame.size.width;
            if (x<=0.1) {
                currentPage = 4;
                [_scrollView setContentOffset:CGPointMake(self.frame.size.width*(_imageArray.count), 0) animated:NO];
            }
        }
    }
    if (_scrollDirection == YCarouselScrollViewDirectionRight) {
        if (currentPage==_imageArray.count) {
            CGFloat x = _scrollView.contentOffset.x/self.frame.size.width;
            if (x>=0.9+currentPage) {
                currentPage = 1;
                [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
            }
        }
    }

}

- (void)didSelectImageTapGesture:(UITapGestureRecognizer *)gesture
{
    
    if ([self.delegate respondsToSelector:@selector(yCarouselScrollViewDidSelectItemAtIndex:)]) {
        [self.delegate yCarouselScrollViewDidSelectItemAtIndex:gesture.view.tag];
        
    }
}




@end
