//
//  SVTViewRenameBookAndTranslate.h
//  Exercise8
//
//  Created by Тимофей Савицкий on 8/10/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SVTBook;

@interface SVTViewRenameBookAndTranslate : NSViewController
- (instancetype)initWithBook:(SVTBook *)book row:(NSUInteger)row;
@property (readonly) NSInteger row;
@end
