//
//  SVTDictionaryLibrary.m
//  Exercise 4
//
//  Created by Тимофей Савицкий on 7/9/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTLibrary+SVTLibrarySerilization.h"
#import "SVTReader+SVTReaderSerilization.h"
#import "SVTBook+SVTBookSerilization.h"

NSString *const kSVTReaderKeyBooks = @"books";
NSString *const kSVTReaderKeyReaders = @"readers";

@implementation SVTLibrary(SVTLibrarySerilization)

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)aDictionary
{
    self = [self init];
    if (self)
    {
        for (NSDictionary *iCur in aDictionary[kSVTReaderKeyBooks])
        {
            [self addBook:[[[SVTBook alloc] initWithDictionaryRepresentation:iCur] autorelease]];
        }
        for (NSDictionary *iCur in aDictionary[kSVTReaderKeyReaders])
        {
            SVTReader *reader = [[[SVTReader alloc] initWithDictionaryRepresentation:iCur] autorelease];
            for (NSString *iCurrentBook in iCur[@"currentBook"])
            {
                for (SVTBook *jCur in self.books)
                {
                    if ([jCur.identifier isEqualToString:iCurrentBook])
                    {
                        [reader takeBook:jCur];
                        break;
                    }
                }
            }
            [self addReader:reader];
        }
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.books)
    {
        NSMutableArray *books = [[NSMutableArray alloc] init];
        for (SVTBook* iCur in self.books)
        {
            [books addObject:[iCur dictionaryRepresentation]];
        }
        result [kSVTReaderKeyBooks] = books;
        [books release];
    }
    if (self.readers)
    {
        NSMutableArray *readers = [[NSMutableArray alloc] init];
        for (SVTReader* iCur in self.readers)
        {
            [readers addObject:[iCur dictionaryRepresentation]];
        }
        result [kSVTReaderKeyReaders] = readers;
        [readers  release];
    }
    return result;
}

@end
