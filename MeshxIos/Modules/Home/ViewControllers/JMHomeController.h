//
//  JMHomeController.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/11.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSearchChatContentController.h"
#import "JMBaseSearchController.h"
#import "JMHomeMsgProcess.h"
@interface JMHomeController : JMBaseSearchController<JMSearchChatContentControllerDelegate>
@property (nonatomic ,strong) JMHomeMsgProcess *msgProcess;
@property (nonatomic ,strong) NSMutableArray *dataSources;
@end
