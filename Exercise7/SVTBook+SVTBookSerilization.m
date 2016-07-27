//
//  SVTDictionaryBook.m
//  Exercise 4
//
//  Created by Тимофей Савицкий on 7/9/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTBook+SVTBookSerilization.h"
#import "SVTReader+SVTReaderSerilization.h"

NSString *const kSVTReaderKeyTitle = @"title";
NSString *const kSVTReaderKeyYear = @"year";
NSString *const kSVTReaderKeyType = @"type";
NSString *const kSVTReaderKeyOwner = @"owner";
NSString *const kSVTReaderKeyIdentifier = @"identifier";
NSString *const kSVTReaderKeyAuthor = @"author";

@implementation SVTBook(SVTBookSerilization)

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)aDictionary
{
    return [self initWithBook:aDictionary[kSVTReaderKeyTitle]
                       yearBook:[aDictionary[kSVTReaderKeyYear] integerValue]
                       bookType:[aDictionary[kSVTReaderKeyType] intValue]
                     identifier:aDictionary[kSVTReaderKeyIdentifier]
                       author:aDictionary[kSVTReaderKeyAuthor]];
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.nameBook)
    {
        result [kSVTReaderKeyTitle] = self.nameBook;
    }
    if (self.yearBook)
    {
        result [kSVTReaderKeyYear] = [NSNumber numberWithInteger: self.yearBook];
    }
    if (self.bookType == kSVTBookTypePaperBack || self.bookType == kSVTBookTypeHardCover)
    {
        result [kSVTReaderKeyType] = [NSNumber numberWithInt: self.bookType];
    }
    if (self.identifier)
    {
        result [kSVTReaderKeyIdentifier] = self.identifier;
    }
    if (self.author)
    {
        result [kSVTReaderKeyAuthor] = self.author;
    }
    return result;
}

@end
