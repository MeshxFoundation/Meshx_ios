//
//  NSLogMacro.h
//  MacroDemo
//
//  Created by xiaozhu on 2017/6/11.
//  Copyright © 2017年 xiaozhu. All rights reserved.
//

#ifndef NSLogMacro_h
#define NSLogMacro_h

#pragma mark-自定义输出
//----------------------自定义输出----------------------------
//自定义输出
#ifdef DEBUG

#define MyLog(...) NSLog(__VA_ARGS__)

//重写NSLog,Debug模式下打印日志和当前行数
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }

#else
#define MyLog(...)
#define ULog(...)
#define NSLog(...) 
#endif

// 输出frame(frame是结构体，没法%@)
#define LOGRECT(f) NSLog(@"Rect: \nx:%f\ny:%f\nwidth:%f\nheight:%f\n",f.origin.x,f.origin.y,f.size.width,f.size.height)
// 输出BOOL值
#define LOGBOOL(b)  NSLog(@"%@",b?@"YES":@"NO");
// 输出对象方法
#define DNSLogMethod    NSLog(@"[%s] %@", class_getName([self class]), NSStringFromSelector(_cmd));
// 点
#define DNSLogPoint(p)  NSLog(@"%f,%f", p.x, p.y);
// Size
#define DNSLogSize(p)   NSLog(@"%f,%f", p.width, p.height);
//----------------------自定义输出----------------------------

#endif /* NSLogMacro_h */
