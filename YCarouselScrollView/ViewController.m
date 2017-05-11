//
//  ViewController.m
//  YCarouselScrollView
//

//

#import "ViewController.h"
#import "YCarouselScrollView.h"

@interface ViewController ()<YCarouselScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithObjects:@"chun.png", @"xia.png", @"qiu.png", @"dong.png", nil];
    NSMutableArray *titleArray = [NSMutableArray arrayWithObjects:@"春", @"夏", @"秋", @"冬", nil];
    
    YCarouselScrollView *YCarouselView = [[YCarouselScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) imageArray:imageArray titleArray:titleArray timeInterval:6];
    YCarouselView.delegate = self;
    [self.view addSubview:YCarouselView];
    
}

- (void)yCarouselScrollViewDidSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld", index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
