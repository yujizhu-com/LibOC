//
//  LibFile.hpp
//  kit
//
//  Created by 余纪柱 on 2023/3/13.
//

#ifndef LibFile_hpp
#define LibFile_hpp

#import <Foundation/Foundation.h>

@interface LibFile : NSObject
- (instancetype)init;
- (NSArray*) getFiles:(NSString *)path;
- (NSInteger) getSubPathCount:(NSString *)path;

@property (strong) NSArray* legalSuffixes;
@property BOOL ignoreEmptyDir;
@property BOOL ignoreHidden;

@end

#endif /* LibFile_hpp */
