//
//  JMLanguageTool.m
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/25.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMLanguageTool.h"

@implementation JMLanguageTool

+ (NSArray *)languages{
    return @[@"zh-Hans", //中文简体
             @"en", //英文
             @"es"];//西班牙语
}
+ (NSString *)currentCountryLanguage:(NSString *)language{
    
    if ([[self languages] containsObject:language]) {
        return [self ittemCountryLanguage:language];
    }
    return [self itemLanguage:language];
}

+ (NSString *)itemLanguage:(NSString *)language{
    for (NSString *lang in [self languages]) {
        if ([language rangeOfString:lang].length) {
            return [self ittemCountryLanguage:language];
        }
    }
    return [self ittemCountryLanguage:@"en"];
}

////对应国家的语言
+ (NSString *)ittemCountryLanguage:(NSString *)lang {
    NSString *language = [kLanguageManager languageFormat:lang];
    NSString *countryLanguage = [[[NSLocale alloc] initWithLocaleIdentifier:language] displayNameForKey:NSLocaleIdentifier value:language];
    return countryLanguage;
}

@end
