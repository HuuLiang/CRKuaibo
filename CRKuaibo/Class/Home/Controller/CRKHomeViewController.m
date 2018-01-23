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
#import "CRKHomePageModel.h"

typedef NS_ENUM (NSUInteger , SegmentIndex){
    CRKBEuramerican, //欧美
    CRKBJapanKorea,  //日韩
    CRKBMainland     //大陆
};

@interface CRKHomeViewController ()<UIPageViewControllerDelegate>
{
    UIPageViewController *_pageViewCtroller;
    
    
}
@property (nonatomic,retain)NSMutableArray <UIViewController*>*viewCtrollers;
@property (nonatomic,retain)CRKHomePageModel *homePageModel;
@property (nonatomic,retain)NSArray <NSString *>*segmentTitles;

@end

@implementation CRKHomeViewController

DefineLazyPropertyInitialization(NSMutableArray,viewCtrollers);
DefineLazyPropertyInitialization(CRKHomePageModel, homePageModel);
DefineLazyPropertyInitialization(NSArray, segmentTitles);

- (instancetype)initWithHomeModel:(CRKHomePageModel*)homePageModel{
    if (self = [self init]) {
        _homePageModel = homePageModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSegmentControll];
    [self setPageCtroller];
    //    [self loadChannel];
    
}

/**
 *  加载数据
 */
- (void)loadChannel {
    [self.homePageModel fetchWiithCompletionHandler:^(BOOL success, NSArray<CRKHomePage *>*programs) {
        if (success) {
            
            
            //            [self setPageCtroller];
        }
    }];
    
}


/**
 *  设置PageCtroller
 */
- (void)setPageCtroller {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //    CRKOccidentController *occidentVC = [[CRKOccidentController alloc] initWithHomePage:_homePageModel.homePageOM];
    //    [self.viewCtrollers addObject:occidentVC];
    //    CRKRHViewController *riHanVC = [[CRKRHViewController alloc] initWithHomePage:_homePageModel.homePageRH];
    //    [self.viewCtrollers addObject:riHanVC];
    //    CRKDLViewController *mainLandVC = [[CRKDLViewController alloc] initWithHomePage:_homePageModel.homePageDL];
    //    [self.viewCtrollers addObject:mainLandVC];
    
    //CRKRHViewController 和 CRKDLViewController两个控制器舍弃
    
    for (int i = 0; i <_segmentTitles.count; ++i) {
        
        CRKOccidentController *VC = [[CRKOccidentController alloc] initWithHomePage:_homePageModel.fetchHomePage[i]];
        VC.segementName = _segmentTitles[i];
        VC.currentSegmentName = _segmentTitles[1];
        [self.viewCtrollers addObject:VC];
        
    }
    
    _pageViewCtroller = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewCtroller.delegate = self;
    //    _pageViewCtroller.dataSource = self;
    [_pageViewCtroller setViewControllers:@[self.viewCtrollers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:_pageViewCtroller];
    [self.view addSubview:_pageViewCtroller.view];
    [_pageViewCtroller didMoveToParentViewController:self];
    
    _segmentCtrolller.selectedSegmentIndex = 1;
    
}


/**
 *  设置SegmentControll
 */
- (void)setSegmentControll {
    
    NSMutableArray *segmentTitleArr = [NSMutableArray arrayWithCapacity:_homePageModel.fetchHomePage.count];
    [_homePageModel.fetchHomePage enumerateObjectsUsingBlock:^(CRKHomePage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [segmentTitleArr addObject:obj.name];
    }];
    
    _segmentTitles =  segmentTitleArr.count != 0 ? segmentTitleArr.copy :  @[@"欧美",@"日韩",@"大陆"]; //@[@"欧美",@"日韩",@"大陆"];//
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:_segmentTitles];
    _segmentCtrolller = segment;
    segment.selectedSegmentIndex = 0;
    segment.frame = CGRectMake(0, 0, kScreenWidth*0.5, 31);
    segment.tintColor = [UIColor colorWithWhite:1 alpha:0.5];
    [segment.layer masksToBounds];
    [segment setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.]} forState:UIControlStateNormal];
    self.navigationItem.titleView = segment;
    //监听点击的是哪个
    [segment addObserver:self forKeyPath:NSStringFromSelector(@selector(selectedSegmentIndex)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(selectedSegmentIndex))]) {
        NSNumber *oldValue = change[NSKeyValueChangeOldKey];
        NSNumber *newValue = change[NSKeyValueChangeNewKey];
        
        [[CRKStatsManager sharedManager] statsStopDurationAtTabIndex:self.tabBarController.selectedIndex subTabIndex:oldValue.integerValue];
        [[CRKStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:newValue.integerValue forClickCount:1];
        //选则控制器
        [_pageViewCtroller setViewControllers:@[_viewCtrollers[newValue.unsignedIntegerValue]]
                                    direction:newValue.unsignedIntegerValue>oldValue.unsignedIntegerValue ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
