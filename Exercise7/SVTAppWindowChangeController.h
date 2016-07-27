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

@interface SVTAppWindowChangeController : NSWindowController<NSWindowDelegate>

- (instancetype)initWithViewChangeVisitor:(SVTModelController *)model row:(NSInteger)row;
- (instancetype)initWithViewAddBook:(SVTModelController *)model;

@property (retain, readonly) SVTViewChangeVisitorController *viewChangeVisitor;
@property (retain, readonly) SVTViewAddBookController *viewAddBook;

@end
