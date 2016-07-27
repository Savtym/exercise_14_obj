//
//  SVTDictionaryBook.h
//  Exercise 4
//
//  Created by Тимофей Савицкий on 7/9/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVTBook.h"

@interface SVTBook(SVTBookSerilization)

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)aDictionary;
- (NSDictionary *)dictionaryRepresentation;

@end
