//
//  LDFBundleInstaller.m
//  LDBusBundle
//
//  Created by 庞辉 on 1/7/15.
//  Copyright (c) 2015 庞辉. All rights reserved.
//

#import "LDFDebug.h"
#import "LDFBundleInstaller.h"
#import "LDFFileManager.h"
#import "LDFBundle.h"

@interface LDFBundleInstaller () {
    NSArray *_myAppArchiteture;
}

@end



@implementation LDFBundleInstaller
@synthesize signature;

/**
 * 根据ipa的location 解压安装组件；
 * (1) 验证安装包的有效性：主要是验证ipa的crc32值， ipa打包framework的签名
 * (2) 验证framework是否支持主app要求支持的architeture；
 * (3) 解压ipa包到指定目录
 */
-(LDFBundle *)installBundleWithPath: (NSString *)filePath{
    LDFBundle *bundle = nil;
    //验证签名
    @try {
        if(![self checkCertificate:filePath]){
            LOG(@"signatures error: %@", filePath);
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    //获取ipa中所有文件的CRC值
    //第一次解压的时候，存储ipa的CRC32值，下次运行比较CRC的值是否变化
    long crc32OfIpa  = [LDFFileManager getCRC32:filePath];
    
    
    //解压文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *bundleCacheDir = [LDFFileManager bundleCacheDir];
    NSString *toDestInstallDir = [bundleCacheDir stringByAppendingFormat:@"/%@.framework", [[filePath lastPathComponent] stringByDeletingPathExtension]];
    if([fileManager fileExistsAtPath:toDestInstallDir]){
        if(![fileManager removeItemAtPath:toDestInstallDir error:&error]){
            LOG(@"delete the bundle Installed Dir: %@ failure!!!", toDestInstallDir);
        }
    }
    
    BOOL unzipSuccess = [LDFFileManager unZipFile:filePath destPath:bundleCacheDir];
    
    
    //解压成功之后，获取ipa中打包的framework支持的architeture的值
    //如果不支持，删掉刚才解压的目录
    if(unzipSuccess){
        BOOL isHasRequiredArchitetures = [self checkMatchingArchiteture:_myAppArchiteture inIpaFile:filePath];
        if(!isHasRequiredArchitetures){
            if(![fileManager removeItemAtPath:toDestInstallDir error:&error]){
                LOG(@"delete the bundle unzip Dir: %@ failure!!!", toDestInstallDir);
            }
        } else {
            bundle = [[LDFBundle alloc] initBundleWithPath:toDestInstallDir];
            if(bundle){
                bundle.crc32 = crc32OfIpa;
            }
        }
    }
    
    return bundle;
}


/**
 * 验证签名文件
 * fixme
 */
-(BOOL)checkCertificate:(NSString *)filePath{
    return YES;
}


/**
 * 判断安装组件是否支持当前host程序要求的architeture
 */
-(BOOL)checkMatchingArchiteture:(NSArray *)hostArchitetures inIpaFile:(NSString *)filePath {
    return YES;
}


-(BOOL)uninstallBundleWithName:(NSString *)bundleIdentifier{
    return YES;
}


-(void)getMyAppSupportedArchitectures {
    _myAppArchiteture = [NSBundle mainBundle].executableArchitectures;
}



@end
