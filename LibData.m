//
//  Data.m
//  kit
//
//  Created by 余纪柱 on 2023/2/16.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LibData.h"
#import "LibOC.h"

@implementation LibData

#pragma mark - Array -
- (BOOL)saveString:(NSString*)dir InArray:(NSString*)key
{
    if(![dir length]) return false;
    BOOL saved = false;
    {
        NSMutableArray* obj = [LibData safeArray:_dic forKey:key];
        if([obj containsObject:dir])
        {
            saved = false;
        }
        else
        {
            saved = true;
            [obj addObject:dir];
            [self.dic writeToFile:_file atomically:false];
        }
    }
    return saved;
}

- (NSMutableArray<NSString*>*)readAllStringInArray:(NSString*)key
{
    NSMutableArray<NSString*>* dirs = [self.dic objectForKey:key];
    return dirs ;
}

- (NSString*)readLastInArray:(NSString*)key
{
    NSMutableArray<NSString*>* dirs = [self.dic objectForKey:key];
    return [dirs lastObject] ;
}

#pragma mark - Dict -

-(NSMutableDictionary*) readDic:(NSString*)dictName
{
    NSMutableDictionary *dict = [LibData safeDict:_dic forKey:dictName];
    return dict;
}

- (BOOL)saveString:(NSString*)value withKey:(NSString*)key inDic:(NSString*)dic
{
    NSMutableDictionary *directoryDict = [_dic objectForKey:key];
    if(!directoryDict)
    {
        directoryDict = [NSMutableDictionary dictionary];
    }
    [directoryDict setObject:value forKey:key];
    [_dic setObject:directoryDict forKey:dic];
    [_dic writeToFile:_file atomically:false];
    return YES;
}

- (void)saveDirTreeWithPath:(NSString*)path InDic:(NSString*)dic
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *dicChilds = [LibData safeDict:_dic forKey:@"Childs"];
    [dicChilds setObject:[NSMutableDictionary dictionary] forKey:path]; ///增加一个节点
    BOOL isDir;
    BOOL erase=NO;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir)
    {
        NSMutableDictionary *dir = [dicChilds objectForKey:path];
        NSMutableDictionary *dirChilds = [LibData safeDict:dir forKey:@"Childs"];
        [self addFilesFromFolder:path toDictionary:dirChilds];
        erase = dirChilds.count <=0;
    }
    if(erase)
    {
        [dicChilds removeObjectForKey:path];
    }
    [_dic writeToFile:_file atomically:false];
}

- (void)addFilesFromFolder:(NSString *)folderPath toDictionary:(NSMutableDictionary *)dictionary
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
    for (NSString *fileName in fileList) {
        NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
        NSMutableDictionary *node = [LibData safeDict:dictionary forKey:fileName];
        BOOL isDir;
        BOOL erase = NO;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) {
            NSMutableDictionary *nodeChild = [LibData safeDict:node forKey:@"Childs"];
            [self addFilesFromFolder:fullPath toDictionary:nodeChild];
            erase = nodeChild.count <=0;
        } else {
            if(_ignoreHidden && [fileName hasPrefix:@"."])
            {
                erase = YES ;
            }
            else
            {
                BOOL legalSuffix = YES;
                if([_legalSuffixes count]>0)
                {
                    NSString* suffix = [fileName pathExtension];
                    legalSuffix =  [_legalSuffixes containsObject:suffix];
                }
                if(!legalSuffix)
                {
                    erase = YES ;
                }
            }
        }
        if(erase)
        {
            [dictionary removeObjectForKey:fileName];
        }
    }
}

- (NSArray*)getChildKeysInNode:(NSString*)item
{
    NSMutableArray* array = [NSMutableArray array];
    NSMutableString* path = [NSMutableString string];
    NSMutableDictionary* node = [self getNode:item withPath:path];
    NSArray* keys = [[node objectForKey:@"Childs"] allKeys];
    for(NSString* key in keys)
    {
        NSString *fullpath = [path stringByAppendingPathComponent:key];
        [array addObject:fullpath];
    }
    return array ;
}

- (NSInteger)getChildCountInNode:(NSString*)item
{
    NSArray* childs = [self getChildKeysInNode:item];
    return [childs count];
}

- (NSMutableDictionary*)getNode:(NSString*)item withPath:(NSMutableString*)path
{
    NSMutableDictionary* node = nil;
    if(!item || item.length ==0)
    {
        node = _dic;
    }
    else
    {
        if([[item pathComponents]count]>0)
        {
            node = [self _getNode:item inNode:_dic withPath:path];
        }
    }
    return node;
}

- (NSMutableDictionary*)_getNode:(NSString*)item inNode:(NSMutableDictionary*)parent withPath:(NSMutableString*)path
{
    NSDictionary* childs = [parent objectForKey:@"Childs"];
    NSArray* keys = [childs allKeys];
    NSMutableDictionary* find = nil;
    for(NSString* key in keys)
    {
        NSString *key2 = [key stringByAppendingString:@"/"];
        if([item hasPrefix:key2] || [item isEqualToString:key])
        {
            NSString *pathString = item;
            NSArray *pathComponents = [pathString pathComponents];
            NSInteger keyPathComponentCount = [[key pathComponents] count];
            NSRange range = NSMakeRange(keyPathComponentCount,[pathComponents count]-keyPathComponentCount);
            NSArray *remainingComponents = [pathComponents subarrayWithRange:range];
            NSString *nextItem = [NSString pathWithComponents:remainingComponents];
            NSMutableDictionary* nextNode = [childs objectForKey:key];
            NSString* nextPath = [path stringByAppendingPathComponent:key];
            [path setString:nextPath];
            if([[nextItem pathComponents]count] >= 1)
            {
                find = [self _getNode:nextItem inNode:nextNode withPath:path];
            }
            else if([[nextItem pathComponents]count] == 0)
            {
                find = nextNode;
            }
        }
        if(find)
        {
            break;
        }
    }
    return find;
}

- (void)removeNode:(NSString*)item inParent:(NSString*)parentItem
{
    NSMutableDictionary* parent = [self getNode:parentItem withPath:[NSMutableString string]];
    NSInteger parentParts = [[parentItem pathComponents] count];
    NSInteger nodeParts = [[item pathComponents] count];
    NSRange range = NSMakeRange(parentParts,nodeParts - parentParts);
    NSArray *remain = [[item pathComponents] subarrayWithRange:range];
    NSString *shortName = [NSString pathWithComponents:remain];
    NSMutableDictionary* childs = [LibData safeDict:parent forKey:@"Childs"];
    [childs removeObjectForKey:shortName];
    [self save];
}

+ (NSMutableDictionary*)safeDict:(NSMutableDictionary*)node forKey:(NSString*)key
{
    if(![node objectForKey:key])
    {
        [node setObject:[NSMutableDictionary dictionary] forKey:key]; ///子节点列表
    }
    NSMutableDictionary *value = [node objectForKey:key];
    return value;
}

+ (NSMutableArray*)safeArray:(NSMutableDictionary*)node forKey:(NSString*)key
{
    if(![node objectForKey:key])
    {
        [node setObject:[NSMutableArray array] forKey:key]; ///子节点列表
    }
    NSMutableArray *value = [node objectForKey:key];
    return value;
}

- (NSString*)getNodeProperty:(NSString*)item forKey:(NSString*)key withValue:(NSString*)defaultValue
{
    NSMutableDictionary* node = [self getNode:item withPath:[NSMutableString string]];
    NSString* value = nil;
    if(node)
    {
        NSMutableDictionary* property = [LibData safeDict:node forKey:@"Property"];
        value = [property objectForKey:key];
        if(!value)
        {
            value = defaultValue;
        }
    }
    return value;
}

- (void)saveNodeProperty:(NSString*)item forKey:(NSString*)key withValue:(NSString*)value save:(BOOL)save
{
    NSMutableDictionary* node = [self getNode:item withPath:[NSMutableString string]];
    if(node)
    {
        NSMutableDictionary* property = [LibData safeDict:node forKey:@"Property"];
        [property setObject:value forKey:key];
    }
    if(save)
    {
        [self save];
    }
}

///另存为
- (void)saveTo:(NSString*)file
{
    [_dic writeToFile:file atomically:false];
}

- (void)save
{
    [_dic writeToFile:_file atomically:false];
}

///遍历
-(void)traverse:(NSString*)item useBlock:(void(^)(NSString*,NSString*))block
{
    NSString* fullPath = [NSString string];
    NSString* path = [NSString string];
    BOOL find = NO;
    [self _traverse:_dic useBlock:block forItem:(NSString*)item withFullPath:fullPath withPath:path withFind:&find];
}

-(void)_traverse:(NSDictionary*)dic
        useBlock:(void(^)(NSString*,NSString*))block
         forItem:(NSString*)item
    withFullPath:(NSString*)fullPath
        withPath:(NSString*)simplePath
        withFind:(BOOL*)find;
{
    NSDictionary* childs = [dic objectForKey:@"Childs"];
    NSArray* keys = [childs allKeys];
    for(NSString* key in keys)
    {
        NSString* nowFullPath = [fullPath stringByAppendingPathComponent: key];
        NSString* nowSimplePath = [simplePath stringByAppendingPathComponent:[key lastPathComponent]];
        if((!*find) && (item==nil || [item isEqualToString:nowFullPath]))
        {
            *find = YES;
        }
        if(*find)
            block(nowFullPath,nowSimplePath);
        NSDictionary* node = [childs objectForKey:key];
        if(node)
        {
            [self _traverse:node
                   useBlock:block
                    forItem:item
               withFullPath:nowFullPath
                   withPath:nowSimplePath
                   withFind:find
            ];
        }
        if((*find) && [item isEqualToString:nowFullPath])
        {
            *find = NO;
        }
    }
}



+ (LibData*) libDataWithFile:(NSString*)file
{
    LibData* libData = [[LibData alloc]init];
    if(file && file.length)
    {
        libData.file = file;
        libData.dic = [NSMutableDictionary dictionaryWithContentsOfFile:file];
        if(!libData.dic)
        {
            libData.dic = [NSMutableDictionary dictionary];
        }
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
    NSString* fullPath = [dir stringByAppendingPathComponent:file];
    return fullPath;
}

+ (NSString*) getLogFile
{
    NSString* dir = [LibData getWritePath];
    NSString* file = [NSString stringWithFormat:@"log.txt"];
    NSString* fullPath = [dir stringByAppendingPathComponent:file];
    return fullPath;
}

+ (NSInteger)getByteOfFile:(NSArray *)files
{
    NSInteger size = 0;
    for(NSString* file in files)
    {
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isDir] && !isDir)
        {
            NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
            size += [dict fileSize];
        }
    }
    return size;
}

+ (NSString*) getAutoSizeOfFiles:(NSArray *)files
{
    NSInteger B = [LibData getByteOfFile:files];
    NSInteger MB = B/1000000;
    NSInteger KB = B/1000.0;
    float r;
    if(MB>0)
    {
        r=B/1000000.0;
        return [NSString stringWithFormat:@"%.2f M",r];
    }
    else if(KB>0)
    {
        r=B/1000.0;
        return [NSString stringWithFormat:@"%.2f K",r];
    }
    else
    {
        r=B;
        return [NSString stringWithFormat:@"%.2f Byte",r];
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
                        NSString* suffix = [fileName pathExtension];
                        legalSuffix =  [suffixes containsObject:suffix];
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
