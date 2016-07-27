//
//  SVTViewController.h
//  Exericse7
//
//  Created by Тимофей Савицкий on 7/20/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SVTModelController;

@interface SVTViewController : NSViewController
@property (nonatomic, retain, readwrite) SVTModelController *model;
@end
