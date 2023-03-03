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

- (BOOL)saveDir:(NSString*)dir AndKey:(NSString*)key;
- (NSMutableArray<NSString*>*)readDirs:(NSString*)key;

+ (LibData*) libDataFile:(NSString*)file;
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

extern LibFile *_libFile;
extern LibData *_libData;


#endif /* Data_h */
