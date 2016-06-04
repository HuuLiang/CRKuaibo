//
//  CRKHomeViewController.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKHomeViewController.h"
#import "CRKOccidentController.h"
#import "CRKRHViewController.h"
#import "CRKDLViewController.h"

typedef NS_ENUM (NSUInteger , SegmentIndex){
    CRKBEuramerican, //欧美
    CRKBJapanKorea,  //日韩
    CRKBMainland     //大陆
};

@interface CRKHomeViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    UIPageViewController *_pageViewCtroller;
    
}
@property (nonatomic,retain)NSMutableArray <UIViewController*>*viewCtrollers;

@end

@implementation CRKHomeViewController

DefineLazyPropertyInitialization(NSMutableArray,viewCtrollers);

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPageCtroller];
    
    [self setSegmentControll];
    
}
/**
 *  设置PageCtroller
 */
- (void)setPageCtroller {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CRKOccidentController *occidentVC = [[CRKOccidentController alloc] init];
    [self.viewCtrollers addObject:occidentVC];
    CRKRHViewController *riHanVC = [[CRKRHViewController alloc] init];
    [self.viewCtrollers addObject:riHanVC];
    CRKDLViewController *mainLandVC = [[CRKDLViewController alloc] init];
    [self.viewCtrollers addObject:mainLandVC];
    
    _pageViewCtroller = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewCtroller.delegate = self;
    _pageViewCtroller.dataSource = self;
    [_pageViewCtroller setViewControllers:@[self.viewCtrollers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:_pageViewCtroller];
    [self.view addSubview:_pageViewCtroller.view];
    [_pageViewCtroller didMoveToParentViewController:self];
    
    
}


/**
 *  设置SegmentControll
 */
- (void)setSegmentControll {
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"欧美",@"日韩",@"大陆"]];
    segment.selectedSegmentIndex = 0;
    segment.frame = CGRectMake(0, 0, kScreenWidth*0.5, 31);
    segment.tintColor = [UIColor colorWithWhite:1 alpha:0.5];
    [segment.layer masksToBounds];
    [segment setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.]} forState:UIControlStateNormal];
    self.navigationItem.titleView = segment;
    //监听点击的是哪个
    [segment addObserver:self forKeyPath:NSStringFromSelector(@selector(selectedSegmentIndex)) options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(selectedSegmentIndex))]) {
        NSNumber *oldValue = change[NSKeyValueChangeOldKey];
        NSNumber *newValue = change[NSKeyValueChangeNewKey];
        //选则控制器
        [_pageViewCtroller setViewControllers:@[_viewCtrollers[newValue.unsignedIntegerValue]]
    direction:newValue.unsignedIntegerValue>oldValue.unsignedIntegerValue ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
