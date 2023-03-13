//
//  LibFile.cpp
//  kit
//
//  Created by 余纪柱 on 2023/3/13.
//

#include "LibFile.h"

@implementation LibFile

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
                        NSString* suffix = [fileName pathExtension];
                        legalSuffix =  [_legalSuffixes containsObject:suffix];
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
                        NSString* suffix = [fileName pathExtension];
                        legalSuffix =  [_legalSuffixes containsObject:suffix];
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
