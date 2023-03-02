//
//  LibOC.m
//  kit
//
//  Created by 余纪柱 on 2023/2/27.
//

#import <Foundation/Foundation.h>
#import "LibOC.h"

@implementation MyComboBoxDelegate

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

@implementation MyControlTextEditingDelegate

- (void)controlTextDidChange:(NSNotification *)notification
{
    NSTextField* tf = [notification object];
    [tf sizeToFit];
}

@end
@implementation LibOC

+(NSURL *)getURLFromPasteboard:(NSPasteboard *)pasteboard {
    NSArray *classes = @[[NSURL class]];
    NSDictionary *options = @{};
    if ([pasteboard canReadObjectForClasses:classes options:options]) {
        return [pasteboard readObjectsForClasses:classes options:options].firstObject;
    }
    return nil;
}


@end
