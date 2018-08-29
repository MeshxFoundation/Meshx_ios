//
//  JMLanguageTool.h
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/25.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMLanguageTool : NSObject
+ (NSArray *)languages;
+ (NSString *)currentCountryLanguage:(NSString *)language;
@end
