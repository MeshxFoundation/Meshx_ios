//
//  JMChatSelectedMsgProcess.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/22.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMChatSelectedMsgProcess.h"
#import "JMChatController.h"
#import "JMPeopleModel.h"
@interface JMChatSelectedMsgProcess ()<PlayingDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;
@property (nonatomic ,weak) JMChatController *chatController;
@end

@implementation JMChatSelectedMsgProcess
- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super init]) {
        _chatController = (JMChatController *)viewController;
    }
    return self;
}

- (void)multiMediaMessageDidSelectedOnMessage:(XHMessage *)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell{
    
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypePhoto:{
            [self selectPhotoWithMessage:message];
        }
            
            break;
        case XHBubbleMessageMediaTypeVideo:
            
            break;
        case XHBubbleMessageMediaTypeEmotion:
            DLog(@"facePath : %@", message.emotionPath);
            break;
#pragma mark  ＝＝＝＝＝＝ 语音点击方法＝＝＝＝＝＝＝＝
        case XHBubbleMessageMediaTypeVoice: {
            DLog(@"message : %@", message.voicePath);
            [self selectVoiceMessage:message onMessageTableViewCell:messageTableViewCell];
            break;
        }
        default:
            break;
    }
}

//头像点击
- (void)didSelectedAvatarOnMessage:(XHMessage *)message atIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)selectVoiceMessage:(XHMessage *)message onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell{
    
    //接收者
    if (message.bubbleMessageType ==XHBubbleMessageTypeReceiving ) {
        if (!message.isReadVoice) {
            message.isReadVoice = YES;
            messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES;
            //已经听过语音，更新数据
            [XHMessage bg_update:nil where:[NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"isReadVoice"),bg_sqlValue(@(YES)),bg_sqlKey(@"eventID"),bg_sqlValue(message.eventID)]];
        }
    }
    [self playVoiceMessage:message onMessageTableViewCell:messageTableViewCell];
}

- (void)playVoiceMessage:(XHMessage *)message onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell{
    if (_currentSelectedCell) {
        [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    }
    if (_currentSelectedCell == messageTableViewCell) {
        [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
        [[PlayerManager sharedManager] stopPlaying];
        self.currentSelectedCell = nil;
    } else {
        self.currentSelectedCell = messageTableViewCell;
        [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
        [[PlayerManager sharedManager] playAudioWithFileName:[message voicePath] delegate:self];
    }
}

//图片点击处理事件
- (void)selectPhotoWithMessage:(XHMessage *)message{
    
    NSInteger index = [self.chatController.msgProcess.photoMessageSources indexOfObject:message];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    //分享按钮
    browser.displayActionButton = YES;
    //显示tool
    browser.displayNavArrows = YES;
    //隐藏导航栏
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:index];
    [self.chatController.navigationController pushViewController:browser animated:YES];
}

#pragma mark ===================图片分享处理事件=================
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MWPhoto *mwPhoto = self.chatController.msgProcess.photoSources[index];
        //保存图片到相册
        UIImageWriteToSavedPhotosAlbum(mwPhoto.image, self, @selector(image:didFinshSavingWithError:contextInfo:), nil);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self.chatController presentViewController:alert animated:YES completion:nil];
    NSLog(@"index:%ld",index);
}

#pragma mark ===================MWPhotoBrowserDelegate=================

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.chatController.msgProcess.photoSources.count;
}


- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.chatController.msgProcess.photoSources.count) {
        return [self.chatController.msgProcess.photoSources objectAtIndex:index];
    }
    return nil;
}

- (void)image:(UIImage *)image didFinshSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    
    if (error == nil) {
        
        [LCProgressHUD showSuccess:@"已保存到相册"];
        
    }else {
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app名称
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *title = [NSString stringWithFormat:@"保存失败，请在“设置”中查看 %@ 是否可以访问照片",app_Name];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self.chatController presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark ==========playDelegate=====

- (void)playingStoped{
    
    if (!_currentSelectedCell) {
        return;
    }
    [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    self.currentSelectedCell = nil;
}

@end
