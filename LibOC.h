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
{}
@property (weak) NSTextView *textView;

@end

#endif /* LibOC_h */
