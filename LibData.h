//
//  Data.h
//  kit
//
//  Created by 余纪柱 on 2023/2/16.
//

#ifndef KitData_h
#define KitData_h

#define ShellDir "/Users/yujizhu/Documents/Git/GithubShell"

#define CC_DEPRECATED_ATTRIBUTE __attribute__((deprecated))
@interface LibData : NSObject
{}
@property (strong) NSMutableDictionary* dic ;
@property (strong) NSString* file ;

- (BOOL)saveString:(NSString*)dir InArray:(NSString*)key;
- (NSMutableArray<NSString*>*)readAllStringInArray:(NSString*)key;



@property (strong) NSArray* legalSuffixes;
@property BOOL ignoreEmptyDir;
@property BOOL ignoreHidden;

-(NSMutableDictionary*) readDic:(NSString*)dic;
- (BOOL)saveString:(NSString*)value withKey:(NSString*)key inDic:(NSString*)dic;
- (void)saveDirTreeWithPath:(NSString*)path InDic:(NSString*)dic;
- (void)addFilesFromFolder:(NSString *)folderPath toDictionary:(NSMutableDictionary *)dictionary;

+ (LibData*) libDataWithFile:(NSString*)file;
+ (NSString*) getPathInWrite:(NSString*)subPath;
+ (NSString*) getDataPath CC_DEPRECATED_ATTRIBUTE;
+ (NSString*) getBundle;
+ (NSString*) getWritePath;
+ (NSString*) getTempPath;
+ (NSString*) getUserDefaultFile;
+ (NSString*) getLogFile;
+ (NSInteger) getByteOfFile:(NSString *)file;
+ (NSString*) getAutoSizeOfFile:(NSString *)file;
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
