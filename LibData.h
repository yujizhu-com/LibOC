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

- (instancetype)init;
- (BOOL)saveDir:(NSString*)dir AndKey:(NSString*)key;
- (NSMutableArray<NSString*>*)readDirs:(NSString*)key;

+ (NSString*) getPathInWrite:(NSString*)subPath;

+ (LibData*) getInstance;
+ (NSString*) getDataPath CC_DEPRECATED_ATTRIBUTE;
+ (NSString*) getBundle;
+ (NSString*) getWritePath;
+ (NSString*) getTempPath;
+ (NSString*) getUserDefaultFile;
+ (NSString*) getLogFile;
+ (NSInteger) getByteOfFile:(NSString *)file;
+ (NSString*) getAutoSizeOfFile:(NSString *)file;
+ (NSArray*) getFiles:(NSString *)file andIgnoreHiddenFiles:(BOOL)ignore;
+ (NSDictionary*)  getFilesDictInfo:(NSString *)path;
+ (BOOL) isPath:(NSString*)path;

@end

extern LibData *_libData;


#endif /* Data_h */
