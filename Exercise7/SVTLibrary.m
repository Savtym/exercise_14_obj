//
//  SVTLibrary.m
//  Exercise 4
//
//  Created by Тимофей Савицкий on 7/8/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTLibrary.h"
#import "SVTLibrary+SVTLibrarySerilization.h"

@interface SVTLibrary() <NSCoding>
@property (readonly) NSMutableArray<SVTBook *> *mBooks;
@property (readonly) NSMutableArray<SVTReader *> *mReaders;
@end

static NSString *const kSVTLibraryBooks = @"Books";
static NSString *const kSVTLibraryReaders = @"Readers";


@implementation SVTLibrary
{
@private
    NSMutableArray<SVTBook *> *_mBooks;
    NSMutableArray<SVTReader *> *_mReaders;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _mBooks = [[NSMutableArray alloc] init];
        _mReaders = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _mBooks = [[coder decodeObjectForKey:kSVTLibraryBooks] mutableCopy];
        _mReaders = [[coder decodeObjectForKey:kSVTLibraryReaders] mutableCopy];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_mBooks forKey:kSVTLibraryBooks];
    [coder encodeObject:_mReaders forKey:kSVTLibraryReaders];
}

- (instancetype)initWithTitle:(NSMutableArray*)newBooks readers:(NSMutableArray*)newReaders
{
    self = [self init];
    if (self)
    {
        [_mBooks addObjectsFromArray:newBooks];
        [_mReaders addObjectsFromArray:newReaders];
    }
    return self;
}

- (void)addBook:(SVTBook *)aBook
{
    if ([self.books containsObject:aBook])
    {
        @throw (@"This book already in library");
    }
    [self.mBooks addObject:aBook];
}

- (void)removeBook:(SVTBook *)aBook
{
    [self.mBooks removeObject:aBook];
}

- (void)addReader:(SVTReader *)aReader
{
    if ([self.readers containsObject:aReader])
    {
        @throw (@"This reader already in library");
    }
    [self.mReaders addObject:aReader];
}

- (void)removeReader:(SVTReader *)aReader
{
    [self.mReaders removeObject:aReader];
}

- (NSUInteger)hash
{
    return [self.books count] ^ [self.readers count];
}

- (BOOL)isEqualToArrayBook:(NSArray<SVTBook *> *)array
{
    BOOL result = NO;
    BOOL resultNO = NO;
    for (SVTBook *iCur in array)
    {
        for (SVTBook *jCur in self.books)
        {
            if ([iCur isEqual:jCur])
            {
                result = YES;
                break;
            }
            if (iCur == self.books.lastObject)
            {
                result = NO;
                resultNO = YES;
            }
        }
        if (resultNO)
        {
            break;
        }
    }
    return result;
}

- (BOOL)isEqualToArrayReader:(NSArray<SVTReader *> *)array
{
    BOOL result = NO;
    BOOL resultNO = NO;
    for (SVTReader *iCur in array)
    {
        for (SVTReader *jCur in self.readers)
        {
            if ([iCur isEqual:jCur])
            {
                result = YES;
                break;
            }
            if (iCur == self.readers.lastObject)
            {
                result = NO;
                resultNO = YES;
            }
        }
        if (resultNO)
        {
            break;
        }
    }
    return result;
}

- (BOOL)isEqual:(SVTLibrary*)aLibrary
{
    BOOL result = NO;
    if ([aLibrary isKindOfClass:[SVTLibrary class]] &&
        self.hash == aLibrary.hash &&
        [self isEqualToArrayBook:aLibrary.books] &&
        [self isEqualToArrayReader:aLibrary.readers])
    {
        result = YES;
    }
    return result;
}

- (instancetype)initWithFilePath:(NSString *)aPath
{
    NSError *error = nil;
    NSString *stringFromFileAtPath = [[NSString alloc] initWithContentsOfFile:aPath encoding:NSUTF8StringEncoding error:&error];
    if(!stringFromFileAtPath)
    {
        NSLog(@"initWithFilePath: error: %@", error.localizedDescription);
        stringFromFileAtPath = @"{}";
    }
    NSData *data = [stringFromFileAtPath dataUsingEncoding:NSUTF8StringEncoding];
    [stringFromFileAtPath release];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return [self initWithDictionaryRepresentation:dictionary];
}

- (void)writeToFilePath:(NSString *)aPath
{
    NSError *error = nil;
    NSDictionary *dict = [self dictionaryRepresentation];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    [jsonData writeToFile:aPath atomically:NO];
}

- (NSArray*)findReader:(NSString*)aReader
{
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    for (SVTReader *iCur in self.readers)
    {
        if ([iCur.fullName rangeOfString:aReader options:(NSCaseInsensitiveSearch)].length != 0)
        {
            [result addObject:iCur];
        }
    }
    return result;
}

- (NSArray*)findBook:(NSString*)aBook
{
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    for (SVTBook *iCur in self.books)
    {
        if ([iCur.nameBook rangeOfString:aBook options:(NSCaseInsensitiveSearch)].length != 0)
        {
            [result addObject:iCur];
        }
    }
    return result;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"\nLibrary:%@\n%@",self.books,self.readers];
}

- (void)dealloc
{
    [_mBooks release];
    [_mReaders release];
    [super dealloc];
}

- (NSArray<SVTBook *> *)books
{
    return (NSArray *) self.mBooks;
}

- (NSArray<SVTReader *> *)readers
{
    return (NSArray *) self.mReaders;
}
@end
