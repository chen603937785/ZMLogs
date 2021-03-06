//
//  YSXLogs.m
//  YunShixun
//
//  Created by chen on 2020/5/19.
//  Copyright © 2020 chen. All rights reserved.
//

#import "YSXLogs.h"
#import "NSString+LogCategory.h"
#define LOG_ASYNC_ERROR    ( NO && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_WARN     (YES && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_INFO     (YES && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_DEBUG    (YES && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_VERBOSE  (YES && LOG_ASYNC_ENABLED)

#define LOG_FLAG_ERROR    DDLogFlagError
#define LOG_FLAG_WARN     DDLogFlagWarning
#define LOG_FLAG_INFO     DDLogFlagInfo
#define LOG_FLAG_DEBUG    DDLogFlagDebug
#define LOG_FLAG_VERBOSE  DDLogFlagVerbose

@implementation YSXLogs

/**
 LOG_ASYNC_VERBOSE 是否异步
 LOG_LEVEL_DEF 级别
 LOG_FLAG_VERBOSE flg
 0  ctx
 frmt 内容
 */
+ (void (^)(id,YSXLogStatus ,DDLogLevel))Log{
    return ^(id msg,YSXLogStatus tagValue,DDLogLevel level){
    
    NSArray *tagsName = @[@"httpapi",@"request",@"response",@"timeout",@"params",@"onclick",@"config",@"action",@"event",@"meeting",@"contact",@"im",@"filehead"];
        
      NSArray *tags = [YSXLogs getTags:tagValue];
        
        NSMutableString *tagStr = [[NSMutableString alloc] init];
        if (tags != nil) {
            for (int i = 0; i<tags.count; i++) {
                if (![tags[i] isKindOfClass:[NSNumber class]]) {
                    return;
                }
                NSInteger index = [tags[i] integerValue];
                if (index == 1) {
                    [tagStr appendString:[tagsName objectAtIndex:i]];
                    if (i == tags.count - 1) break;
                    [tagStr appendString:@","];
                }
            }
        }
        
        YSXLogs.LogAll(msg,tagStr,level);
    };
    
}

+ (void (^)(id,NSString *,DDLogLevel))LogAll{
    return ^(id msg,NSString *tagStr,DDLogLevel level){
        NSString *message = msg;
        if ([msg isKindOfClass: [NSArray class]] || [msg isKindOfClass:[NSMutableArray class]]) {
           message = [NSString objArrayToJSON:msg];
        }else if ([msg isKindOfClass: [NSDictionary class]] || [msg isKindOfClass: [NSMutableDictionary class]] ){
            message = [NSString convertToJsonData:msg];
        }
        
        DDLogFlag flgValue = LOG_FLAG_INFO;
        NSString *ler = @"I";
        
        BOOL isAsynchronous = YES;
        switch (level) {
            case DDLogLevelError:{
                isAsynchronous = LOG_ASYNC_ERROR;
                flgValue = LOG_FLAG_ERROR;
                ler = @"E";
            }
                break;
            case DDLogLevelWarning:{
                isAsynchronous = LOG_ASYNC_WARN;
                flgValue = LOG_FLAG_WARN;
                ler = @"W";
            }
                break;
            case DDLogLevelInfo:{
                isAsynchronous = LOG_ASYNC_INFO;
                flgValue = LOG_FLAG_INFO;
                ler = @"I";
            }
                break;
            case DDLogLevelDebug:{
                isAsynchronous = LOG_ASYNC_DEBUG;
                flgValue = LOG_FLAG_DEBUG;
                 ler = @"D";
            }
                break;
            case DDLogLevelVerbose:{
                isAsynchronous = LOG_ASYNC_VERBOSE;
                flgValue = LOG_FLAG_VERBOSE;
                 ler = @"I";
            }
                break;
                
            default:{
                
            }
                break;
        }
        
        NSString*str = [NSString stringWithFormat:@"|%@|%@|%@",ler,tagStr,message];
        
        [DDLog log:isAsynchronous level:LOG_LEVEL_DEF flag:flgValue context:0 file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ tag:0 format:(str),nil];
    };
}

+ (NSArray *)getTags:(NSInteger)value{
    
    NSMutableArray *arr = [NSMutableArray array];
        while (value>0) {
           
            if ((value&1) == 1) {
                [arr addObject:@1];
            }else{
                 [arr addObject:@0];
            }
             value>>=1;
        }
    return arr;
}

+ (void)log:(NSString *)msg tags:(NSString *)tagString level:(DDLogLevel)level{
    YSXLogs.LogAll(msg,tagString,level);
}

+ (void)log:(NSString *)msg tagType:(YSXLogStatus )tags level:(DDLogLevel)level{
    YSXLogs.Log(msg,tags,level);
}

+ (void)logLevelError:(NSString *)msg tags:(NSString *)tagString {
    YSXLogs.LogAll(msg,tagString,DDLogLevelError);
}

+ (void)logLevelError:(NSString *)msg tagType:(YSXLogStatus)tags {
    YSXLogs.Log(msg,tags,DDLogLevelError);
}

+ (void)logLevelInfo:(NSString *)msg tags:(NSString *)tagString {
    YSXLogs.LogAll(msg,tagString,DDLogLevelInfo);
}

+ (void)logLevelInfo:(NSString *)msg tagType:(YSXLogStatus)tags {
    YSXLogs.Log(msg,tags,DDLogLevelInfo);
}

+ (void)logLevelDebug:(NSString *)msg tags:(NSString *)tagString {
    YSXLogs.LogAll(msg,tagString,DDLogLevelDebug);
}

+ (void)logLevelDebug:(NSString *)msg tagType:(YSXLogStatus)tags {
    YSXLogs.Log(msg,tags,DDLogLevelDebug);
}

+ (void)logLevelWarning:(NSString *)msg tags:(NSString *)tagString {
    YSXLogs.LogAll(msg,tagString,DDLogLevelWarning);
}

+ (void)logLevelWarning:(NSString *)msg tagType:(YSXLogStatus)tags {
    YSXLogs.Log(msg,tags,DDLogLevelWarning);
}

+ (void)logLevelVerbose:(NSString *)msg tags:(NSString *)tagString {
    YSXLogs.LogAll(msg,tagString,DDLogLevelVerbose);
}

+ (void)logLevelVerbose:(NSString *)msg tagType:(YSXLogStatus)tags {
    YSXLogs.Log(msg,tags,DDLogLevelVerbose);
}

+ (void (^)(id,YSXLogStatus))logLevelError{
    return ^(id msg,YSXLogStatus tagValue){
        YSXLogs.Log(msg,tagValue,DDLogLevelError);
    };
}

+ (void (^)(id,YSXLogStatus))logLevelInfo{
    return ^(id msg,YSXLogStatus tagValue){
        
        YSXLogs.Log(msg,tagValue,DDLogLevelInfo);
    };
}

+ (void (^)(id,YSXLogStatus))logLevelWarning{
    return ^(id msg,YSXLogStatus tagValue){
        YSXLogs.Log(msg,tagValue,DDLogLevelWarning);
    };
}

+ (void (^)(id,YSXLogStatus))logLevelVerbose{
    return ^(id msg,YSXLogStatus tagValue){
        YSXLogs.Log(msg,tagValue,DDLogLevelVerbose);
    };
}

+ (void (^)(id,YSXLogStatus))logLevelDebug{
    return ^(id msg,YSXLogStatus tagValue){
        YSXLogs.Log(msg,tagValue,DDLogLevelDebug);
    };
}


@end
