//
//  SVTBook.m
//  Exercise 3
//
//  Created by Тимофей Савицкий on 7/6/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTBook.h"

@interface SVTBook() <NSCoding>
{
@private
    NSString *_nameBook;
    NSInteger _yearBook;
    SVTBookType _bookType;
    NSString *_identifier;
    SVTReader *_owner;
    NSString *_author;
}
@end

static NSString *const kSVTBookTitle = @"Title";
static NSString *const kSVTBookYear = @"Year";
static NSString *const kSVTBookBookType = @"BookType";
static NSString *const kSVTBookID = @"ID";
static NSString *const kSVTBookAuthor = @"Author";
static NSString *const kSVTBookOwner = @"Owner";
static NSString *const kSVTBookLanguage = @"Language";
static NSString *const kSVTBookTextOfBook = @"TextOfBook";

@implementation SVTBook

- (instancetype)init
{
    return [self initWithBook:@"title" yearBook:1990 bookType:0 identifier:[[[[NSUUID UUID] UUIDString] mutableCopy] autorelease] author:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        _nameBook = [[coder decodeObjectForKey:kSVTBookTitle] copy];
        _yearBook = [coder decodeIntegerForKey:kSVTBookYear];
        _bookType = [coder decodeIntegerForKey:kSVTBookBookType];
        _identifier = [[coder decodeObjectForKey:kSVTBookID] copy];
        _author = [[coder decodeObjectForKey:kSVTBookAuthor] copy];
        _owner = [coder decodeObjectForKey:kSVTBookOwner];
        _language = [[coder decodeObjectForKey:kSVTBookLanguage] copy];
        _containsOfBook = [[coder decodeObjectForKey:kSVTBookTextOfBook] copy];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_nameBook forKey:kSVTBookTitle];
    [coder encodeInteger:_yearBook forKey:kSVTBookYear];
    [coder encodeInteger:_bookType forKey:kSVTBookBookType];
    [coder encodeObject:_identifier forKey:kSVTBookID];
    [coder encodeObject:_author forKey:kSVTBookAuthor];
    [coder encodeObject:_owner forKey:kSVTBookOwner];
    [coder encodeObject:_language forKey:kSVTBookLanguage];
    [coder encodeObject:_containsOfBook forKey:kSVTBookTextOfBook];
}

- (instancetype)initWithBook:(NSString *)bookName yearBook:(NSInteger)bookYear bookType:(SVTBookType)bookCoverType identifier:(NSString *)aIdentifier author:(NSString *)author
{
    self = [super init];
    if (self)
    {
        _nameBook = [bookName copy];
        _yearBook = bookYear;
        _bookType = bookCoverType;
        _identifier = [aIdentifier copy];
        _author = author ? [author copy] : nil;
        _language = [[NSString alloc] initWithString:@"English"];
        _containsOfBook = [[NSString alloc] initWithString:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."];
    }
    return self;
}

- (instancetype)initWithBook:(NSString *)bookName yearBook:(NSInteger)bookYear bookType:(SVTBookType)bookCoverType author:(NSString *)author
{
    return [self initWithBook:bookName yearBook:bookYear bookType:bookCoverType identifier:[[[NSUUID alloc] init] autorelease].UUIDString author:author];
}

+ (instancetype)bookWithName:(NSString *)name yearBook:(NSInteger)year bookType:(SVTBookType)newType author:(NSString *)author
{
    return [[[self alloc] initWithBook:name yearBook:year bookType:newType author:author] autorelease];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n\nName: %@;\nAuthor: %@;\nYear: %zd;\nType of Book: %@;\nIdentifier: %@;\n\n", self.nameBook, self.author, self.yearBook, self.bookType == kSVTBookTypePaperBack ? @"Paperback" : @"Hardcover", self.identifier];
}

- (void)dealloc
{
    [_nameBook release];
    [_identifier release];
    [_author release];
    [_language release];
    [_containsOfBook release];
    [super dealloc];
}

- (NSUInteger)hash
{
    return [self.nameBook hash] ^ self.yearBook ^ self.bookType ^ [self.identifier hash] ^ [self.owner hash] ^ [self.author hash];
}

- (BOOL)isEqual:(SVTBook *)aBook
{
    BOOL result = NO;
    if ([aBook isKindOfClass:[SVTBook class]] &&
        [self.nameBook isEqualToString:aBook.nameBook] &&
        self.yearBook == aBook.yearBook &&
        self.bookType == aBook.bookType &&
        [self.author isEqualToString:aBook.author] &&
        [self.identifier isEqualToString:aBook.identifier])
        result = YES;
    return result;
}

- (NSString *)nameBook
{
    return _nameBook;
}

- (NSInteger)yearBook
{
    return _yearBook;
}

- (NSString *)identifier
{
    return _identifier;
}

- (SVTBookType)bookType
{
    return _bookType;
}

- (SVTReader *)owner
{
    return _owner;
}

- (NSString *)author
{
    return _author;
}

- (void)setNameBook:(NSString *)newNameBook
{
    if (newNameBook != _nameBook)
    {
        [_nameBook release];
        _nameBook = [newNameBook copy];
    }
}

- (void)setYearBook:(NSInteger)newYearBook
{
    _yearBook = newYearBook;
}

- (void)setBookType:(SVTBookType)newSetBookType
{
    _bookType = newSetBookType;
}

- (void)setOwner:(SVTReader *)owner
{
    _owner = owner;
}

- (void)setAuthor:(NSString *)author
{
    if (_author != author)
    {
        [_author release];
        _author = [author copy];
    }
}

@end
