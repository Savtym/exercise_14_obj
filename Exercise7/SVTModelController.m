//
//  SVTModelController.m
//  Exericse7
//
//  Created by Тимофей Савицкий on 7/21/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTModelController.h"
#import "SVTReader.h"
#import "SVTBook.h"

@implementation SVTModelController
{
@private
    SVTLibrary *_library;
}

- (instancetype)initWithLibrary:(SVTLibrary *)library
{
    self = [super init];
    if (self != nil)
    {
        if (library != nil)
        {
            _library = [library retain];
        }
        else
        {
            self = nil;
        }
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithLibrary:[[[SVTLibrary alloc] init] autorelease]];
    return self;
}

- (instancetype)initWithLibraryHistory:(NSString *)aPath
{
    SVTLibrary *library = nil;
    if (aPath != nil)
    {
         library = [NSKeyedUnarchiver unarchiveObjectWithFile:aPath];
    }
    else
    {
        library = [[[SVTLibrary alloc] init] autorelease];
    }
    self = [self initWithLibrary:library];
    return self;
}

- (void)dealloc
{
    [_library release];
    [super dealloc];
}


#pragma mark - getters

- (SVTLibrary *)library
{
    return _library;
}

@end
