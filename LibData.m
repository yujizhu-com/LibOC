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
LibFile *_libFile;
@implementation LibData

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

+ (LibData*) libDataFile:(NSString*)file
{
    LibData* libData = [[LibData alloc]init];
    libData.dic = [NSMutableDictionary dictionaryWithContentsOfFile:file];
    if(!libData.dic)
    {
        libData.dic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return libData;
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

+ (NSArray*) getFiles:(NSString *)path andIgnoreHidden:(BOOL)ignore withSuffix:(NSArray*)suffixes ignoreEmptyDir:(BOOL)ignoreEmptyDir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray* files = [[NSMutableArray alloc ] init];
    NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for (NSString *fileName in fileNames)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:fileName];
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir])
        {
            if (isDir)
            {
                if(ignoreEmptyDir)
                {
                    NSArray* innerFiles = [LibData getFiles:fullPath andIgnoreHidden:ignore withSuffix:suffixes ignoreEmptyDir:ignoreEmptyDir];
                    if([innerFiles count]>0)
                    {
                        [files addObject:fullPath];
                    }
                }
                else
                {
                    [files addObject:fullPath];
                }
            }
            else
            {
                if([fileName hasPrefix:@"."])
                {
                   if(!ignore)
                   {
                       [files addObject:fullPath];
                   }
                }
                else 
                {
                    BOOL legalSuffix = YES;
                    if([suffixes count]>0)
                    {
                        legalSuffix = NO;
                        for(NSString* s in suffixes)
                        {
                            legalSuffix = [fullPath hasSuffix:s];
                            if(legalSuffix) break;
                        }
                    }
                    if(legalSuffix)
                    {
                        [files addObject:fullPath];
                    }
                }
            }
        }
    }
    return files;
}


+ (BOOL) isPath:(NSString*)path
{
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    return isDir;
}

@end

@implementation LibFile

+ (LibFile*) getInstance
{
    if(!_libFile)
    {
        _libFile = [[LibFile alloc]init];
    }
    return _libFile;
}

- (instancetype)init
{
    self = [super init];
    self.legalSuffixes=nil;
    self.ignoreHidden=YES;
    self.ignoreEmptyDir=YES;
    return self;
}

-(NSArray*) getFiles:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray* files = [[NSMutableArray alloc ] init];
    NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for (NSString *fileName in fileNames)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:fileName];
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir])
        {
            if (isDir)
            {
                if(_ignoreEmptyDir)
                {
                    NSArray* innerFiles = [self getFiles:fullPath];
                    if([innerFiles count]>0)
                    {
                        [files addObject:fullPath];
                    }
                }
                else
                {
                    [files addObject:fullPath];
                }
            }
            else
            {
                if([fileName hasPrefix:@"."])
                {
                   if(!_ignoreHidden)
                   {
                       [files addObject:fullPath];
                   }
                }
                else
                {
                    BOOL legalSuffix = YES;
                    if([_legalSuffixes count]>0)
                    {
                        legalSuffix = NO;
                        for(NSString* s in _legalSuffixes)
                        {
                            legalSuffix = [fullPath hasSuffix:s];
                            if(legalSuffix) break;
                        }
                    }
                    if(legalSuffix)
                    {
                        [files addObject:fullPath];
                    }
                }
            }
        }
    }
    return files;
}

- (NSInteger) getSubPathCount:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSInteger count=0;
    NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for (NSString *fileName in fileNames)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:fileName];
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir])
        {
            if (isDir)
            {
                if(_ignoreEmptyDir)
                {
                    NSInteger subcount = [self getSubPathCount:fullPath];
                    if(subcount>0)
                    {
                        ++count;
                    }
                }
                else
                {
                    ++count;
                }
            }
            else
            {
                if([fileName hasPrefix:@"."])
                {
                   if(!_ignoreHidden)
                   {
                       ++count;
                   }
                }
                else
                {
                    BOOL legalSuffix = YES;
                    if([_legalSuffixes count]>0)
                    {
                        legalSuffix = NO;
                        for(NSString* s in _legalSuffixes)
                        {
                            legalSuffix = [fullPath hasSuffix:s];
                            if(legalSuffix) break;
                        }
                    }
                    if(legalSuffix)
                    {
                        ++count;
                    }
                }
            }
        }
    }
    return count;
}

@end
