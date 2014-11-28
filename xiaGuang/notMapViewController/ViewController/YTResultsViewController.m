//
//  YTResultsViewController.m
//  HighGuang
//
//  Created by Ke ZhuoPeng on 14-9-12.
//  Copyright (c) 2014年 Yuan Tao. All rights reserved.
//

#import "YTResultsViewController.h"
#import "YTMerchantViewCell.h"
#import <AVObject.h>
#import <AVQuery.h>
#import "YTCloudMerchant.h"
#import "YTCloudMall.h"
#import "YTCategoryResultsView.h"
#import "YTCategory.h"
#import "MJRefresh.h"
#import "YTMerchantInfoViewController.h"
#import "UIColor+ExtensionColor_UIImage+ExtensionImage.h"
@interface YTResultsViewController ()<UITableViewDelegate,UITableViewDataSource,YTCategoryResultsDelegete>{
    NSString *_category;
    NSString *_subCategory;
    NSString *_merchantName;
    NSString *_mallName;
    NSString *_floorName;
    UILabel *_notLabel;
    NSArray *_ids;
    NSMutableArray *_merchants;
    id<YTMall> _mall;
    BOOL _isCategory;
    BOOL _isSubCategory;
    BOOL _isLoading;
    BOOL _isFirst;
    UITableView *_tableView;
    YTCategoryResultsView *_categoryResultsView;
}
@end

@implementation YTResultsViewController
-(id)initWithSearchInMall:(id<YTMall>)mall andResutsKey:(NSString *)key{
    return [self initWithSearchInMall:mall andResutsKey:key andSubKey:nil];
}

-(id)initWithSearchInMall:(id<YTMall>)mall andResutsKey:(NSString *)key andSubKey:(NSString *)subKey{
    self = [super init];
    if (self) {
        _mall = mall;
        if (subKey == nil) {
            for (YTCategory *category  in [YTCategory allCategorys]) {
                if ([key isEqualToString:category.text]) {
                    _category = key;
                    _subCategory = nil;
                    _isCategory = true;
                    break;
                }
            }
        }else{
            _category = key;
            _subCategory = subKey;
            _isCategory = true;
        }

        if(_mall){
            _mallName = [mall mallName];
        }
       
    }
    return self;
}

-(instancetype)initWithSearchInMall:(id<YTMall>)mall andResultsLocalDBIds:(NSArray *)ids{
    self = [super init];
    if (self) {
        _mall = mall;
        _mallName = [mall mallName];
        _ids = ids;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"搜索结果";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shop_bg_1"]];
    
    _isFirst = YES;
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shop_bg_1"]];
    
    _tableView.tableFooterView = [[UIView alloc]init];
    
    _tableView.showsVerticalScrollIndicator = NO;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView addFooterWithTarget:self action:@selector(pullToRefresh)];
    
    [self.view addSubview:_tableView];
    
    _notLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,100, CGRectGetWidth(self.view.frame), 45)];
    _notLabel.font = [UIFont systemFontOfSize:20];
    _notLabel.textColor = [UIColor colorWithString:@"c8c8c8"];
    _notLabel.text = @"无结果";
    _notLabel.textAlignment = 1;
    _notLabel.hidden = YES;
    [_tableView addSubview:_notLabel];
    
    _categoryResultsView = [[YTCategoryResultsView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40) andmall:_mall categoryKey:_category subCategory:_subCategory];
    _categoryResultsView.delegate = self;
    [self.view addSubview:_categoryResultsView];
    
    
    [self getMerchantsWithSkip:0  numbers:10  andBlock:^(NSArray *merchants) {
        if (merchants != nil) {
            _merchants = [NSMutableArray arrayWithArray:merchants];
            if (!_isCategory) {
                id<YTMerchant> tmpMerchant = [merchants firstObject];
                _subCategory = [[tmpMerchant type] lastObject];
                _category = [[tmpMerchant type] firstObject];
                
            }
            [_categoryResultsView setKey:_category subKey:_subCategory];
        }
        [self reloadData];
    }];
}

-(void)viewWillLayoutSubviews{
    CGFloat topHeight = [self.topLayoutGuide length];
    
    CGRect frame = _tableView.frame;
    frame.origin.y = topHeight + 40;
    frame.size.height = CGRectGetHeight(self.view.frame) - topHeight - 40;
    _tableView.frame = frame;

    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    frame = _categoryResultsView.frame;
    frame.origin.y = topHeight;
    _categoryResultsView.frame = frame;
    
}


-(void)pullToRefresh{
    if (!_isLoading) {
        _isLoading = YES;
        [self getMerchantsWithSkip:(int)_merchants.count numbers:10 andBlock:^(NSArray *merchants) {
            [_merchants addObjectsFromArray:merchants];
            [self reloadData];
            [_tableView footerEndRefreshing];
            _isLoading = NO;
        }];
    }
}

-(void)getMerchantsWithSkip:(int)skip numbers:(int)number andBlock:(void (^)(NSArray *merchants))block{
    NSMutableArray *merchants = [NSMutableArray array];    
    AVQuery *query = [AVQuery queryWithClassName:MERCHANT_CLASS_NAME];
    [query orderByAscending:@"name"];
    [query includeKey:@"mall,floor"];
    query.limit = number;
    query.skip = skip;
    if (_isCategory) {
        if (_subCategory != nil) {
            [query whereKey:MERCHANT_CLASS_TYPE_KEY containsString:_subCategory];
        }else{
            if (_category != nil){
                [query whereKey:MERCHANT_CLASS_TYPE_KEY containsString:_category];
            }
        }
    }else{
        if (_ids.count <= 0 || _ids == nil) {
            block(nil);
            return;
        }
        [query whereKey:MERCHANT_CLASS_UNIID_KEY containedIn:_ids];
    }
    if (_floorName != nil) {
        AVQuery *floorQuery = [AVQuery queryWithClassName:@"Floor"];
        [floorQuery whereKey:@"floorName" equalTo:_floorName];
        [query whereKey:@"floor" matchesQuery:floorQuery];

    }
    
    if (_mallName != nil) {
        AVQuery *mallObject = [AVQuery queryWithClassName:@"Mall"];
        [mallObject whereKey:@"name" containsString:_mallName];
        [query whereKey:@"mall" matchesQuery:mallObject];

        //[query whereKey:@"mall" equalTo:[mallObject getFirstObject]];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if(error){
            block(nil);
            return;
        }
        
        for (AVObject *merchantObject in objects) {
            YTCloudMerchant *merchant = [[YTCloudMerchant alloc]initWithAVObject:merchantObject];
            [merchants addObject:merchant];
        }
        
        block(merchants);
        return ;
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _merchants.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTMerchantViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[YTMerchantViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    id <YTMerchant> merchant = _merchants[indexPath.row];
    
    cell.merchant = merchant;
    
    return cell;
}

-(void)reloadData{
    [_tableView reloadData];
    if (_merchants.count == 0 || _merchants == nil) {
        _notLabel.hidden = NO;
    }else{
        _notLabel.hidden = YES;
    }
}

-(void)searchKeyForCategoryTitle:(NSString *)category subCategoryTitle:(NSString *)subCategory mallName:(NSString *)mallName floor:(NSString *)floorName{
    [_merchants removeAllObjects];
    [_tableView reloadData];
    //#warning 加载动画
    NSLog(@"category:%@  subCategory:%@ mallName:%@ floorName:%@",category,subCategory,mallName,floorName);
    _category = category;
    _subCategory = subCategory;
    _floorName = floorName;
    _mallName = mallName;
    if ([_category isEqualToString:@"全部"]) {
        _category = nil;
    }
    if ([_subCategory isEqualToString:@"全部"]) {
        _subCategory = nil;
    }
    
    if ([_floorName isEqualToString:@"全部"]){
        _floorName = nil;
    }
    
    if ([_mallName isEqualToString:@"全部"]){
        _mallName = nil;
    }
    _isCategory = YES;
    [self getMerchantsWithSkip:0 numbers:10 andBlock:^(NSArray *merchants) {
        _merchants = [NSMutableArray arrayWithArray:merchants];
        [self reloadData];
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YTMerchantViewCell *cell = (YTMerchantViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    id<YTMerchant> merchant = _merchants[indexPath.row];
    YTMerchantInfoViewController *merchantInfoVC = [[YTMerchantInfoViewController alloc]initWithMerchant:merchant];
    [self.navigationController pushViewController:merchantInfoVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(void)dealloc{
    NSLog(@"ResultsDealloc");
}
@end
