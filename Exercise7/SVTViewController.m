 //
//  SVTViewController.m
//  Exericse7
//
//  Created by Тимофей Савицкий on 7/20/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTViewController.h"
#import "SVTModelController.h"
#import "SVTAppWindowChangeController.h"
#import "SVTViewChangeVisitorController.h"
#import "SVTViewAddBookController.h"
#import "SVTTableCellViewButton.h"

static NSString *const kSVTModelControllerTableViewVisitors = @"Visitors";
static NSString *const kSVTModelControllerTableViewVisitorName = @"Name";
static NSString *const kSVTModelControllerTableViewVisitorSurName = @"SurName";
static NSString *const kSVTModelControllerTableViewVisitorYear = @"Year";

static NSString *const kSVTModelControllerTableViewBooks = @"Books";
static NSString *const kSVTModelControllerTableViewBookTitle = @"Title";
static NSString *const kSVTModelControllerTableViewBookAuthor = @"Author";
static NSString *const kSVTModelControllerTableViewBookType = @"Type";
static NSString *const kSVTModelControllerTableViewBookOwner = @"Owner";

@interface SVTViewController() <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate, NSWindowDelegate>
@property (atomic, assign, readwrite) IBOutlet NSTableView *tableViewReaders;
@property (atomic, assign, readwrite) IBOutlet NSTableView *tableViewBooks;
@property (atomic, retain, readwrite) NSMutableArray *openWindowsVisitor;
@property (atomic, retain, readwrite) NSMutableArray *rows;
@end

@implementation SVTViewController
{
@private
    NSTableView *_tableViewReaders;
    NSTableView *_tableViewBooks;
    SVTModelController *_model;
    NSMutableArray *_openWindowsVisitor;
    NSMutableArray *_rows;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _openWindowsVisitor = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    [self.tableViewReaders setDoubleAction:@selector(doubleClickToCellVisitor:)];
    NSTableCellView *result = nil;
    NSString *tableIdentifier = tableView.identifier;
    NSString *columnIdentifier = tableColumn.identifier;
    
    if ([tableIdentifier isEqualToString:kSVTModelControllerTableViewBooks])
    {
        if (row < self.model.library.books.count)
        {
            if ([columnIdentifier isEqualToString:kSVTModelControllerTableViewBookTitle])
            {
                result = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewBookTitle owner:self];
                result.textField.stringValue = [[self.model.library.books objectAtIndex:row] nameBook];
            }
            else if ([columnIdentifier isEqualToString:kSVTModelControllerTableViewBookAuthor])
            {
                result = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewBookAuthor owner:self];
                result.textField.stringValue = [[self.model.library.books objectAtIndex:row] author];
            }
            else if ([columnIdentifier isEqualToString:kSVTModelControllerTableViewBookType])
            {
                SVTTableCellViewButton *cellButton = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewBookType owner:self];
                if ([[self.model.library.books objectAtIndex:row] bookType] == kSVTBookTypePaperBack)
                {
                    [cellButton.popUpButtonTypeCover selectItemAtIndex:0];
                }
                else
                {
                    [cellButton.popUpButtonTypeCover selectItemAtIndex:1];
                }
                result = cellButton;
            }
            else if ([columnIdentifier isEqualToString:kSVTModelControllerTableViewBookOwner])
            {
                result = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewBookOwner owner:self];
                if ([[self.model.library.books objectAtIndex:row] owner])
                {
                    result.textField.stringValue = [[[self.model.library.books objectAtIndex:row] owner] fullName];
                }
            }
        }
        else
        {
            if ([columnIdentifier isEqualToString:kSVTModelControllerTableViewBookType])
            {
                SVTTableCellViewButton *cellButton = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewBookType owner:self];
                result = cellButton;
            }
            else
            {
                result = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewBookTitle owner:self];
                result.textField.stringValue = @"+";
            }
        }
    }
    else if ([tableIdentifier isEqualToString:kSVTModelControllerTableViewVisitors])
    {
        if (row < self.model.library.readers.count)
        {
            if ([columnIdentifier isEqualToString:kSVTModelControllerTableViewVisitorName])
            {
                result = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewVisitorName owner:self];
                result.textField.stringValue = [[self.model.library.readers objectAtIndex:row] firstName];
            }
            else if ([columnIdentifier isEqualToString:kSVTModelControllerTableViewVisitorSurName])
            {
                result = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewVisitorSurName owner:self];
                result.textField.stringValue = [[self.model.library.readers objectAtIndex:row] lastName];
            }
            else if ([columnIdentifier isEqualToString:kSVTModelControllerTableViewVisitorYear])
            {
                result = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewVisitorYear owner:self];
                result.textField.stringValue = [NSString stringWithFormat:@"%zd",[[self.model.library.readers objectAtIndex:row] year]];
            }
        }
        else
        {
            result = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewVisitorName owner:self];
            result.textField.stringValue = @"+";
        }
    }
    result.textField.delegate = self;
    return result;
}

- (void)doubleClickToCellVisitor:(NSTableView *)tableView
{
    NSInteger row = tableView.selectedRow;
    SVTAppWindowChangeController *windowChangeVisitor = [[SVTAppWindowChangeController alloc] initWithViewChangeVisitor:self.model row:row];
    windowChangeVisitor.window.delegate = self;
    [self.openWindowsVisitor addObject:windowChangeVisitor];
    [windowChangeVisitor release];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSUInteger result = 0;
    if ([tableView.identifier isEqualToString:kSVTModelControllerTableViewBooks])
    {
        result = [self.model.library.books count];
    }
    else if ([tableView.identifier isEqualToString:kSVTModelControllerTableViewVisitors])
    {
        result = [self.model.library.readers count];
    }
    return result;
    
}

- (IBAction)buttonAddReader:(NSButton *)sender
{
    NSInteger row = self.model.library.readers.count;
    SVTAppWindowChangeController *windowChangeVisitor = [[SVTAppWindowChangeController alloc] initWithViewChangeVisitor:self.model row:row];
    windowChangeVisitor.window.delegate = self;
    [self.openWindowsVisitor addObject:windowChangeVisitor];
    [windowChangeVisitor release];
}

- (IBAction)buttonAddBook:(NSButton *)sender
{
    SVTAppWindowChangeController *windowAddBook = [[SVTAppWindowChangeController alloc] initWithViewAddBook:self.model];
    windowAddBook.window.delegate = self;
    [self.openWindowsVisitor addObject:windowAddBook];
    [windowAddBook release];
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSString *textFieldIdentifier = control.identifier;
    if ([textFieldIdentifier isEqualToString:kSVTModelControllerTableViewVisitorName])
    {
        NSInteger row = [self.tableViewReaders rowForView:control.superview];
        [[self.model.library.readers objectAtIndex:row] setFirstName:control.stringValue];
    }
    else if ([textFieldIdentifier isEqualToString:kSVTModelControllerTableViewVisitorSurName])
    {
        NSInteger row = [self.tableViewReaders rowForView:control.superview];
        [[self.model.library.readers objectAtIndex:row] setLastName:control.stringValue];
    }
    else if ([textFieldIdentifier isEqualToString:kSVTModelControllerTableViewVisitorYear])
    {
        NSInteger row = [self.tableViewReaders rowForView:control.superview];
        [[self.model.library.readers objectAtIndex:row] setYear:[control.stringValue integerValue]];
    }
    else if ([textFieldIdentifier isEqualToString:kSVTModelControllerTableViewBookTitle])
    {
        NSInteger row = [self.tableViewBooks rowForView:control.superview];
        [[self.model.library.books objectAtIndex:row] setNameBook:control.stringValue];
    }
    else if ([textFieldIdentifier isEqualToString:kSVTModelControllerTableViewBookAuthor])
    {
        NSInteger row = [self.tableViewBooks rowForView:control.superview];
        [[self.model.library.books objectAtIndex:row] setAuthor:control.stringValue];
    }
    else if ([textFieldIdentifier isEqualToString:kSVTModelControllerTableViewBookOwner])
    {
        NSInteger row = [self.tableViewBooks rowForView:control.superview];
        NSString *fullName = control.stringValue;
        [self.model.library.readers enumerateObjectsUsingBlock:^(SVTReader *iReader, NSUInteger index, BOOL *stop)
         {
             if ([iReader.fullName isEqualToString:fullName])
             {
                 [[self.model.library.books objectAtIndex:row] setOwner:iReader];
                 *stop = YES;
             }
         }];
    }
    return YES;
}

- (IBAction)buttonTypeCover:(NSPopUpButton *)sender
{
    NSInteger row = [self.tableViewBooks rowForView:sender.superview];
    if (sender.numberOfItems == 1)
    {
        [[self.model.library.books objectAtIndex:row] setBookType:(kSVTBookTypePaperBack)];
    }
    else
    {
        [[self.model.library.books objectAtIndex:row] setBookType:(kSVTBookTypeHardCover)];
    }
}

- (IBAction)buttonRemoveVisitor:(NSButton *)sender
{
    NSInteger selectedRow = self.tableViewReaders.selectedRow;
    if (selectedRow != -1)
    {
        [self.model.library removeReader:[self.model.library.readers objectAtIndex:selectedRow]];
        [self.tableViewReaders reloadData];
    }
}


- (IBAction)buttonRemoveBook:(NSButton *)sender
{
    NSInteger selectedRow = self.tableViewBooks.selectedRow;
    if (selectedRow != -1)
    {
        [self.model.library removeBook:[self.model.library.books objectAtIndex:selectedRow]];
        [self.tableViewBooks reloadData];
    }
}


- (void)windowWillClose:(NSNotification *)notification
{
    SVTAppWindowChangeController *windowChangeController = [notification.object windowController];
    NSIndexSet *row = [[NSMutableIndexSet alloc] initWithIndex:windowChangeController.viewChangeVisitor.row];
    if (!windowChangeController.viewChangeVisitor.addReader && windowChangeController.viewChangeVisitor)
    {
        [self.openWindowsVisitor removeObject:windowChangeController];
        [self.tableViewReaders reloadDataForRowIndexes:row columnIndexes:[NSIndexSet indexSetWithIndex:0]];
        [self.tableViewReaders reloadDataForRowIndexes:row columnIndexes:[NSIndexSet indexSetWithIndex:1]];
        [self.tableViewReaders reloadDataForRowIndexes:row columnIndexes:[NSIndexSet indexSetWithIndex:2]];
        [self.tableViewBooks reloadData];
    }
    else if (windowChangeController.viewChangeVisitor.addReader && self.model.library.readers.count == (windowChangeController.viewChangeVisitor.row + 1))
    {
        [self.openWindowsVisitor removeObject:windowChangeController];
        NSTableView *tableView = self.tableViewReaders;
        [tableView beginUpdates];
        [tableView insertRowsAtIndexes:row withAnimation:NSTableViewAnimationEffectFade];
        [tableView endUpdates];
        [self.tableViewBooks reloadData];
    }
    else if (windowChangeController.viewAddBook)
    {
        [self.openWindowsVisitor removeObject:windowChangeController];
        [self.tableViewBooks reloadData];
    }
    [row release];
}

- (void)dealloc
{
    [_openWindowsVisitor release];
    [super dealloc];
}


#pragma mark - getters

- (NSTableView *)tableViewReaders
{
    return _tableViewReaders;
}

- (NSTableView *)tableViewBooks
{
    return _tableViewBooks;
}

- (NSMutableArray *)openWindowsVisitor
{
    return _openWindowsVisitor;
}

- (NSMutableArray *)rows
{
    return _rows;
}


#pragma mark - setters

- (void)setTableViewReaders:(NSTableView *)tableViewReaders
{
    _tableViewReaders = tableViewReaders;
}

- (void)setTableViewBooks:(NSTableView *)tableViewBooks
{
    _tableViewBooks = tableViewBooks;
}

- (void)setOpenWindowsVisitor:(NSMutableArray *)openWindowsVisitor
{
    if (_openWindowsVisitor != openWindowsVisitor)
    {
        [_openWindowsVisitor retain];
        _openWindowsVisitor = [openWindowsVisitor mutableCopy];
    }
}

- (void)setRows:(NSMutableArray *)rows
{
    if (_rows != rows)
    {
        [_rows release];
        _rows = [rows mutableCopy];
    }
}

- (SVTModelController *)model
{
    return _model;
}

- (void)setModel:(SVTModelController *)model
{
    if (_model != model)
    {
        [_model release];
        _model = [model retain];
    }
}


@end
