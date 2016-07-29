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

static NSString *const kSVTModelControllerTableViewBookOwnerPopUpButtonNone = @"None";

@interface SVTViewController() <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate, NSWindowDelegate>
@property (atomic, assign, readwrite) IBOutlet NSTableView *tableViewReaders;
@property (atomic, assign, readwrite) IBOutlet NSTableView *tableViewBooks;
@property (atomic, retain, readwrite) NSMutableArray *openWindowsVisitor;
@property (nonatomic, retain, readonly) SVTModelController *model;
@end

@implementation SVTViewController
{
@private
    NSTableView *_tableViewReaders;
    NSTableView *_tableViewBooks;
    SVTModelController *_model;
    NSMutableArray *_openWindowsVisitor;
}

- (instancetype)initWithModel:(SVTModelController *)model
{
    self = [super init];
    if (self) {
        _openWindowsVisitor = [[NSMutableArray alloc] init];
        _model = [model retain];
        [self.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
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
                __block SVTTableCellViewButton *cellButton = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewBookOwner owner:self];
                [cellButton.popUpButtonTypeCover removeAllItems];
                [cellButton.popUpButtonTypeCover addItemWithTitle:kSVTModelControllerTableViewBookOwnerPopUpButtonNone];
                [self.model.library.readers enumerateObjectsUsingBlock:^(SVTReader *iReader, NSUInteger index, BOOL *stop)
                 {
                     [cellButton.popUpButtonTypeCover addItemWithTitle:iReader.fullName];
                 }];
                if ([[self.model.library.books objectAtIndex:row] owner] != nil)
                {
                    NSUInteger index = [self.model.library.readers indexOfObject:[[self.model.library.books objectAtIndex:row] owner]];
                    [cellButton.popUpButtonTypeCover selectItemAtIndex:(index + 1)];
                }
                result = cellButton;
            }
        }
        else
        {
            if ([columnIdentifier isEqualToString:kSVTModelControllerTableViewBookType])
            {
                SVTTableCellViewButton *cellButton = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewBookType owner:self];
                result = cellButton;
            }
            else if ([columnIdentifier isEqualToString:kSVTModelControllerTableViewBookOwner])
            {
                SVTTableCellViewButton *cellButton = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewBookOwner owner:self];
                [cellButton.popUpButtonTypeCover addItemWithTitle:kSVTModelControllerTableViewBookOwnerPopUpButtonNone];
                [cellButton.popUpButtonTypeCover selectItemAtIndex:0];
                result = cellButton;
            }
            else
            {
                result = [tableView makeViewWithIdentifier:kSVTModelControllerTableViewBookTitle owner:self];
                [result.textField setPlaceholderString:@"add"];
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
            [result.textField setPlaceholderString:@"name"];
        }
    }
    result.textField.delegate = self;
    return result;
}

- (void)doubleClickToCellVisitor:(NSTableView *)tableView
{
    NSInteger row = tableView.selectedRow;
    if (row < self.model.library.readers.count)
    {
        SVTAppWindowChangeController *windowChangeVisitor = [[SVTAppWindowChangeController alloc] initWithViewChangeVisitor:self.model row:row];
        windowChangeVisitor.window.delegate = self;
        [self.openWindowsVisitor addObject:windowChangeVisitor];
        [windowChangeVisitor release];
    }
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
    //++result;
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
    void (^addReader)(NSInteger) = ^(NSInteger row) {
        if (row == self.model.library.readers.count)
        {
            [self.model.library addReader:[[[SVTReader alloc] init] autorelease]];
            NSTableView *tableView = self.tableViewReaders;
            [tableView beginUpdates];
            [tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
            [tableView endUpdates];
        }
    };
    void (^addBook)(NSInteger) = ^(NSInteger row) {
        if (row == self.model.library.books.count)
        {
            [self.model.library addBook:[[[SVTBook alloc] init] autorelease]];
            NSTableView *tableView = self.tableViewBooks;
            [tableView beginUpdates];
            [tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
            [tableView endUpdates];
        }
    };

    NSString *textFieldIdentifier = control.identifier;
    NSInteger rowReader = [self.tableViewReaders rowForView:control.superview];
    NSInteger rowBook= [self.tableViewBooks rowForView:control.superview];
    
    addReader(rowReader);
    addBook(rowBook);
    
    if ([textFieldIdentifier isEqualToString:kSVTModelControllerTableViewVisitorName])
    {
        [[self.model.library.readers objectAtIndex:rowReader] setFirstName:control.stringValue];
    }
    else if ([textFieldIdentifier isEqualToString:kSVTModelControllerTableViewVisitorSurName])
    {
        [[self.model.library.readers objectAtIndex:rowReader] setLastName:control.stringValue];
    }
    else if ([textFieldIdentifier isEqualToString:kSVTModelControllerTableViewVisitorYear])
    {
        [[self.model.library.readers objectAtIndex:rowReader] setYear:[control.stringValue integerValue] ? [control.stringValue integerValue] : 0];
        if (![control.stringValue integerValue])
        {
            control.stringValue = @"0";
        }
    }
    else if ([textFieldIdentifier isEqualToString:kSVTModelControllerTableViewBookTitle])
    {
        [[self.model.library.books objectAtIndex:rowBook] setNameBook:control.stringValue];
    }
    else if ([textFieldIdentifier isEqualToString:kSVTModelControllerTableViewBookAuthor])
    {
        [[self.model.library.books objectAtIndex:rowBook] setAuthor:control.stringValue];
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

- (IBAction)buttonOwnerBook:(NSPopUpButton *)sender
{
    NSInteger row = [self.tableViewBooks rowForView:sender.superview];
    if (row != self.model.library.books.count)
    {
        NSUInteger indexReader = [sender indexOfItemWithTitle:sender.title] - 1;
        [[[self.model.library.books objectAtIndex:row] owner] returnBook:[self.model.library.books objectAtIndex:row]];
        if (![sender.title isEqualToString:kSVTModelControllerTableViewBookOwnerPopUpButtonNone])
        {
            [[self.model.library.readers objectAtIndex:indexReader] takeBook:[self.model.library.books objectAtIndex:row]];
        }
    }
}

- (IBAction)buttonRemoveVisitor:(NSButton *)sender
{
    NSInteger selectedRow = self.tableViewReaders.selectedRow;
    if (selectedRow != -1 && self.model.library.readers.count != selectedRow && self.openWindowsVisitor.count == 0)
    {
        SVTReader *reader = [self.model.library.readers objectAtIndex:selectedRow];
        [reader.currentBook enumerateObjectsUsingBlock:^(SVTBook *iBook, NSUInteger index, BOOL *stop)
         {
             [reader returnBook:iBook];
         }];
        [self.model.library removeReader:[self.model.library.readers objectAtIndex:selectedRow]];
        [self.tableViewReaders beginUpdates];
        [self.tableViewReaders removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] withAnimation:NSTableViewAnimationSlideUp];
        [self.tableViewReaders endUpdates];
        [self.tableViewBooks reloadData];
    }
}


- (IBAction)buttonRemoveBook:(NSButton *)sender
{
    NSInteger selectedRow = self.tableViewBooks.selectedRow;
    if (selectedRow != -1 && self.model.library.books.count != selectedRow && self.openWindowsVisitor.count == 0)
    {
        [self.model.library removeBook:[self.model.library.books objectAtIndex:selectedRow]];
        [self.tableViewBooks beginUpdates];
        [self.tableViewBooks removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] withAnimation:NSTableViewAnimationSlideUp];
        [self.tableViewBooks endUpdates];
    }
}


- (void)windowWillClose:(NSNotification *)notification
{
    SVTAppWindowChangeController *windowChangeController = [notification.object windowController];
    NSIndexSet *row = [[NSMutableIndexSet alloc] initWithIndex:windowChangeController.viewChangeVisitor.row];
    if (!windowChangeController.viewChangeVisitor.addReader && windowChangeController.viewChangeVisitor)
    {
        [self.tableViewReaders reloadDataForRowIndexes:row columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
        [self.tableViewBooks reloadData];
    }
    else if (windowChangeController.viewChangeVisitor.addReader && self.model.library.readers.count == (windowChangeController.viewChangeVisitor.row + 1))
    {
        NSTableView *tableView = self.tableViewReaders;
        [tableView beginUpdates];
        [tableView insertRowsAtIndexes:row withAnimation:NSTableViewAnimationEffectFade];
        [tableView endUpdates];
        [self.tableViewBooks reloadData];
    }
    else if (windowChangeController.viewAddBook)
    {
        NSTableView *tableView = self.tableViewBooks;
        [tableView beginUpdates];
        [tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.model.library.books.count] withAnimation:NSTableViewAnimationEffectFade];
        [tableView endUpdates];
    }
    [self.openWindowsVisitor removeObject:windowChangeController];
    [row release];
}

- (void)dealloc
{
    [_model release];
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

- (SVTModelController *)model
{
    return _model;
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

@end
