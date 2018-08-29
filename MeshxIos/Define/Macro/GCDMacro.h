//
//  GCDMacro.h
//  MacroDemo
//
//  Created by xiaozhu on 2017/6/10.
//  Copyright © 2017年 xiaozhu. All rights reserved.
//

#ifndef GCDMacro_h
#define GCDMacro_h

/**
 子线程
 用法：GCDGlobalQueue(^{
 
 });
 */
#define GCDGlobalQueue(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
/**
 主线程
 */
#define GCDMainQueue(block) dispatch_async(dispatch_get_main_queue(), block)
/**
 延时操作
 time:时间秒
 block:回调函数
 用法 GCDAfterTime(2,^{
 
 });
 */
#define GCDAfterTime(time,block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), block)

//GCD - 一次性执行
#define GCDDispatch_once(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);


#endif /* GCDMacro_h */
