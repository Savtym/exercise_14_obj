//
//  SVTReader.m
//  Exercise 3
//
//  Created by Тимофей Савицкий on 7/6/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTReader.h"

@interface SVTReader() <NSCoding>
@property (readwrite) NSMutableArray<SVTBook *> *mCurrentBook;
@end

static NSString *const kSVTReaderFirstName = @"FirstName";
static NSString *const kSVTReaderLastName = @"LastName";
static NSString *const kSVTReaderYear = @"Year";
static NSString *const kSVTReaderCurrentBook = @"CurrentBook";

@implementation SVTReader {
@private
    NSString *_firstName;
    NSString *_lastName;
    NSUInteger _year;
    NSMutableArray *_mCurrentBook;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _firstName = [[NSString alloc] init];
        _lastName = [[NSString alloc] init];
        _mCurrentBook = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)newFirstName lastName:(NSString *)newLastName year:(NSUInteger)newYear
{
    self = [self init];
    if (self)
    {
        _firstName = [newFirstName copy];
        _lastName = [newLastName copy];
        _year = newYear;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _firstName = [[coder decodeObjectForKey:kSVTReaderFirstName] copy];
        _lastName = [[coder decodeObjectForKey:kSVTReaderLastName] copy];
        _year = [coder decodeIntegerForKey:kSVTReaderYear];
        _mCurrentBook = [[coder decodeObjectForKey:kSVTReaderCurrentBook] mutableCopy];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_firstName forKey:kSVTReaderFirstName];
    [coder encodeObject:_lastName forKey:kSVTReaderLastName];
    [coder encodeInteger:_year forKey:kSVTReaderYear];
    [coder encodeObject:_mCurrentBook forKey:kSVTReaderCurrentBook];
}

+ (instancetype)personWithName:(NSString *)newFirstName lastName:(NSString *)newLastName year:(NSUInteger)newYear
{
    return [[[self alloc] initWithTitle:newFirstName lastName:newLastName year:newYear] autorelease];
}

- (BOOL)takeBook:(SVTBook *)aSVTBook
{
    BOOL result = NO;
    if (!aSVTBook.owner)
    {
        [self.mCurrentBook addObject:aSVTBook];
        aSVTBook.owner = self;
        result = YES;
    }
    return result;
}

- (BOOL)returnBook:(SVTBook *)aBook
{
    BOOL result = NO;
    if ([self.currentBook containsObject:aBook])
    {
        [self.mCurrentBook removeObject:aBook];
        result = YES;
    }
    return result;
}

- (NSUInteger)hash
{
    return [self.firstName hash] ^ [self.lastName hash] ^ self.year ^ [self.currentBook hash] ^ [self.fullName hash];
}

- (BOOL)isEqual:(SVTReader*)aReader
{
    BOOL result = NO;
    if ([aReader isKindOfClass:[SVTReader class]] &&
        [self.firstName isEqualToString:aReader.firstName] &&
        [self.lastName isEqualToString:aReader.lastName] &&
        self.year == aReader.year &&
        [self.currentBook isEqualToArray:aReader.currentBook])
    {
        result = YES;
    }
    return result;
}

- (void)dealloc
{
    [_firstName release];
    [_lastName release];
    [_mCurrentBook release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n%@ %@\n",[super description], self.fullName];
}

- (NSString *)firstName
{
    return _firstName;
}

- (NSString *)lastName
{
    return _lastName;
}

- (NSUInteger)year
{
    return _year;
}

- (NSArray<SVTBook *> *)currentBook
{
    return (NSArray *)_mCurrentBook;
}

- (NSString*)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (void)setFirstName:(NSString *)aFirstName
{
    if (aFirstName != _firstName)
    {
        [_firstName release];
        _firstName = [aFirstName copy];
    }
}

- (void)setLastName:(NSString *)aLastName
{
    if (aLastName != _lastName)
    {
        [_lastName release];
        _lastName = [aLastName copy];
    }
}

- (void)setYear:(NSUInteger)aYear
{
    _year = aYear;
}

@end
