//
//  LibApp.cpp
//  kit
//
//  Created by 余纪柱 on 2023/3/13.
//

#import "LibApp.h"
@implementation LibApp
+ (NSString*) getPathInWrite:(NSString*) subPath
{
    NSString* path = [LibApp getWritePath];
    path = [path stringByAppendingPathComponent:subPath];
    
    NSFileManager* fm = NSFileManager.defaultManager ;
    if(![fm fileExistsAtPath:path isDirectory:nil])
    {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString*) getDataPath
{
    NSString* path = [LibApp getUserDefaultFile];
    return path;
}

+ (NSString*) getBundle
{
    NSString* bundle=[[NSBundle mainBundle] bundleIdentifier];
    return bundle;
}

+ (NSString*) getWritePath
{
    NSString* dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject ];
    dir = [dir stringByAppendingPathComponent:[LibApp getBundle]];
    NSFileManager* fm = NSFileManager.defaultManager ;
    if(![fm fileExistsAtPath:dir isDirectory:nil])
    {
        [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dir;
}

+ (NSString*) getTempPath
{
    NSString* dir=[LibApp getPathInWrite:@"temp"];
    return dir;
}

+ (NSString*) getUserDefaultFile
{
    NSString* dir = [LibApp getWritePath];
    NSString* file = [NSString stringWithFormat:@"%@%@",[LibApp getBundle],@".txt"];
    NSString* fullPath = [dir stringByAppendingPathComponent:file];
    return fullPath;
}

+ (NSString*) getLogFile
{
    NSString* fullPath = [[LibApp getWritePath] stringByAppendingPathComponent:@"log.txt"];
    return fullPath;
}

@end
