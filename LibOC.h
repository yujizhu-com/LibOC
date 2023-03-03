//
//  LibOC.h
//  kit
//
//  Created by 余纪柱 on 2023/2/27.
//

#import <Cocoa/Cocoa.h>

#ifndef LibOC_h
#define LibOC_h


@interface MyComboBoxDelegate : NSObject<NSComboBoxDelegate>
{}
@property (weak) NSTextView *textView;
@end

@interface MyControlTextEditingDelegate: NSObject<NSTextFieldDelegate>
- (void)controlTextDidChange:(NSNotification *)notification;
@end


@interface LibOC : NSObject
+(NSURL *)getURLFromPasteboard:(NSPasteboard *)pasteboard ;
+(void)fillImage:(NSImageView*)imageView andLabel:(NSTextField*)label ByUrl:(NSString*)url;
@end



#endif /* LibOC_h */
