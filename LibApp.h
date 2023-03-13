//
//  LibApp.hpp
//  kit
//
//  Created by 余纪柱 on 2023/3/13.
//

#ifndef LibApp_hpp
#define LibApp_hpp

#import <Foundation/Foundation.h>

#define CC_DEPRECATED_ATTRIBUTE __attribute__((deprecated))

@interface LibApp : NSObject

+ (NSString*) getPathInWrite:(NSString*)subPath;
+ (NSString*) getDataPath CC_DEPRECATED_ATTRIBUTE;
+ (NSString*) getBundle;
+ (NSString*) getWritePath;
+ (NSString*) getTempPath;
+ (NSString*) getUserDefaultFile;
+ (NSString*) getLogFile;

@end

#endif /* LibApp_hpp */
