//
//  Data.m
//  kit
//
//  Created by 余纪柱 on 2023/2/16.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LibData.h"

@implementation LibData{}

+ (void)initialize
{
    _dic = [NSMutableDictionary dictionaryWithContentsOfFile:[LibData getDataPath]];
    if(!_dic)
    {
        _dic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
}

+ (NSString*) getDataPath
{
    NSString* doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject ];
    doc = [doc stringByAppendingString:@"/com.yujizhu.kit"];
    
    NSFileManager* fm = NSFileManager.defaultManager ;
    if(![fm fileExistsAtPath:doc isDirectory:nil])
    {
        [fm createDirectoryAtPath:doc withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* path = [doc stringByAppendingPathComponent:@"/CoreData_1.txt"];
    return path;
}


//+ (BOOL)saveDirsForGitView:(NSString*)dir
//{
//
//}
//
//+ (NSMutableArray<NSString*>*)readDirsForGitView
//{
//
//}

+ (BOOL)saveDir:(NSString*)dir AndKey:(NSString*)key
{
    if(![dir length]) return false;
    BOOL saved = false;
    {
        NSMutableArray* obj = [_dic objectForKey:key];
        if(!obj)
        {
            [_dic setObject:[NSMutableArray arrayWithCapacity:0] forKey:key];
            obj = [_dic objectForKey:key];
        }
        if(![obj containsObject:dir])
        {
            saved = true;
            [obj addObject:dir];
            [_dic writeToFile:[LibData getDataPath] atomically:false];
        }
        else
        {
            saved = false;
        }
    }
    return saved;
//    {
//        [_array addObject:(dir)];
//
//        DMArrayTransformer* dmat = [[DMArrayTransformer alloc]init];
//        NSData* data = (NSData*)[dmat transformedValue:(_array)] ;
//
//        NSError* error = nil;
//        NSString* doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject ];
//        NSString* path = [doc stringByAppendingPathComponent:@"CoreData_1.txt"];
//        [data writeToFile:path atomically:false];
//    }
//    {
//        DMArrayTransformer* dmat = [[DMArrayTransformer alloc]init];
//        DMArray* dmArray = [dmat transformedValue:(_array)] ;
//
//        NSError* error = nil;
//        NSString* doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject ];
//
//        NSString* sqlitePath = [doc stringByAppendingPathComponent:@"CoreData_1.sqlite"];
//        NSURL* sqlURL = [NSURL fileURLWithPath:sqlitePath];
//
//        NSManagedObjectModel   * model    = [NSManagedObjectModel mergedModelFromBundles:nil];
//        NSPersistentStoreCoordinator* store = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
//        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlURL options:nil error:&error];
//
//    //    NSString* cmd = @"open ";
//    //    cmd = [cmd stringByAppendingString:sqlitePath ];
//    //    system([cmd UTF8String]);
//
//        NSManagedObjectContext * context  = [[NSManagedObjectContext alloc] initWithConcurrencyType:(NSMainQueueConcurrencyType)];
//        context.persistentStoreCoordinator = store;
//
//        KitEntity* KE = [NSEntityDescription insertNewObjectForEntityForName:@"KitEntity" inManagedObjectContext:context];
//        KE.dirs = dmArray;
//
//        [context save:&error];
//    }
}

+ (NSMutableArray<NSString*>*)readDirs:(NSString*)key
{
    {
        NSMutableArray<NSString*>* dirs = [_dic objectForKey:key];
        return dirs ;
    }
//    {
//        _array = [NSMutableArray array];
//
//        NSString* doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject ];
//        NSString* path = [doc stringByAppendingPathComponent:@"CoreData_1.txt"];
//        NSData* data = [NSData dataWithContentsOfFile:path ];
//        DMArrayTransformer* dmat = [[DMArrayTransformer alloc]init];
//        NSMutableArray<NSString*>* dirs2 = [dmat reverseTransformedValue:data] ;
//        [_array addObjectsFromArray:dirs2];
//    }
    
//    {
//        NSString* doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject ];
//        NSString* sqlitePath = [doc stringByAppendingPathComponent:@"CoreData_1.sqlite"];
//        NSURL* sqlURL = [NSURL fileURLWithPath:sqlitePath];
//
//        NSError* error = nil;
//
//        NSManagedObjectModel   * model    = [NSManagedObjectModel mergedModelFromBundles:nil];
//        NSPersistentStoreCoordinator* store = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
//        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlURL options:nil error:&error];
//
//        NSManagedObjectContext * context  = [[NSManagedObjectContext alloc] initWithConcurrencyType:(NSMainQueueConcurrencyType)];
//        context.persistentStoreCoordinator = store;
//
//        NSFetchRequest* request = [[NSFetchRequest alloc]init];
//        request.entity = [NSEntityDescription entityForName:@"KitEntity" inManagedObjectContext:context];
//        NSArray* objs = [context executeFetchRequest:request error:&error];
//        for(KitEntity* k in objs)
//        {
//            DMArray* dmArray = k.dirs;
//            if(dmArray)
//            {
//                DMArrayTransformer* dmat = [[DMArrayTransformer alloc]init] ;
//                _array = [dmat reverseTransformedValue:dmArray] ;
//            }
//        }
//    }
}




@end
