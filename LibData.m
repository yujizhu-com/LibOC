//
//  Data.m
//  kit
//
//  Created by 余纪柱 on 2023/2/16.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LibData.h"

LibData *_libData;
@implementation LibData{}

- (instancetype)init
{
    self = [super init];
    self.dic = [NSMutableDictionary dictionaryWithContentsOfFile:[LibData getUserDefaultFile]];
    if(!self.dic)
    {
        self.dic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (BOOL)saveDir:(NSString*)dir AndKey:(NSString*)key
{
    if(![dir length]) return false;
    BOOL saved = false;
    {
        NSMutableArray* obj = [self.dic objectForKey:key];
        if(!obj)
        {
            [self.dic setObject:[NSMutableArray arrayWithCapacity:0] forKey:key];
            obj = [self.dic objectForKey:key];
        }
        if(![obj containsObject:dir])
        {
            saved = true;
            [obj addObject:dir];
            [self.dic writeToFile:[LibData getUserDefaultFile] atomically:false];
        }
        else
        {
            saved = false;
        }
    }
    return saved;
}

- (NSMutableArray<NSString*>*)readDirs:(NSString*)key
{
    NSMutableArray<NSString*>* dirs = [self.dic objectForKey:key];
    return dirs ;
}

+ (NSString*) getPathInWrite:(NSString*) subPath
{
    NSString* path = [LibData getWritePath];
    path = [path stringByAppendingPathComponent:subPath];
    
    NSFileManager* fm = NSFileManager.defaultManager ;
    if(![fm fileExistsAtPath:path isDirectory:nil])
    {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (LibData*) getInstance
{
    if(!_libData)
    {
        _libData = [[LibData alloc]init];
    }
    return _libData;
}

+ (NSString*) getDataPath
{
    NSString* path = [LibData getUserDefaultFile];
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
    dir = [dir stringByAppendingPathComponent:[LibData getBundle]];
    NSFileManager* fm = NSFileManager.defaultManager ;
    if(![fm fileExistsAtPath:dir isDirectory:nil])
    {
        [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dir;
}

+ (NSString*) getTempPath
{
    NSString* dir=[LibData getPathInWrite:@"temp"];
    return dir;
}

+ (NSString*) getUserDefaultFile
{
    NSString* dir = [LibData getWritePath];
    NSString* file = [NSString stringWithFormat:@"%@%@",[LibData getBundle],@".txt"];
    dir = [dir stringByAppendingPathComponent:file];
    return file;
}

+ (NSString*) getLogFile
{
    NSString* dir = [LibData getWritePath];
    NSString* file = [NSString stringWithFormat:@"log.txt"];
    dir = [dir stringByAppendingPathComponent:file];
    return file;
}

+ (NSInteger)getByteOfFile:(NSString *)file
{
    BOOL isDirectory;
    NSInteger size = 0;
    NSFileManager * manager = [NSFileManager defaultManager];
    [manager fileExistsAtPath:file isDirectory:&isDirectory];
    if (!isDirectory)
    {
        NSDictionary *dict = [manager attributesOfItemAtPath:file error:nil];
        size += [dict fileSize];
    }
    return size;
}

+ (NSString*) getAutoSizeOfFile:(NSString *)file
{
    NSInteger B = [LibData getByteOfFile:file];
    NSInteger MB = B/1000000;
    NSInteger KB = B/1000.0;
    float r;
    if(MB>0)
    {
        r=B/1000000.0;
        return [NSString stringWithFormat:@"%.2f MB",r];
    }
    else if(KB>0)
    {
        r=B/1000.0;
        return [NSString stringWithFormat:@"%.2f KB",r];
    }
    else
    {
        r=B;
        return [NSString stringWithFormat:@"%.2f byte",r];
    }
}

@end
