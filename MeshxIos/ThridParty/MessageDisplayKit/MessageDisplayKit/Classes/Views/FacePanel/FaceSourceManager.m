//
//  FaceSourceManager.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "FaceSourceManager.h"

@interface FaceSourceManager ()

@property (nonatomic ,strong) UITextView *inputView;
@end

@implementation FaceSourceManager

- (instancetype)initWithInputView:(UITextView *)inputView{
    if (self = [super init]) {
        _inputView = inputView;
    }
    return self;
}

//从持久化存储里面加载表情源
- (NSArray *)loadFaceSource
{
    NSMutableArray *subjectArray = [NSMutableArray array];
    
    NSArray *sources = [self getSourcePlistName];
    
    for (int i = 0; i < sources.count; ++i)
    {
        NSString *plistName = sources[i];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        
        NSDictionary *faceDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *allkeys = faceDic.allKeys;
        NSArray *value = [faceDic allValues];
        NSArray *sortedArray = [value sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
       
        NSMutableArray *sequenceKeys = [NSMutableArray array];
        //对全部Key排序
        for (int i = 0; i < sortedArray.count; i ++) {
            
            for (NSString *key in allkeys) {
                
                if ([[faceDic valueForKey:key] isEqualToString:sortedArray[i]]) {
                    
                    [sequenceKeys addObject:key];
                }
            }
        }
        
      
        
        FaceThemeModel *themeM = [[FaceThemeModel alloc] init];
        
        if ([plistName isEqualToString:@"Expression"]) {
            themeM.themeStyle = FaceThemeStyleCustomEmoji;
            themeM.themeDecribe = @"表情";
            themeM.themeIcon = @"Expression_1@2x";
        }else if ([plistName isEqualToString:@"systemEmoji"]){
            themeM.themeStyle = FaceThemeStyleSystemEmoji;
            themeM.themeDecribe = @"😊";
            themeM.themeIcon = @"";
        }
        else {
            themeM.themeStyle = FaceThemeStyleGif;
            themeM.themeDecribe = [NSString stringWithFormat:@"e%d", i];
            themeM.themeIcon = @"f_static_000";
        }
        
        
        NSMutableArray *modelsArr = [NSMutableArray array];
        
        for (int i = 0; i < sequenceKeys.count; ++i) {
            NSString *name = sequenceKeys[i];
            FaceModel *fm = [[FaceModel alloc] init];
            fm.faceTitle = name;
            fm.faceIcon = [faceDic objectForKey:name];
            [modelsArr addObject:fm];
       
        }
        themeM.faceModels = modelsArr;
        
        [subjectArray addObject:themeM];
    }
    
    
    return subjectArray;
}

- (NSArray *)getSourcePlistName{
    return @[@"Expression", @"systemEmoji"];
}

- (NSMutableArray *)getfaceName{
    
    NSMutableArray *subjectArray = [NSMutableArray array];
    
    NSArray *sources = [self getSourcePlistName];
    
    for (int i = 0; i < sources.count; ++i)
    {
        NSString *plistName = sources[i];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        
        NSDictionary *faceDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *allkeys = faceDic.allKeys;
        [subjectArray addObjectsFromArray:allkeys];
    }
    
    return subjectArray;
}

- (void)textViewDeleteBackward{
    
    NSMutableString * muStr = [[NSMutableString alloc] initWithString:self.inputView.text];
    if ([muStr length]) {
        
        NSMutableArray *faceName = [self getfaceName];
        
        NSString *deleteName = @"1";
        for (NSString *faceStr in faceName) {
            
            NSMutableString *faceString = [[NSMutableString alloc] initWithString:faceStr];
            [faceString deleteCharactersInRange:NSMakeRange(faceString.length-1, 1)];
            if ([muStr hasSuffix:faceString]) {
                
                deleteName = faceString;
                NSInteger deleteLong = [deleteName length];
                [muStr deleteCharactersInRange:NSMakeRange(muStr.length-deleteLong, deleteLong)];
                self.self.inputView.text = muStr;
                break;
            }
        }
        
        
    }
}

- (void)customDeleteText{
    
    NSMutableString * muStr = [[NSMutableString alloc] initWithString:self.inputView.text];
    if ([muStr length]) {
        
        NSMutableArray *faceName = [self getfaceName];
        
        NSString *deleteName = @"1";
        for (NSString *faceStr in faceName) {
            
            if ([muStr hasSuffix:faceStr]) {
                
                deleteName = faceStr;
                break;
            }
        }
        NSInteger deleteLong = [deleteName length];
        [muStr deleteCharactersInRange:NSMakeRange(muStr.length-deleteLong, deleteLong)];
        self.self.inputView.text = muStr;
    }
}


@end
