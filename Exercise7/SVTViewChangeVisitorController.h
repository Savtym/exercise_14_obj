//
//  SVTViewChangeVisitorController.h
//  Exericse7
//
//  Created by Тимофей Савицкий on 7/23/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SVTModelController;

@interface SVTViewChangeVisitorController : NSViewController<NSWindowDelegate>

- (instancetype)initWithChangeVisitor:(SVTModelController *)model row:(NSInteger)row;

@property (readonly) NSInteger row;
@property (readonly) BOOL addReader;

@end
