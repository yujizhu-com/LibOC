//
//  Data.h
//  kit
//
//  Created by 余纪柱 on 2023/2/16.
//

#ifndef KitData_h
#define KitData_h

#define ShellDir "/Users/yujizhu/Documents/Git/GithubShell"

static NSMutableDictionary* _dic ;
@interface LibData : NSObject
{
    
}

+ (BOOL)saveDir:(NSString*)dir AndKey:(NSString*)key;
+ (NSMutableArray<NSString*>*)readDirs:(NSString*)key;

+ (NSString*) getDataPath;

@end


#endif /* Data_h */
