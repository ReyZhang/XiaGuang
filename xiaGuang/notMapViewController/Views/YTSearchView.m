//
//  YTSearchView.m
//  HighGuang
//
//  Created by Ke ZhuoPeng on 14-10-16.
//  Copyright (c) 2014年 Yuan Tao. All rights reserved.
//

#import "YTSearchView.h"
#import "YTSearchDetailsView.h"
#import "UIColor+ExtensionColor_UIImage+ExtensionImage.h"
@interface YTSearchView()<UISearchBarDelegate,YTSearchDetailsDelegate>{
    id<YTMall> _mall;
    UISearchBar *_searchBar;
    UITextField *_searchTextField;
    NSString *_placeholder;
    UIImageView *_searchLeftImageView;
    UIButton *_searchClearButton;
    UIButton *_cancelButton;
    BOOL _isAddInNavigationBar;
    BOOL _displayFirstResponder;
    BOOL _isIndent;
    YTSearchDetailsView *_detailsView;
    CGFloat _searchBarWidth;
}
@end
@implementation YTSearchView
-(instancetype)initWithMall:(id<YTMall>)mall placeholder:(NSString *)placeholder indent:(BOOL)indent{
    _mall = mall;
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    self = [super initWithFrame:CGRectMake(0, 0, width, 0)];
    if (self) {
        CGFloat searchBarX = 0;
        _searchBarWidth =  CGRectGetWidth(self.frame);
        CGFloat cancelX = CGRectGetWidth(self.frame)- 45;
        if (indent) {
            _isIndent = indent;
            searchBarX = -10;
            _searchBarWidth =  CGRectGetWidth(self.frame) - 40;
            cancelX = CGRectGetWidth(self.frame)- 85;
        }
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(searchBarX,27, _searchBarWidth, 30)];
        _placeholder = placeholder;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        
        _searchTextField = [self getTextFieldFromSearchBar:_searchBar];
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;

        UIImage *leftImage = [UIImage imageNamed:@"nav_ico_search_un"];
        _searchLeftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, leftImage.size.width,  leftImage.size.height)];
         _searchLeftImageView.image = leftImage;
        [self addSubview:_searchBar];
        
        
        _searchClearButton = [[UIButton alloc]init];
        [_searchClearButton addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
        _searchClearButton.hidden = YES;
        [_searchBar addSubview:_searchClearButton];
        
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(cancelX, 20, 30, 40)];
        _cancelButton.hidden = YES;
        [_cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        [self setBackgroundImage:nil];
        
    }
    return self;
}

-(void)layoutSubviews{
    //searchaBar
    _searchTextField.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    _searchTextField.layer.cornerRadius = CGRectGetHeight(_searchBar.frame) / 2;
    
    _searchTextField.layer.masksToBounds = YES;
    _searchTextField.clearButtonMode = UITextFieldViewModeNever;
    _searchTextField.font = [UIFont systemFontOfSize:14];
    _searchTextField.textColor = [UIColor whiteColor];
    _searchTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:_placeholder attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:14]}];
    _searchTextField.leftView = _searchLeftImageView;
    _searchTextField.tintColor = [UIColor whiteColor];
    
    //clearButton
    UIImage *rightImage = [UIImage imageNamed:@"search_ico_delete_un"];
    if (_isIndent){
        _searchClearButton.frame = CGRectMake(210 - rightImage.size.width / 2, 0, rightImage.size.width, rightImage.size.height);
    }else{
        _searchClearButton.frame = CGRectMake(249 - rightImage.size.width / 2, 0, rightImage.size.width, rightImage.size.height);
    }
    
    [_searchClearButton setImage:rightImage forState:UIControlStateNormal];
    [_searchClearButton setImage:[UIImage imageNamed:@"search_ico_delete_pr"] forState:UIControlStateHighlighted];
    [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor colorWithString:@"fac890"] forState:UIControlStateHighlighted];
    
    
}

-(void)addInNavigationBar:(UINavigationBar *)naviBar show:(BOOL)show{
    _isAddInNavigationBar = YES;
    CGRect frame = self.frame;
    if (_isIndent) {
        frame.origin.x = 40;
    }
    frame.origin.y -= 20;
    frame.size.height = CGRectGetHeight(naviBar.frame) + 20;
    self.frame = frame;
    [naviBar addSubview:self];
    
    frame.origin.y = CGRectGetMaxY(self.frame) + 20;
    frame.size.height = CGRectGetHeight([UIScreen mainScreen].bounds) - frame.origin.y;
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    frame.origin.x = 0;
    [self searchDetailsViewInitWithFrame:frame addInView:window];
    if (show) {
        _displayFirstResponder = NO;
        [self showSearchViewWithAnimation:NO];
    }else{
        _displayFirstResponder = YES;
        [self hideSearchViewWithAnimation:NO];
    }
}


-(void)addInView:(UIView *)view show:(BOOL)show{
    _isAddInNavigationBar = NO;
    CGRect frame = self.frame;
    if (show) {
        _displayFirstResponder = NO;
        [self showSearchViewWithAnimation:NO];
    }else{
        
        _displayFirstResponder = YES;
        [self hideSearchViewWithAnimation:NO];
    }
    frame.origin.y = 0;
    frame.size.height = 64;
    self.frame = frame;
    
    [view insertSubview:self atIndex:10];
    frame.origin.y = 64;
    frame.size.height = CGRectGetHeight(view.frame) - frame.origin.y;
    [self searchDetailsViewInitWithFrame:frame addInView:view];
}

-(void)setBackgroundImage:(UIImage *)image{
    if(image){
        self.backgroundColor = [UIColor colorWithPatternImage:image];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)showSearchViewWithAnimation:(BOOL)animation{
     self.hidden = NO;
    if (_isAddInNavigationBar) {
       
    }
    if(animation){
        
    }
    if (_displayFirstResponder) {
        [_searchBar becomeFirstResponder];
    }
}

- (void)hideSearchViewWithAnimation:(BOOL)animation{
     self.hidden = YES;
    [self cancelAnimation:YES completion:nil];
    if(animation){
        
    }
   
}

#pragma mark searchBar的协议
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchBar:searchBar dealWithTextChange:searchText];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    _detailsView.hidden = NO;
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = _searchTextField.frame;
        frame.size.width = frame.size.width - 43;
        _searchTextField.frame = frame;
    } completion:^(BOOL finished) {
        _cancelButton.hidden = NO;
        
    }];
}

-(void)searchBar:(UISearchBar *)searchBar dealWithTextChange:(NSString *)searchText{
    searchBar.text = searchText;
    if (searchText.length <= 0) {
        _searchClearButton.hidden = YES;
    }else if(_searchClearButton.hidden == YES){
        _searchClearButton.hidden = NO;
    }
    [_detailsView searchWithKeyword:searchText];
}

#pragma mark detailsView协议
-(void)cancelSearchInput{
    [_searchBar resignFirstResponder];
}

-(void)selectSearchResultsWithMerchantnName:(NSString *)merchantName{
    
    if ([self.delegate respondsToSelector:@selector(searchCancelButtonClicked)]){
        [self.delegate searchCancelButtonClicked];
    }
    [self cancelAnimation:NO completion:nil];
    [self.delegate selectedMerchantName:merchantName];
}

#pragma mark clear按钮 cancel按钮
-(void)clearText{
    [self searchBar:_searchBar dealWithTextChange:@""];
}

-(void)clickCancelButton:(UIButton *)sender{
    [self cancelAnimation:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(searchCancelButtonClicked)]) {
        [self.delegate searchCancelButtonClicked];
    }
}

-(void)cancelAnimation:(BOOL)animation completion:(void (^)(void))completion{
    _cancelButton.hidden = YES;
    _detailsView.hidden = YES;
    [_searchBar resignFirstResponder];
    [self searchBar:_searchBar dealWithTextChange:@""];
    NSTimeInterval duration = 0;
    if (animation) {
        duration = .2;
    }
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = _searchTextField.frame;
        frame.size.width = frame.size.width + 43;
        _searchTextField.frame = frame;
    } completion:^(BOOL finished) {
        if (completion != nil) {
            completion();
        }
    }];
}
#pragma mark 创建searchDetailsView并设置frame
-(void)searchDetailsViewInitWithFrame:(CGRect)frame addInView:(UIView *)view{
    if (_detailsView == nil) {
        _detailsView = [[YTSearchDetailsView alloc]initWithFrame:frame andDataSourceMall:_mall];
        _detailsView.delegate = self;
        [view addSubview:_detailsView];
    }
    
}

-(UITextField *)getTextFieldFromSearchBar:(UISearchBar *)searchBar{
    UIView *contentView = [searchBar.subviews firstObject];
    [[[contentView subviews] firstObject] removeFromSuperview];
    return [[contentView subviews] firstObject];
}
@end
