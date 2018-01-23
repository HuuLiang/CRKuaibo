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
#import "CRKUserProtolController.h"
#import "CRKNewVersionsController.h"
#import "CRKSpreadController.h"

static NSString *KUserCorrelationCellIdentifer = @"kusercorrelationcell";
static NSString *KRecommendCellIdentifer = @"krecommendcell";
static NSInteger KSections = 2;//组

typedef NS_ENUM(NSInteger , CRKSectionNumber) {
    CRKVip,
    CRKUserCorrelation
};
typedef NS_ENUM(NSInteger , CRKSideMenuRow) {
    CRKSpred,
    CRKUserFeedBack,
    CRKUserAgreement
    
};

@interface CRKMineViewController ()<UITableViewDataSource,UITableViewSeparatorDelegate>
{
    UITableView *_layoutTableView;
}

@end

@implementation CRKMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    //去掉多余分割线
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [_layoutTableView setTableFooterView:view];
    
    
    [self.navigationController.navigationBar bk_whenTouches:1 tapped:5 handler:^{
        NSString *baseURLString = [CRK_BASE_URL stringByReplacingCharactersInRange:NSMakeRange(0, CRK_BASE_URL.length-6) withString:@"******"];
        [[CRKHudManager manager] showHudWithText:[NSString stringWithFormat:@"Server:%@\nChannelNo:%@\nPackageCertificate:%@\npV:%@", baseURLString, CRK_CHANNEL_NO, CRK_PACKAGE_CERTIFICATE, CRK_REST_PV]];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotification) name:kPaidNotificationName object:nil];
    
}

- (void)setTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _layoutTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //    _layoutTableView.scrollEnabled = NO;
    _layoutTableView.backgroundColor = [UIColor clearColor];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.separatorColor = [UIColor lightGrayColor];
    _layoutTableView.hasRowSeparator = YES;
    //    _layoutTableView.hasSectionBorder = YES;
    [_layoutTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KUserCorrelationCellIdentifer];
    [_layoutTableView registerClass:[CRKRecommendCell class] forCellReuseIdentifier:KRecommendCellIdentifer];
    [self.view addSubview:_layoutTableView];
    [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
}

- (CRKSectionNumber)sectionNumberWithSection:(NSUInteger)section {
    if (section == 0) {
        return CRKVip;
    }else{
        return CRKUserCorrelation;
    }
}
//如果支付完成则刷新界面
- (void)onPaidNotification{
    [_layoutTableView reloadData];
    
}

#pragma mark UITableView Delegate Datesurse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return KSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self sectionNumberWithSection:section] == CRKVip) {
        return 1;
    }else if ([self sectionNumberWithSection:section] == CRKUserCorrelation){
        
        return 4;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self sectionNumberWithSection:indexPath.section] == CRKVip) {
        CRKRecommendCell *vipCell = [tableView dequeueReusableCellWithIdentifier:KRecommendCellIdentifer forIndexPath:indexPath];
        vipCell.memberTitle = [CRKUtil isPaid] ? @"VIP会员" :@"成为VIP会员";
        @weakify(self);
        if (!vipCell.memberAction) {
            vipCell.memberAction = ^(id sender) {
                @strongify(self);
                if (![CRKUtil isPaid]) {
                    CRKProgram *program = [[CRKProgram alloc] init];
                    //                    program.payPointType = @(payPointType);
                    CRKChannel *channel = [[CRKChannel alloc] init];
                    //    channel.
                    //跳转到支付
                    [self switchToPlayProgram:program programLocation:1 inChannel:channel];
                } else {
                    [[CRKHudManager manager] showHudWithText:@"您已经是会员，感谢您的观看！"];
                }
                
            };}
        
        return vipCell;
        
    }else if ([self sectionNumberWithSection:indexPath.section] == CRKUserCorrelation){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KUserCorrelationCellIdentifer forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == CRKUserFeedBack) {
            
            cell.imageView.image = [UIImage imageNamed:@"agreement"];
            cell.textLabel.text = @"意见反馈";
        }else if (indexPath.row == CRKUserAgreement ){
            cell.imageView.image = [UIImage imageNamed:@"协议_18x18_"];
            cell.textLabel.text = @"用户协议";
            
        }else if(indexPath.row ==  CRKSpred){
            cell.imageView.image = [UIImage imageNamed:@"版本_18x18_"];
            cell.textLabel.text = @"精品推荐";
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CRKVip) {
        return 200./667.*kScreenHeight;
    }else {
        return 64./667.*kScreenHeight;
    }
}
/**
 *  tableView 组内容设置
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == CRKVip) {
        
        CRKRecommendHeaderView *headerView = [[CRKRecommendHeaderView alloc] init];
        headerView.backgroundColor = self.view.backgroundColor;
        return headerView;
    }
    return nil;
}
//组高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == CRKVip) {
        return 34/667.*kScreenHeight;
    }else if (section == CRKUserCorrelation){
        return 20/667.*kScreenHeight;}
    return 140/667.*kScreenHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == CRKUserCorrelation) {
        
        if (indexPath.row == CRKUserFeedBack) {
            CRKInputViewController *inputVC = [[CRKInputViewController alloc] init];
            inputVC.title = cell.textLabel.text;
            inputVC.limitedTextLength = 140;
            inputVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:inputVC animated:YES];
        }else if (indexPath.row == CRKUserAgreement){
            //用户协yi
            NSString *urlString = [CRKUtil isPaid] ? CRK_STANDBY_AGREEMENT_PAID_URL:CRK_STANDBY_AGREEMENT_NOTPAID_URL;
            urlString = [CRK_BASE_URL stringByAppendingString:urlString];
            
            NSString *standbyUrlString = [CRKUtil isPaid]?CRK_STANDBY_AGREEMENT_PAID_URL:CRK_STANDBY_AGREEMENT_NOTPAID_URL;
            standbyUrlString = [CRK_STANDBY_BASE_URL stringByAppendingString:standbyUrlString];
            CRKUserProtolController *protolVC = [[CRKUserProtolController alloc] initWithURL:[NSURL URLWithString:urlString] standbyURL:[NSURL URLWithString:standbyUrlString]];
            protolVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:protolVC animated:YES];
            
        }else if(indexPath.row ==  CRKSpred ){
            CRKSpreadController *newVersionsVC = [[CRKSpreadController alloc] init];
            newVersionsVC.title = @"精品推荐";
            newVersionsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newVersionsVC animated:YES];
            
        }else {
            
            
        }
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate  {
    [[CRKStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[CRKUtil currentSubTabPageIndex] forSlideCount:1];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
