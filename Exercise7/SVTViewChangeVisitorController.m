//
//  SVTViewChangeVisitorController.m
//  Exericse7
//
//  Created by Тимофей Савицкий on 7/23/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTViewChangeVisitorController.h"
#import "SVTModelController.h"
#import "SVTTableCellViewButton.h"

@interface SVTViewChangeVisitorController() <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>
@property (assign) IBOutlet NSTableView *tableView;
@property (assign) IBOutlet NSTextField *fieldName;
@property (assign) IBOutlet NSTextField *fieldSurname;
@property (assign) IBOutlet NSTextField *fieldYear;
@property (assign) NSMutableArray<SVTBook *> *currentBook;
@property (retain, readonly) SVTModelController *model;
@end

static NSString *const kSVTViewChangeVisitorControllerTableViewBookTitle = @"Title";
static NSString *const kSVTViewChangeVisitorControllerTableViewBookAuthor = @"Author";
static NSString *const kSVTViewChangeVisitorControllerTableViewBookType = @"Type";
static NSString *const kSVTViewChangeVisitorControllerTableViewBookOwner = @"Owner";
static NSString *const kSVTViewChangeVisitorControllerTableViewGiveBook= @"Give Book";
static NSString *const kSVTViewChangeVisitorControllerTableViewTake = @"Take";
static NSString *const kSVTViewChangeVisitorControllerTableViewOwnedBy = @"Owned by";

@implementation SVTViewChangeVisitorController
{
@private
    NSTextField *_fieldName;
    NSTextField *_fieldSurname;
    NSTextField *_fieldYear;
    NSTableView *_tableView;
    NSInteger _row;
    NSMutableArray<SVTBook *> *_currentBook;
    SVTModelController *_model;
    BOOL _addReader;
}

- (instancetype)initWithChangeVisitor:(SVTModelController *)model row:(NSInteger)row
{
    self = [super initWithNibName:@"SVTViewChangeVisitorController" bundle:nil];
    if (self)
    {
        _currentBook = [[NSMutableArray alloc] init];
        _row = row;
        _model = [model retain];
        if (row == model.library.readers.count)
        {
            _addReader = YES;
        }
        else
        {
            _addReader = NO;
        }
        [self.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    }
    return self;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *result = nil;
    NSString *columnIdentifier = tableColumn.identifier;
    
    if ([columnIdentifier isEqualToString:kSVTViewChangeVisitorControllerTableViewBookTitle])
    {
        result = [tableView makeViewWithIdentifier:kSVTViewChangeVisitorControllerTableViewBookTitle owner:self];
        if ([[self.model.library.books objectAtIndex:row] nameBook])
        {
            result.textField.stringValue = [[self.model.library.books objectAtIndex:row] nameBook];
        }
    }
    else if ([columnIdentifier isEqualToString:kSVTViewChangeVisitorControllerTableViewBookAuthor])
    {
        result = [tableView makeViewWithIdentifier:kSVTViewChangeVisitorControllerTableViewBookAuthor owner:self];
        if ([[self.model.library.books objectAtIndex:row] author])
        {
            result.textField.stringValue = [[self.model.library.books objectAtIndex:row] author];
        }
    }
    else if ([columnIdentifier isEqualToString:kSVTViewChangeVisitorControllerTableViewBookType])
    {
        SVTTableCellViewButton *cellButton = [tableView makeViewWithIdentifier:kSVTViewChangeVisitorControllerTableViewBookType owner:self];
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
    else if ([columnIdentifier isEqualToString:kSVTViewChangeVisitorControllerTableViewBookOwner])
    {
        SVTTableCellViewButton *giveBook = [tableView makeViewWithIdentifier:kSVTViewChangeVisitorControllerTableViewBookOwner owner:self];
        SVTBook *book = [self.model.library.books objectAtIndex:row];
        if (book.owner && !self.addReader)
        {
            if ([book.owner isEqual:[self.model.library.readers objectAtIndex:self.row]])
            {
                giveBook.buttonGiveBook.title = kSVTViewChangeVisitorControllerTableViewGiveBook;
                giveBook.buttonGiveBook.enabled = YES;
                [self.currentBook addObject:book];
            }
            else
            {
                giveBook.buttonGiveBook.title = [NSString stringWithFormat:@"%@ %@",kSVTViewChangeVisitorControllerTableViewOwnedBy,[book.owner fullName]];
                giveBook.buttonGiveBook.enabled = NO;
            }
        }
        else if (book.owner)
        {
            giveBook.buttonGiveBook.title = [NSString stringWithFormat:@"%@ %@",kSVTViewChangeVisitorControllerTableViewOwnedBy,[book.owner fullName]];
            giveBook.buttonGiveBook.enabled = NO;
        }
        else
        {
            giveBook.buttonGiveBook.title = kSVTViewChangeVisitorControllerTableViewTake;
            giveBook.buttonGiveBook.enabled = YES;
        }
        result = giveBook;
    }
    return result;
}

- (void)awakeFromNib
{
    if (self.addReader)
    {
        [self.fieldName setPlaceholderString:@"name"];
        [self.fieldSurname setPlaceholderString:@"Surname"];
        [self.fieldYear setPlaceholderString:@"year"];
    }
    else
    {
        self.fieldName.stringValue = [[self.model.library.readers objectAtIndex:self.row] firstName];
        self.fieldSurname.stringValue = [[self.model.library.readers objectAtIndex:self.row] lastName];
        self.fieldYear.stringValue = [NSString stringWithFormat:@"%zd", [[self.model.library.readers objectAtIndex:self.row] year]];
    }
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.model.library.books count];
}

- (IBAction)buttonGiveBook:(NSButton *)sender
{
    NSInteger row = [self.tableView rowForView:sender.superview];
    if ([sender.title isEqualToString:kSVTViewChangeVisitorControllerTableViewGiveBook])
    {
        [self.currentBook removeObject:[self.model.library.books objectAtIndex:row]];
        sender.title = kSVTViewChangeVisitorControllerTableViewTake;
    }
    else if ([sender.title isEqualToString:kSVTViewChangeVisitorControllerTableViewTake])
    {
        [self.currentBook addObject:[self.model.library.books objectAtIndex:row]];
        sender.title = kSVTViewChangeVisitorControllerTableViewGiveBook;
    }
}

- (IBAction)buttonApply:(NSButton *)sender
{
    if (self.addReader)
    {
        SVTReader *reader = [[[SVTReader alloc] init] autorelease];
        reader.firstName = [self.fieldName.stringValue isEqualToString:@""] ? @"Fisrt name" : self.fieldName.stringValue;
        reader.lastName = [self.fieldSurname.stringValue isEqualToString:@""] ? @"Last name" : self.fieldSurname.stringValue;
        reader.year = [self.fieldYear integerValue] ? [self.fieldYear integerValue] : 0;
        [self.model.library addReader:reader];
    }
    else
    {
        if (![self.fieldName.stringValue isEqualToString:[[self.model.library.readers objectAtIndex:self.row] firstName]])
        {
            [[self.model.library.readers objectAtIndex:self.row] setFirstName:self.fieldName.stringValue];
        }
        if (![self.fieldSurname.stringValue isEqualToString:[[self.model.library.readers objectAtIndex:self.row] lastName]])
        {
            [[self.model.library.readers objectAtIndex:self.row] setLastName:self.fieldSurname.stringValue];
        }
        if ([self.fieldYear.stringValue integerValue] != [[self.model.library.readers objectAtIndex:self.row] year])
        {
            [[self.model.library.readers objectAtIndex:self.row] setYear:[self.fieldYear.stringValue integerValue] ? [self.fieldYear.stringValue integerValue] : 0];
        }
        [[[self.model.library.readers objectAtIndex:self.row] currentBook] enumerateObjectsUsingBlock:^(SVTBook *iBook, NSUInteger index, BOOL *stop)
         {
             [[self.model.library.readers objectAtIndex:self.row] returnBook:iBook];
         }];
    }
    [self.currentBook enumerateObjectsUsingBlock:^(SVTBook *iBook, NSUInteger index, BOOL *stop)
     {
         [[self.model.library.readers objectAtIndex:self.row] takeBook:iBook];
     }];
    NSWindow *window = [[NSApplication sharedApplication] keyWindow];
    [window close];
}

- (void)dealloc
{
    [_currentBook release];
    [_model release];
    [super dealloc];
}


#pragma mark - getters

- (NSTextField *)fieldName
{
    return _fieldName;
}

- (NSTextField *)fieldSurname
{
    return _fieldSurname;
}

- (NSTextField *)fieldYear
{
    return _fieldYear;
}

- (NSTableView *)tableView
{
    return _tableView;
}

- (SVTModelController *)model
{
    return _model;
}

- (NSMutableArray<SVTBook *> *)currentBook
{
    return _currentBook;
}

- (NSInteger)row
{
    return _row;
}

- (BOOL)addReader
{
    return _addReader;
}


#pragma mark - setters

- (void)setFieldName:(NSTextField *)fieldName
{
    _fieldName = fieldName;
}

- (void)setFieldSurname:(NSTextField *)fieldSurname
{
    _fieldSurname = fieldSurname;
}

- (void)setFieldYear:(NSTextField *)fieldYear
{
    _fieldYear = fieldYear;
}

- (void)setModel:(SVTModelController *)model
{
    _model = model;
}

- (void)setTableView:(NSTableView *)tableView
{
    _tableView = tableView;
}

- (void)setCurrentBook:(NSMutableArray<SVTBook *> *)currentBook
{
    if (_currentBook != currentBook)
    {
        [_currentBook release];
        _currentBook = [currentBook mutableCopy];
    }
}

@end
