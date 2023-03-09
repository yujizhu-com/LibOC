//
//  LibOC.h
//  kit
//
//  Created by 余纪柱 on 2023/2/27.
//

#import <Cocoa/Cocoa.h>

#ifndef LibOC_h
#define LibOC_h


@interface HistoryComboBoxDelegate : NSObject<NSComboBoxDelegate>
@property (weak) NSTextView *textView;
@end

@interface MyControlTextEditingDelegate: NSObject<NSTextFieldDelegate>
- (void)controlTextDidChange:(NSNotification *)notification;
@end


@interface LibOC : NSObject

+(NSString *)getFistPathFromDragInfo:(id<NSDraggingInfo>) dragInfo ;
+(NSDragOperation)getDragOperationFromDragInfo:(id<NSDraggingInfo>) dragInfo ;
+(void)fillImage:(NSImageView*)imageView andLabel:(NSTextField*)label ByUrl:(NSString*)url;
+(void)traverseParentItemsForItem:(id)item inOutlineView:(NSOutlineView *)outlineView forDomain:(NSMutableArray*)domains;
+(NSString*)pathForItem:(id)item inOutlineView:(NSOutlineView *)outlineView;
+(NSString*)fileForItem:(id)item inOutlineView:(NSOutlineView *)outlineView;
+(void)traverseOutlineView:(NSOutlineView *)outlineView usingBlock:(void(^)(NSOutlineView*,id))block ;
+(void)traverseItem:(id)item inView:(NSOutlineView *)outlineView usingBlock:(void(^)(NSOutlineView*,id))block;
+(void)getIndex:(NSInteger*)index andParent:(NSMutableString*)parent andItem:(NSMutableString*)item
  ByOutlineView:(NSOutlineView*)view;
+(NSString*)getSelectedItem:(NSOutlineView*)view;
+(void)checkDirExistForTextField:(NSTextField*)field;
+(void)setCombobox:(NSComboBox*)box withItems:(NSArray*)items atItem:(NSString*)item;
@end



#endif /* LibOC_h */
