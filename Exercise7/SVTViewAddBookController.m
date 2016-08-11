//
//  SVTViewChangeBookController.m
//  Exericse7
//
//  Created by Тимофей Савицкий on 7/25/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTViewAddBookController.h"
#import "SVTModelController.h"
#import "SVTTableCellViewButton.h"

@interface SVTViewAddBookController() <NSWindowDelegate>
@property (assign) IBOutlet NSTextField *labelTitle;
@property (assign) IBOutlet NSTextField *labelAuthor;
@property (assign) IBOutlet NSPopUpButton *popUpType;
@property (assign) IBOutlet NSTextField *labelYear;
@property (assign) IBOutlet NSTableView *tableView;
@property (retain, readonly) SVTBook *book;
@property (retain, readonly) SVTModelController *model;
@end

static NSString *const kSVTViewAddBookControllerTableViewVisitorName = @"Name";
static NSString *const kSVTViewAddBookControllerTableViewVisitorSurName = @"SurName";
static NSString *const kSVTViewAddBookControllerTableViewVisitorYear = @"Year";

static NSString *const kSVTViewAddBookControllerTableViewVisitorTakeBook = @"Take Book";
static NSString *const kSVTViewAddBookControllerTableViewVisitorOwnedBook = @"Owned Book";

@implementation SVTViewAddBookController
{
@private
    SVTModelController *_model;
    NSTextField *_labelTitle;
    NSTextField *_labelAuthor;
    NSPopUpButton *_popUpType;
    NSTextField *_labelYear;
    NSTableView *_tableView;
    SVTBook *_book;
}

- (instancetype)initWithAddBook:(SVTModelController *)model
{
    self = [super initWithNibName:@"SVTViewAddBookController" bundle:nil];
    if (self)
    {
        _model = [model retain];
        _book = [[SVTBook alloc] init];
        self.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    return self;
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *result = nil;
    NSString *columnIdentifier = tableColumn.identifier;
    
    if ([columnIdentifier isEqualToString:kSVTViewAddBookControllerTableViewVisitorName])
    {
        result = [tableView makeViewWithIdentifier:kSVTViewAddBookControllerTableViewVisitorName owner:self];
        result.textField.stringValue = [[self.model.library.readers objectAtIndex:row] firstName];
    }
    else if ([columnIdentifier isEqualToString:kSVTViewAddBookControllerTableViewVisitorSurName])
    {
        result = [tableView makeViewWithIdentifier:kSVTViewAddBookControllerTableViewVisitorSurName owner:self];
        result.textField.stringValue = [[self.model.library.readers objectAtIndex:row] lastName];
    }
    else if ([columnIdentifier isEqualToString:kSVTViewAddBookControllerTableViewVisitorYear])
    {
        result = [tableView makeViewWithIdentifier:kSVTViewAddBookControllerTableViewVisitorYear owner:self];
        result.textField.stringValue = [NSString stringWithFormat:@"%zd",[[self.model.library.readers objectAtIndex:row] year]];
    }
    else if ([columnIdentifier isEqualToString:kSVTViewAddBookControllerTableViewVisitorTakeBook])
    {
        SVTTableCellViewButton *giveBook = [tableView makeViewWithIdentifier:kSVTViewAddBookControllerTableViewVisitorTakeBook owner:self];
        giveBook.buttonGiveBook.title = kSVTViewAddBookControllerTableViewVisitorTakeBook;
        giveBook.buttonGiveBook.enabled = YES;
        result = giveBook;
    }
    return result;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.model.library.readers.count;
}


- (IBAction)buttonAddBook:(NSButton *)sender
{
    self.book.nameBook = [self.labelTitle.stringValue isEqualToString:@""] ? @"Title" : self.labelTitle.stringValue ;
    self.book.author = [self.labelAuthor.stringValue isEqualToString:@""] ? @"Author" : self.labelAuthor.stringValue;
    self.book.yearBook = [self.labelYear.stringValue integerValue] ? [self.labelYear.stringValue integerValue] : 0;
    if ([self.popUpType.stringValue integerValue] == kSVTBookTypePaperBack)
    {
        self.book.bookType = kSVTBookTypePaperBack;
    }
    else
    {
        self.book.bookType = kSVTBookTypeHardCover;
    }
    [self.model.library addBook:self.book];
    NSWindow *window = [[NSApplication sharedApplication] keyWindow];
    [window close];
}

- (IBAction)buttonGiveBook:(NSButton *)sender
{
    NSInteger row = [self.tableView rowForView:sender.superview];
    if ([sender.title isEqualToString:kSVTViewAddBookControllerTableViewVisitorTakeBook])
    {
        for (NSInteger iCur = 0; iCur < self.model.library.readers.count; iCur++)
        {
            SVTTableCellViewButton *cell = [self.tableView viewAtColumn:3 row:iCur makeIfNecessary:NO];
            cell.buttonGiveBook.enabled = NO;
        }
        sender.enabled = YES;
        [[self.model.library.readers objectAtIndex:row] takeBook:self.book];
        sender.title = kSVTViewAddBookControllerTableViewVisitorOwnedBook;
    }
    else if ([sender.title isEqualToString:kSVTViewAddBookControllerTableViewVisitorOwnedBook])
    {
        for (NSInteger iCur = 0; iCur < self.model.library.readers.count; iCur++)
        {
            SVTTableCellViewButton *cell = [self.tableView viewAtColumn:3 row:iCur makeIfNecessary:NO];
            cell.buttonGiveBook.enabled = YES;
        }
        [[self.model.library.readers objectAtIndex:row] returnBook:self.book];
        sender.title = kSVTViewAddBookControllerTableViewVisitorTakeBook;
    }
}

- (void)awakeFromNib
{
    [self.labelTitle setPlaceholderString:@"Title"];
    [self.labelAuthor setPlaceholderString:@"Author"];
    [self.labelYear setPlaceholderString:@"Year"];
}

- (void)dealloc
{
    [_model release];
    [_book release];
    [super dealloc];
}


#pragma mark - getters

- (NSTextField *)labelYear
{
    return _labelYear;
}

- (NSTextField *)labelAuthor
{
    return _labelAuthor;
}

- (NSTextField *)labelTitle
{
    return _labelTitle;
}

- (NSPopUpButton *)popUpType
{
    return _popUpType;
}

- (NSTableView *)tableView
{
    return _tableView;
}

- (SVTModelController *)model
{
    return _model;
}

- (SVTBook *)book
{
    return _book;
}


#pragma mark - setters

- (void)setLabelYear:(NSTextField *)labelYear
{
    _labelYear = labelYear;
}

- (void)setLabelAuthor:(NSTextField *)labelAuthor
{
    _labelAuthor = labelAuthor;
}

- (void)setLabelTitle:(NSTextField *)labelTitle
{
    _labelTitle = labelTitle;
}

- (void)setPopUpType:(NSPopUpButton *)popUpType
{
    _popUpType = popUpType;
}

- (void)setTableView:(NSTableView *)tableView
{
    _tableView = tableView;
}


@end
