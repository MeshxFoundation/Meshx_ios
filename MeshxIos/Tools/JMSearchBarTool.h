//
//  JMSearchBarTool.h
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/20.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSearchBarTool : NSObject
+ (UISearchController *)setupSearchResultsController:(UIViewController *)searchResultsController;
+ (void)setupCancelTitle:(NSString *)cancel searchController:(UISearchController *)searchController;
@end
