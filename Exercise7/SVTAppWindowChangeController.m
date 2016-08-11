//
//  SVTAppViewChangeController.m
//  Exericse7
//
//  Created by Тимофей Савицкий on 7/23/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTAppWindowChangeController.h"
#import "SVTViewChangeVisitorController.h"
#import "SVTViewAddBookController.h"
#import "SVTModelController.h"
#import "SVTBook.h"
#import "SVTViewRenameBookAndTranslate.h"

@interface SVTAppWindowChangeController ()
@end

@implementation SVTAppWindowChangeController
{
@private
    SVTViewChangeVisitorController *_viewChangeVisitor;
    SVTViewRenameBookAndTranslate *_viewRenameBook;
    SVTViewAddBookController *_viewAddBook;
}

- (instancetype)initWithViewChangeVisitor:(SVTModelController *)model row:(NSInteger)row
{
    self = [super initWithWindowNibName:@"SVTAppWindowChangeController"];
    if (self) {
        _viewChangeVisitor = [[SVTViewChangeVisitorController alloc] initWithChangeVisitor:model row:row];
        [self.window.contentView addSubview:_viewChangeVisitor.view];
    }
    return self;
}

- (instancetype)initWithViewAddBook:(SVTModelController *)model
{
    self = [super initWithWindowNibName:@"SVTAppWindowChangeController"];
    if (self) {
        _viewAddBook = [[SVTViewAddBookController alloc] initWithAddBook:model];
        [self.window.contentView addSubview:_viewAddBook.view];
    }
    return self;
}

- (instancetype)initWithViewRenameBook:(SVTBook *)book row:(NSUInteger)row
{
    self = [super initWithWindowNibName:@"SVTAppWindowChangeController"];
    if (self) {
        _viewRenameBook = [[SVTViewRenameBookAndTranslate alloc] initWithBook:book row:row];
        [self.window.contentView addSubview:_viewRenameBook.view];
    }
    return self;
}

- (void)dealloc
{
    [_viewAddBook release];
    [_viewChangeVisitor release];
    [super dealloc];
}


#pragma mark - getters

- (SVTViewAddBookController *)viewAddBook
{
    return _viewAddBook;
}

- (SVTViewChangeVisitorController *)viewChangeVisitor
{
    return _viewChangeVisitor;
}

@end
