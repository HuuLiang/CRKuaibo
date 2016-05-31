//
//  CRKMineViewController.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKMineViewController.h"
#import "CRKRecommendCell.h"
#import "CRKRecommendHeaderView.h"
#import "CRKInputViewController.h"

static NSString *KUserCorrelationCellIdentifer = @"kusercorrelationcell";
static NSString *KRecommendCellIdentifer = @"krecommendcell";
static NSInteger KSections = 2;

typedef NS_ENUM(NSInteger , CRKSectionNumber) {
    CRKRecommend,
    CRKUserCorrelation
};
typedef NS_ENUM(NSInteger , CRKSideMenuRow) {
    CRKUserFeedBack,
    CRKUserAgreement,
    CRKVersionRenew
    
};

@interface CRKMineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_layoutTableView;
}

@end

@implementation CRKMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
 
}

- (void)setTableView {
        self.automaticallyAdjustsScrollViewInsets = NO;
    _layoutTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _layoutTableView.scrollEnabled = NO;
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.separatorColor = [UIColor lightGrayColor];
    _layoutTableView.hasRowSeparator = YES;
    _layoutTableView.hasSectionBorder = YES;
    [_layoutTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KUserCorrelationCellIdentifer];
    [_layoutTableView registerClass:[CRKRecommendCell class] forCellReuseIdentifier:KRecommendCellIdentifer];
        [self.view addSubview:_layoutTableView];
    [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
}

- (CRKSectionNumber)sectionNumberWithSection:(NSUInteger)section {
    if (section == 0) {
        return CRKRecommend;
    }else{
        return CRKUserCorrelation;
    }
    
}
//- (CRKSideMenuRow)sideMenuRowWithRow:(NSUInteger)row {
//    if (row == 0) {
//        return CRKUserFeedBack;
//    }else if (row == 1){
//        return CRKUserAgreement;
//    }else{
//        
//        return CRKVersionRenew;
//    }
//    
//}

#pragma mark UITableView Delegate Datesurse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return KSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self sectionNumberWithSection:section] == CRKRecommend) {
        return 1;
    }else if ([self sectionNumberWithSection:section] == CRKUserCorrelation){
        
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self sectionNumberWithSection:indexPath.section] == CRKRecommend) {
        CRKRecommendCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:KRecommendCellIdentifer forIndexPath:indexPath];
        return recommendCell;
        
    }else if ([self sectionNumberWithSection:indexPath.section] == CRKUserCorrelation){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KUserCorrelationCellIdentifer forIndexPath:indexPath];
        if (indexPath.row == CRKUserFeedBack) {
            cell.imageView.image = [UIImage imageNamed:@"agreement"];
            cell.textLabel.text = @"意见反馈";
        }else if (indexPath.row == CRKUserAgreement ){
            cell.imageView.image = [UIImage imageNamed:@"协议_18x18_"];
            cell.textLabel.text = @"用户协议";
        
        }else {
            cell.imageView.image = [UIImage imageNamed:@"版本_18x18_"];
            cell.textLabel.text = @"版本更新";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CRKRecommend) {
        return 200./667.*kScreenHeight;
    }else {
        return 74./667.*kScreenHeight;
    }
}
/**
 *  tableView 组内容设置
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == CRKRecommend) {
        
        CRKRecommendHeaderView *headerView = [[CRKRecommendHeaderView alloc] init];
        headerView.backgroundColor = self.view.backgroundColor;
        return headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == CRKRecommend) {
        return 34/667.*kScreenHeight;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == CRKUserCorrelation) {
        
        if (indexPath.row == CRKUserFeedBack) {
            CRKInputViewController *inputVC = [[CRKInputViewController alloc] init];
            [self presentViewController:inputVC animated:YES completion:nil];
        }
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
