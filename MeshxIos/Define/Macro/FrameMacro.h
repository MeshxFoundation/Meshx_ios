//
//  FrameMacro.h
//  MacroDemo
//
//  Created by xiaozhu on 2017/6/10.
//  Copyright © 2017年 xiaozhu. All rights reserved.
//

#ifndef FrameMacro_h
#define FrameMacro_h

//屏幕固定高度
//----------------------屏幕固定高度----------------------------
#define UI_NAVIGATION_BAR_HEIGHT        44
#define UI_TOOL_BAR_HEIGHT              44
#define UI_TAB_BAR_HEIGHT               49
#define UI_STATUS_BAR_HEIGHT            20
//----------------------屏幕固定高度----------------------------

#pragma mark- Frame
//----------------------Frame----------------------------
//获取 Frame 的 x，y 坐标
#define FRAME_TX(frame)  (frame.origin.x)
#define FRAME_TY(frame)  (frame.origin.y)
//获取 Frame 的宽高
#define FRAME_W(frame)  (frame.size.width)
#define FRAME_H(frame)  (frame.size.height)
//----------------------Frame----------------------------


#pragma mark- UIView Frame
//----------------------UIView Frame----------------------------
//获取 UIView Frame 的 x，y 坐标
#define VIEW_TX(view) (view.frame.origin.x)
#define VIEW_TY(view) (view.frame.origin.y)
//获取 UIView Frame 的宽高
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)
//----------------------UIView Frame----------------------------


#endif /* FrameMacro_h */
