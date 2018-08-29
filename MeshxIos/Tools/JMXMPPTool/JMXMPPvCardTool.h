//
//  JMXMPPvCardTool.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/27.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

typedef void(^updateMyCard)(BOOL isSuccess,XMPPvCardTemp *myCard);

@interface JMXMPPvCardTool : NSObject<XMPPvCardAvatarDelegate,XMPPvCardTempModuleDelegate>

@property (nonatomic ,strong) XMPPvCardTempModule *vCardModule;
@property (nonatomic ,strong) XMPPvCardAvatarModule *vCardAvatar;
@property (nonatomic ,strong) XMPPvCardCoreDataStorage *vCardStorage;
- (void)updateMyCardWithResult:(updateMyCard)result;
- (void)clearData;
@end
