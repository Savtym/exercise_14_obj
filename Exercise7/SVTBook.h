//
//  SVTBook.h
//  Exercise 3
//
//  Created by Тимофей Савицкий on 7/6/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SVTReader;

typedef NS_ENUM (NSInteger, SVTBookType) {
    kSVTBookTypePaperBack = 0,
    kSVTBookTypeHardCover = 1
};

@interface SVTBook : NSObject

- (instancetype)initWithBook:(NSString *)bookName yearBook:(NSInteger)bookYear bookType:(SVTBookType)bookCoverType author:(NSString *)author;
- (instancetype)initWithBook:(NSString *)bookName yearBook:(NSInteger)bookYear bookType:(SVTBookType)bookCoverType identifier:(NSString *)aIdentifier author:(NSString *)author;

+ (instancetype) bookWithName:(NSString *)name yearBook:(NSInteger)year bookType:(SVTBookType)newType author:(NSString *)author;

@property (readwrite, copy) NSString *nameBook;
@property (readwrite) NSInteger yearBook;
@property (readonly, copy) NSString *identifier;
@property (readwrite, nonatomic) SVTBookType bookType;
@property (readwrite, assign) SVTReader *owner;
@property (readwrite, copy) NSString *author;
@property (readwrite, copy) NSString *containsOfBook;
@property (readwrite, copy) NSString *language;

@end
