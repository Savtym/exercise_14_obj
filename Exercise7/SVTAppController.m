//
//  AppDelegate.m
//  Exercise7
//
//  Created by Тимофей Савицкий on 7/26/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTAppController.h"
#import "SVTViewController.h"
#import "SVTModelController.h"

@interface SVTAppController()

@property (assign) IBOutlet NSWindow *window;
@property (retain, readwrite) SVTViewController *view;
@property (nonatomic, retain, readwrite) SVTModelController *model;
@end

NSString *const kSVTAppControllerKeyPath = @"history";

@implementation SVTAppController
{
@private
    SVTViewController *_view;
    SVTModelController *_model;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    SVTModelController *model = [[SVTModelController alloc] initWithLibraryHistory:kSVTAppControllerKeyPath];
    self.model = model;
    SVTViewController *controller = [[SVTViewController alloc] initWithModel:self.model];
    [self.window.contentView addSubview:controller.view];
    self.view = controller;
    [controller release];
    [model release];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [self.model writeTofilePath:kSVTAppControllerKeyPath];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)dealloc
{
    [_model release];
    [_view release];
    [super dealloc];
}


#pragma mark - getters

- (SVTViewController *)view
{
    return _view;
}

- (SVTModelController *)model
{
    return _model;
}


#pragma mark - setters

- (void)setView:(SVTViewController *)view
{
    if (view != _view)
    {
        [_view release];
        _view = [view retain];
    }
}

- (void)setModel:(SVTModelController *)model
{
    if (model != _model)
    {
        [_model release];
        _model = [model retain];
    }
}

@end
