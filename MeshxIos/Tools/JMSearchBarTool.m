//
//  JMSearchBarTool.m
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/20.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMSearchBarTool.h"

@implementation JMSearchBarTool
+ (UISearchController *)setupSearchResultsController:(UIViewController *)searchResultsController{
    UISearchController  *searchController = nil;
    //iOS 11.0以下搜索栏高度默认是44
    CGFloat searchBarHeight = 44;
    if (@available(iOS 11.0, *)) {
        //ios 11.0以上不需要导航了
         searchController = [[UISearchController alloc]initWithSearchResultsController:searchResultsController];
        //iOS11.0UISearchController的搜索栏添加到TableView的头部，那么搜索栏固定56，如果设置其他值，当你取消搜索时，系统会默认重新设置它的值为56
        searchBarHeight = 56;
    }else{
       
        JMBaseNavigationController *searchReslutsNa = [[JMBaseNavigationController alloc] initWithRootViewController:searchResultsController];
        searchController = [[UISearchController alloc]initWithSearchResultsController:searchReslutsNa];
    }
      searchController.searchResultsUpdater = searchResultsController;
    searchController.hidesNavigationBarDuringPresentation = YES;
    //关闭自动首字母大写
    searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchController.searchBar.placeholder = [JMLanguageManager jm_languageSearch];
    [searchController.searchBar sizeToFit];
    searchController.searchBar.frame = CGRectMake(0, 0, searchController.searchBar.frame.size.width, searchBarHeight);
    UIColor *color = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    //        //去掉searchController.searchBar的上下边框（黑线）
    UIImageView *barImageView = [[[searchController.searchBar.subviews firstObject] subviews] firstObject];
    barImageView.layer.borderColor = color.CGColor;
    barImageView.layer.borderWidth = 1;
    searchController.searchBar.barTintColor =color;
    //设置取消按钮字体
    [searchController.searchBar setValue:[JMLanguageManager jm_languageCancel] forKey:@"_cancelButtonText"];
  
    
    return searchController;
}

+ (void)setupCancelTitle:(NSString *)cancel searchController:(UISearchController *)searchController;{
    //设置取消按钮字体
    [searchController.searchBar setValue:cancel forKey:@"_cancelButtonText"];
    //设置取消按钮字体
    for (UIView *view in searchController.searchBar.subviews.firstObject.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *navButton = (UIButton *)view;
            [navButton setTitle:cancel forState:UIControlStateNormal];
        }
    }
}

@end
