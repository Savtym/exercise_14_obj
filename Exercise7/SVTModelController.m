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
    if (self)
    {
        if (library)
        {
            _library = [library retain];
        }
        else
        {
            [self release];
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
    if (aPath)
    {
        library = [NSKeyedUnarchiver unarchiveObjectWithFile:aPath];
        if (!library)
        {
            library = [[[SVTLibrary alloc] init] autorelease];
        }
    }
    else
    {
        library = [[[SVTLibrary alloc] init] autorelease];
    }
    self = [self initWithLibrary:library];
    return self;
}

- (void)writeTofilePath:(NSString *)aPath
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.library];
    [data writeToFile:aPath atomically:NO];
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
