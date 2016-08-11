//
//  SVTAppViewChangeController.h
//  Exericse7
//
//  Created by Тимофей Савицкий on 7/23/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SVTViewChangeVisitorController;
@class SVTModelController;
@class SVTViewAddBookController;
@class SVTViewRenameBookAndTranslate;
@class SVTBook;

@interface SVTAppWindowChangeController : NSWindowController<NSWindowDelegate>

- (instancetype)initWithViewChangeVisitor:(SVTModelController *)model row:(NSInteger)row;
- (instancetype)initWithViewAddBook:(SVTModelController *)model;
- (instancetype)initWithViewRenameBook:(SVTBook *)book row:(NSUInteger)row;

@property (retain, readonly) SVTViewChangeVisitorController *viewChangeVisitor;
@property (retain, readonly) SVTViewAddBookController *viewAddBook;
@property (retain, readonly) SVTViewRenameBookAndTranslate *viewRenameBook;

@end
