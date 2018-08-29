//
//  JMSearchPeopleTool.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/12.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMPeopleModel.h"

@interface JMSearchPeopleTool : NSObject
+ (void)searchWithString:(NSString *)searchStr result:(void(^)(BOOL isSuccess,NSArray <JMPeopleModel *>*dataArray))result;
@end
