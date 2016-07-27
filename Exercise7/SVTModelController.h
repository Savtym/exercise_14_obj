//
//  SVTModelController.h
//  Exericse7
//
//  Created by Тимофей Савицкий on 7/21/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVTLibrary.h"

@interface SVTModelController : NSObject

- (instancetype)initWithLibrary:(SVTLibrary *)library NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithLibraryHistory:(NSString *)aPath;

@property (retain, readonly, nonatomic) SVTLibrary *library;
@end
