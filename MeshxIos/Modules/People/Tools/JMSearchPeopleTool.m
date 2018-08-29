//
//  JMSearchPeopleTool.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/12.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMSearchPeopleTool.h"
#import "JMPeopleModel.h"

@implementation JMSearchPeopleTool

+ (void)searchWithString:(NSString *)searchStr result:(void(^)(BOOL isSuccess,NSArray <JMPeopleModel *>*dataArray))result{
    NSXMLElement *element = [self getElementWithSearchStr:searchStr];
    [JMXMPPTool sendElement:element result:^(BOOL isSuccess, XMPPElement *element, XMPPStream *sender) {
        
        if (isSuccess && element) {
            XMPPIQ *iq = (XMPPIQ *)element;
            NSString *elementID = iq.elementID;
            if (![elementID isEqualToString:kJMSearchByUserName]) {
                return;
            }
            result(YES,[self getPeopleWithWithXMPPIQ:iq]);
        }else{
            result(NO,nil);
        }
    }];
}

+ (NSXMLElement *)getElementWithSearchStr:(NSString *)str{
    str = [str lowercaseString];
    NSString *userBare1  = [[[JMXMPPTool sharedInstance].xmppStream myJID] bare];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
    [query addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:search"];
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    [x addAttributeWithName:@"type" stringValue:@"submit"];
    
    NSXMLElement *formType = [NSXMLElement elementWithName:@"field"];
    [formType addAttributeWithName:@"type" stringValue:@"hidden"];
    [formType addAttributeWithName:@"var" stringValue:@"FORM_TYPE"];
    [formType addChild:[NSXMLElement elementWithName:@"value" stringValue:@"jabber:iq:search" ]];
    
    NSXMLElement *userName = [NSXMLElement elementWithName:@"field"];
    [userName addAttributeWithName:@"var" stringValue:@"Username"];
    [userName addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1" ]];
    
    //    NSXMLElement *name = [NSXMLElement elementWithName:@"field"];
    //    [name addAttributeWithName:@"var" stringValue:@"Name"];
    //    [name addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    //
    //    NSXMLElement *email = [NSXMLElement elementWithName:@"field"];
    //    [email addAttributeWithName:@"var" stringValue:@"Email"];
    //    [email addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    //
    NSXMLElement *search = [NSXMLElement elementWithName:@"field"];
    [search addAttributeWithName:@"var" stringValue:@"search"];
    [search addChild:[NSXMLElement elementWithName:@"value" stringValue:str]];
    
    //    [x addChild:formType];
    [x addChild:userName];
    //    [x addChild:name];
    //[x addChild:email];
    [x addChild:search];
    [query addChild:x];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    [iq addAttributeWithName:@"id" stringValue:kJMSearchByUserName];
    [iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"search.%@",[[JMXMPPTool sharedInstance].xmppStream myJID].domain]];
    [iq addAttributeWithName:@"from" stringValue:userBare1];
    [iq addChild:query];
    return iq;
}

+ (NSArray *)getPeopleWithWithXMPPIQ:(XMPPIQ *)iq{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (DDXMLElement *element in iq.children) {
        if ([element.name isEqualToString:@"query"]) {
            for (DDXMLElement *x in element.children) {
                if ([x.name isEqualToString:@"x"]) {
                    for (DDXMLElement *item in x.children) {
                        if ([item.name isEqualToString:@"item"]) {
                            
                            for (DDXMLElement *field in item.children) {
                                if ([field.name isEqualToString:@"field"]) {
                                    NSString *var = [[field attributeForName:@"var"]stringValue];
                                    if ([var isEqualToString:@"Username"]) {
                                        XMPPJID *myJid =[[JMXMPPTool sharedInstance].xmppStream myJID];
                                        XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",field.stringValue,myJid.domain]];
                                        JMPeopleModel *model = [JMPeopleModel new];
                                        model.jid = jid;
                                        model.name = field.stringValue;
                                        if (![model.name isEqualToString:myJid.user]&&model.name.length>0) {
                                            [dataArray addObject:model];
                                        }
                                        
                                        //                                        NSLog(@"==%@==%@==",field.stringValue,jid.user);
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    return dataArray;
}

@end
