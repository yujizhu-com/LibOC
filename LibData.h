//
//  Data.h
//  kit
//
//  Created by 余纪柱 on 2023/2/16.
//

#ifndef KitData_h
#define KitData_h

#import <Cocoa/Cocoa.h>

#define ShellDir "/Users/yujizhu/Documents/Git/GithubShell"

#define CC_DEPRECATED_ATTRIBUTE __attribute__((deprecated))

@interface LibData : NSObject
{}
@property (strong) NSMutableDictionary* dic ;
@property (strong) NSString* file ;

///保存数组
///格式1 : key-数组
- (BOOL)saveString:(NSString*)dir InArray:(NSString*)key;
- (NSMutableArray<NSString*>*)readAllStringInArray:(NSString*)key;
- (NSString*)readLastInArray:(NSString*)key;

///保存字典
///格式2 : key-字典
@property (strong) NSArray* legalSuffixes;
@property (strong) NSOutlineView* outlineView;
@property BOOL ignoreEmptyDir;
@property BOOL ignoreHidden;

-(NSMutableDictionary*) readDic:(NSString*)dic;
- (BOOL)saveString:(NSString*)value withKey:(NSString*)key inDic:(NSString*)dic;
- (void)saveDirTreeWithPath:(NSString*)path InDic:(NSString*)dic;
- (void)addFilesFromFolder:(NSString *)folderPath toDictionary:(NSMutableDictionary *)dictionary;
- (NSArray*)getChildKeysInNode:(NSString*)item;
- (NSInteger)getChildCountInNode:(NSString*)item ;
- (NSMutableDictionary*)getNode:(NSString*)item
                       withPath:(NSMutableString*)path;
- (void)removeNode:(NSString*)item inParent:(NSString*)parentItem;
- (NSMutableDictionary*)_getNode:(NSString*)item
                          inNode:(NSMutableDictionary*)dic
                        withPath:(NSMutableString*)path;
- (NSString*)getNodeProperty:(NSString*)item
                      forKey:(NSString*)key
                   withValue:(NSString*)defaultValue;
- (void)saveNodeProperty:(NSString*)item forKey:(NSString*)key withValue:(NSString*)value save:(BOOL)save;

///另存为
- (void)saveTo:(NSString*)file;
- (void)save;
///遍历
-(void)traverse:(NSString*)item
              useBlock:(void(^)(NSString*,NSString*))block;
-(void)_traverse:(NSDictionary*)dic
        useBlock:(void(^)(NSString*,NSString*))block
         forItem:(NSString*)item
    withFullPath:(NSString*)fullpath
        withPath:(NSString*)simplepath
        withFind:(BOOL*)find;

+ (NSMutableDictionary*)safeDict:(NSMutableDictionary*)node forKey:(NSString*)key;
+ (NSMutableArray*)safeArray:(NSMutableDictionary*)node forKey:(NSString*)key;
+ (LibData*) libDataWithFile:(NSString*)file;
+ (NSString*) getPathInWrite:(NSString*)subPath;
+ (NSString*) getDataPath CC_DEPRECATED_ATTRIBUTE;
+ (NSString*) getBundle;
+ (NSString*) getWritePath;
+ (NSString*) getTempPath;
+ (NSString*) getUserDefaultFile;
+ (NSString*) getLogFile;
+ (NSInteger) getByteOfFile:(NSArray *)files;
+ (NSString*) getAutoSizeOfFiles:(NSArray *)file;
+ (NSArray*) getFiles:(NSString *)path
 andIgnoreHidden:(BOOL)ignore
           withSuffix:(NSArray*)suffixes
          ignoreEmptyDir:(BOOL)ignoreEmptyDir;
+ (BOOL) isPath:(NSString*)path;

@end

@interface LibFile : NSObject
- (instancetype)init;
- (NSArray*) getFiles:(NSString *)path;
- (NSInteger) getSubPathCount:(NSString *)path;

@property (strong) NSArray* legalSuffixes;
@property BOOL ignoreEmptyDir;
@property BOOL ignoreHidden;

@end

#endif /* Data_h */
