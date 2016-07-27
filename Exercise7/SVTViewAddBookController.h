//
//  SVTViewChangeBookController.h
//  Exericse7
//
//  Created by Тимофей Савицкий on 7/25/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SVTModelController;

@interface SVTViewAddBookController : NSViewController<NSWindowDelegate>

- (instancetype)initWithAddBook:(SVTModelController *)model;

@end
