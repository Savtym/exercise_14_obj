//
//  SVTDictionaryReader.m
//  Exercise 4
//
//  Created by Тимофей Савицкий on 7/9/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTReader+SVTReaderSerilization.h"
#import "SVTBook+SVTBookSerilization.h"

NSString *const kSVTReaderKeyFirstName = @"firstName";
NSString *const kSVTReaderKeyLastName = @"lastName";
NSString *const kSVTReaderKeyYearReader = @"year";
NSString *const kSVTReaderKeyCurrentBook = @"currentBook";

@implementation SVTReader(SVTReaderSerilization)

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)aDictionary
{
    self = [self initWithTitle:aDictionary[kSVTReaderKeyFirstName]
                      lastName:aDictionary[kSVTReaderKeyLastName]
                          year:[aDictionary[kSVTReaderKeyYearReader] integerValue]];
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.firstName)
    {
        result [kSVTReaderKeyFirstName] = self.firstName;
    }
    if (self.lastName)
    {
        result [kSVTReaderKeyLastName] = self.lastName;
    }
    if (self.year)
    {
        result [kSVTReaderKeyYearReader] = [NSNumber numberWithInteger:self.year];
    }
    if (self.currentBook)
    {
        NSMutableArray *currentBook = [[NSMutableArray alloc] init];
        for (SVTBook* iCur in self.currentBook)
        {
            [currentBook addObject: iCur.identifier];
        }
        result [kSVTReaderKeyCurrentBook] = currentBook;
        [currentBook release];
    }
    return result;
}

@end
