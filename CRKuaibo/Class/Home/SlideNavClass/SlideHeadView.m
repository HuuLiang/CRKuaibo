//
//  SlideHeadView.m
//  Copyright © 2016 All rights reserved.
//

#import "SlideHeadView.h"
#import "UIView+Extension.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RandomColor Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))/** 随机色  */
static CGFloat const titleH = 44;/** 文字高度  */

static CGFloat const MaxScale = 1.2;/** 选中文字放大  */


@implementation SlideHeadView

- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(void)setSlideHeadView{
    
    [self setTitleScrollView];        /** 添加文字标签  */
    
    [self setContentScrollView];      /** 添加scrollView  */
    
    [self setupTitle];                /** 设置标签按钮 文字 背景图  */
    
    
    self.contentScrollView.contentSize = CGSizeMake(self.titlesArr.count * ScreenW, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator  = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.bounces = NO;
}
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

#pragma mark - PRIVATE

-(void)addChildViewController:(UIViewController *)childVC title:(NSString *)vcTitle{
    UIViewController *superVC = [self findViewController:self];
    childVC.title = vcTitle;
    [superVC addChildViewController:childVC];
    
}
/**
 *  setTitleScrollView
 */
-(void)setTitleScrollView{
    UIViewController *superVC = [self findViewController:self];
    CGRect rect  = CGRectMake(0, 0, ScreenW, titleH);
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    
    [superVC.view addSubview:self.titleScrollView];
    
    
}

/**
 *  setContentScrollView
 */
-(void)setContentScrollView{
    UIViewController *superVC = [self findViewController:self];
    
    CGFloat y  = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect  = CGRectMake(0, y, ScreenW, ScreenH - titleH);
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [superVC.view addSubview:self.contentScrollView];
    
    
}

-(void)setupTitle{
    UIViewController *superVC = [self findViewController:self];
    
    NSUInteger count = superVC.childViewControllers.count;
    CGFloat x = 0;
    CGFloat w = 80;
    CGFloat h = titleH;
    self.imageBackView  = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 80-30, titleH-20)];
    //    self.imageBackView.imageView.image = [UIImage imageNamed:@"b1"];
    [_imageBackView setTitle:@"热门" forState:UIControlStateNormal];
    _imageBackView.titleLabel.font = [UIFont systemFontOfSize:14.];
    [_imageBackView setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _imageBackView.layer.cornerRadius = 10;
    _imageBackView.layer.masksToBounds = YES;
    self.imageBackView.backgroundColor = self.selectedBtn.tintColor;
    self.imageBackView.userInteractionEnabled = YES;
    [self.titleScrollView addSubview:self.imageBackView];
    
    for (int i = 0; i < count; i++)
    {
        UIViewController *vc = superVC.childViewControllers[i];
        
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
        
        [self.buttons addObject:btn];
        [self.titleScrollView addSubview:btn];
        
        
        if (i == 0)
        {
            [self click:btn];
        }
        
    }
    
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
}
-(void)click:(UIButton *)sender{
    
    [self selectTitleBtn:sender];
    NSInteger i = sender.tag;
    CGFloat x  = i *ScreenW;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
    [self setUpOneChildController:i];
    
    
}

-(void)selectTitleBtn:(UIButton *)btn{
    
    
    [self.selectedBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.selectedBtn.transform = CGAffineTransformIdentity;
    
    
    //    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    //    btn.transform = CGAffineTransformMakeScale(MaxScale, MaxScale);
    self.selectedBtn = btn;
    
    [self setupTitleCenter:btn];
    
}

-(void)setupTitleCenter:(UIButton *)sender
{
    
    CGFloat offset = sender.center.x - ScreenW * 0.5;
    if (offset < 0) {
        offset = 0;
    }
    
    CGFloat maxOffset  = self.titleScrollView.contentSize.width - ScreenW;
    if (offset > maxOffset && maxOffset>0) {
        offset = maxOffset;
    }
    
    NSLog(@"%lf,%lf,%ld",offset,maxOffset,sender.tag);
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
}

-(void)setUpOneChildController:(NSInteger)index{
    UIViewController *superVC = [self findViewController:self];
    
    CGFloat x  = index * ScreenW;
    UIViewController *vc  =  superVC.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, ScreenW, ScreenH - self.contentScrollView.frame.origin.y);
    [self.contentScrollView addSubview:vc.view];
    
}


#pragma mark - UIScrollView  delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger i  = self.contentScrollView.contentOffset.x / ScreenW;
    [self selectTitleBtn:self.buttons[i]];
    [self setUpOneChildController:i];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetX  = scrollView.contentOffset.x;
    NSInteger leftIndex  = offsetX / ScreenW;
    NSInteger rightIdex  = leftIndex + 1;
    
    UIButton *leftButton = self.buttons[leftIndex];
    UIButton *rightButton  = nil;
    if (rightIdex < self.buttons.count) {
        rightButton  = self.buttons[rightIdex];
    }
    CGFloat scaleR  = offsetX / ScreenW - leftIndex;
    CGFloat scaleL  = 1 - scaleR;
    CGFloat transScale = MaxScale - 1;
    
    self.imageBackView.transform  = CGAffineTransformMakeTranslation((offsetX*(self.titleScrollView.contentSize.width / self.contentScrollView.contentSize.width)), 0);
    
    [_imageBackView setTitle:leftButton.titleLabel.text forState:UIControlStateNormal];
    //    [leftButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    //    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    //    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);
    
    UIColor *rightColor = [UIColor colorWithRed:(174+66*scaleR)/255.0 green:(174-71*scaleR)/255.0 blue:(174-174*scaleR)/255.0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:(174+66*scaleL)/255.0 green:(174-71*scaleL)/255.0 blue:(174-174*scaleL)/255.0 alpha:1];
    
    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
    
}

@end
