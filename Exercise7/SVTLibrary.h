//
//  SVTLibrary.h
//  Exercise 4
//
//  Created by Тимофей Савицкий on 7/8/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVTBook.h"
#import "SVTReader.h"

@interface SVTLibrary : NSObject

- (instancetype)initWithTitle:(NSArray *)newBooks readers:(NSArray *)newReaders;

- (void)addBook:(SVTBook *)aBook;
- (void)removeBook:(SVTBook *)aBook;

- (void)addReader:(SVTReader *)aReader;
- (void)removeReader:(SVTReader *)aReader;

- (instancetype)initWithFilePath:(NSString *)aPath;
- (void)writeToFilePath:(NSString *)aPath;

- (NSArray*)findReader:(NSString*)aReader;
- (NSArray*)findBook:(NSString*)aBook;

@property (atomic, readonly, assign) NSArray<SVTBook *> *books;
@property (atomic, readonly, assign) NSArray<SVTReader *> *readers;

@end
