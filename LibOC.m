//
//  LibOC.m
//  kit
//
//  Created by 余纪柱 on 2023/2/27.
//

#import <Foundation/Foundation.h>
#import "LibOC.h"
#import "LibData.h"

#pragma mark - HistoryComboBoxDelegate -
@implementation HistoryComboBoxDelegate

- (void)comboBoxWillPopUp:(NSNotification *)notification
{
    NSComboBox *combo_box = notification.object;
    NSArray * objects = [combo_box objectValues];
    if([objects containsObject:_textView.string])
    {
        [combo_box selectItemWithObjectValue:_textView.string];
    }
    else
    {
        [combo_box selectItemWithObjectValue:nil];
    }
}

- (void)comboBoxWillDismiss:(NSNotification *)notification {
    NSComboBox *combo_box = notification.object;
    NSInteger index=[combo_box indexOfSelectedItem];
    [_textView setString:[combo_box itemObjectValueAtIndex:index]];
}
@end

#pragma mark - NormalComboBoxDelegate -

@implementation MyControlTextEditingDelegate

- (void)controlTextDidChange:(NSNotification *)notification
{
    NSTextField* tf = [notification object];
    [tf sizeToFit];
}
@end

@implementation LibOC

+(NSString *)getFistPathFromDragInfo:(id<NSDraggingInfo>) dragInfo {
    NSPasteboard *pasteboard = [dragInfo draggingPasteboard];
    NSArray *classes = @[[NSURL class]];
    NSDictionary *options = @{};
    if ([pasteboard canReadObjectForClasses:classes options:options]) {
        NSURL *url = [pasteboard readObjectsForClasses:classes options:options].firstObject;
        NSString* path = [url path];
        return path;
    }
    return nil;
}

+(NSDragOperation)getDragOperationFromDragInfo:(id<NSDraggingInfo>) dragInfo
{
    if ([dragInfo draggingSource] != self) {
        NSArray *draggedTypes = [[dragInfo draggingPasteboard] types];
        if ([draggedTypes containsObject:NSPasteboardTypeFileURL]) {
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}

+(void)fillImage:(NSImageView*)imageView andLabel:(NSTextField*)label ByUrl:(NSString*)url
{
    if(imageView) imageView.image = [[NSImage alloc] initWithContentsOfFile:url];
    NSString *str = [LibData getAutoSizeOfFile:url];
    [label setStringValue:str];
}

///Helper
+(void)traverseParentItemsForItem:(id)item inOutlineView:(NSOutlineView *)outlineView forDomain:(NSMutableArray*)domains
{
    if(item) [domains insertObject:item atIndex:0];
    id parentItem = [outlineView parentForItem:item];
    if (parentItem) {
        [LibOC traverseParentItemsForItem:parentItem inOutlineView:outlineView forDomain:domains];
    }
}

+(NSString*)pathForItem:(id)item inOutlineView:(NSOutlineView *)outlineView
{
    NSMutableArray* array = [NSMutableArray array];
    [LibOC traverseParentItemsForItem:item inOutlineView:outlineView forDomain:array];
    NSString* path = [NSString string];
    for(NSString* domain in array)
    {
        path = [path stringByAppendingPathComponent:domain];
    }
    BOOL isDir;
    if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir)
    {
        return path;
    }
    return nil;
}

+(NSString*)fileForItem:(id)item inOutlineView:(NSOutlineView *)outlineView
{
    NSMutableArray* domain = [NSMutableArray array];
    [LibOC traverseParentItemsForItem:item inOutlineView:outlineView forDomain:domain];
    NSMutableString* path = [NSMutableString string];
    for(NSString* sub in domain)
    {
        [path appendString:sub];
    }
    BOOL isDir;
    if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && !isDir)
    {
        return path;
    }
    return nil;
}

+(void)traverseOutlineView:(NSOutlineView *)outlineView
                usingBlock:(void(^)(NSOutlineView*,id item))block
{
    NSInteger numberOfChildren = [outlineView numberOfChildrenOfItem:nil];
    for (NSInteger i = 0; i < numberOfChildren; i++) {
        id item = [outlineView child:i ofItem:nil];
        [self traverseItem:item inView:outlineView usingBlock:block];
    }
}

+(void)traverseItem:(id)item
             inView:(NSOutlineView *)outlineView
         usingBlock:(void(^)(NSOutlineView*,id item))block
{
    block(outlineView,item);
    NSInteger numberOfChildren = [outlineView numberOfChildrenOfItem:item];
    for (NSInteger i = 0; i < numberOfChildren; i++) {
        id childItem = [outlineView child:i ofItem:item];
        [self traverseItem:childItem inView:outlineView usingBlock:block];
    }
}

+(void)getIndex:(NSInteger*)index andParent:(NSMutableString*)parent andItem:(NSMutableString*)item
  ByOutlineView:(NSOutlineView*)view
{
    NSInteger selectedRow = view.selectedRow;
    if (selectedRow != -1)
    {
        NSInteger row = [view selectedRow];
        [item setString:[view itemAtRow:row]];
        NSString* parentItem = [view parentForItem:item];
        if(parentItem)
        {
            [parent setString:parentItem];
        }
        *index = [view childIndexForItem:item];
    }
}

+(NSString*)getSelectedItem:(NSOutlineView*)view
{
    NSInteger selectedRow = view.selectedRow;
    if (selectedRow != -1)
    {
        NSInteger row = [view selectedRow];
        return [view itemAtRow:row];
    }
    return nil;
}

+(void)checkDirExistForTextField:(NSTextField*)field
{
    NSString* path = [field stringValue];
    
}
+(void)setCombobox:(NSComboBox*)box withItems:(NSArray*)items atItem:(NSString*)item
{
    [box removeAllItems];
    [box addItemsWithObjectValues:items];
    [box setEditable:NO];
    [box setSelectable:NO];
    NSInteger index = [items indexOfObject:item];
    if (index == NSNotFound) {
        index = 0;
    }
    if(!item || item.length == 0)
    {
        [box selectItemAtIndex:0];
    }
    else
    {
        [box selectItemWithObjectValue:item];
    }
}
@end
