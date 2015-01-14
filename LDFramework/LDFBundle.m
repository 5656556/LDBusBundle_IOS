//
//  LDFBundle.m
//  LDBusBundle
//
//  Created by 庞辉 on 1/7/15.
//  Copyright (c) 2015 庞辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDFBundle.h"
#import "LDFCommonDef.h"

#define IOSVERSION ([[[UIDevice currentDevice] systemVersion] intValue])

int const UNINSTALLED = 1;
int const INSTALLED = 2;
int const INSTALLING = 4;// 正在下载安装
int const HAS_NEWVERSION = 8;
int const STARTED = 16;// 已启动
int const STOPPED = 32;// 未启动

int const INSTALL_LEVEL_NONE = 0;// 不自动安装
int const INSTALL_LEVEL_WIFI = 1;// 仅WIFI下自动安装
int const INSTALL_LEVEL_ALL = 2;// 任意网络下均自动安装


@interface LDFBundle () {
    //是否动态加载
    BOOL _isDynamic;
}

@end


@implementation LDFBundle
@synthesize state = _state;
@synthesize crc32 = _crc32;
@synthesize identifier = _identifier;
@synthesize name = _name;

-(id) initBundleWithPath:(NSString *)path {
    id obj = nil;
    //处理static framework
    if([path.lastPathComponent hasSuffix:@".bundle"]){
        self = [super init];
        if(self){
            _isDynamic = NO;
            obj = self;
        }
    }
    
    //处理dynamic framework, 只有ios7以上的系统才动态加载
    else if([path.lastPathComponent hasSuffix:@".framework"]){
        if(IOSVERSION >= 7){
            self = [super initWithPath:path];
            if(self){
                _isDynamic = YES;
                obj = self;
            }
        } else {
            obj =  nil;
        }
    } else {
        obj = nil;
    }
    
    if(obj){
        _state = UNINSTALLED;
        //读取.bundle或者.framework中info.plist信息
    }
    
    return obj;
}

-(BOOL)start {
    if(_isDynamic && ![super isLoaded]){
        return [super load];
    } else {
        return YES;
    }
}


-(BOOL)stop {
    if(_isDynamic && [super isLoaded]){
        return [super unload];
    } else {
        return YES;
    }
}

-(int)state {
    return _state;
}


-(NSString *)name {
    if(_isDynamic){
        return [self.infoDictionary  objectForKey:BUNDLE_NAME];
    } else {
        //返回总线配置的bundle名字
        return @"";
    }
}


-(NSString *)identifier {
    if(_isDynamic){
        return [super bundleIdentifier];
    } else {
        //
        return @"";
    }
}

-(NSDictionary *) infoDictionary {
    if(_isDynamic){
        return  [super infoDictionary];
    } else {
        return nil;
    }
}


/**
 * 判断组件是否自启动
 */
-(BOOL) autoStartup {
#warning fixme
    return YES;
    return [[self.infoDictionary objectForKey:BUNDLE_AUTO_STARTUP] boolValue];
}


/**
 * 获取bundle支持的服务
 */
-(NSString *) exportServices {
    return [self.infoDictionary objectForKey:EXPORT_SERVICE];
}


/**
 * 获取bundle需要引入的服务
 */
-(NSString *) importServices{
    return [self.infoDictionary objectForKey:IMPORT_SERVICE];
}

/**
 * 获取bundle的自动安装的网络级别
 */
-(int)autoInstallLevel{
    id level = [self.infoDictionary objectForKey:BUNDLE_INSTALL_LEVEL];
    if(level && [level isKindOfClass:[NSString class]]){
        return [level intValue];
    }
    
    return INSTALL_LEVEL_NONE;
}




@end
