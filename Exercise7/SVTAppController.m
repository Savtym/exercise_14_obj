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

@interface SVTAppController ()

@property (assign) IBOutlet NSWindow *window;
@property (retain) SVTViewController *view;
@property (nonatomic, retain) SVTModelController *model;
@end

NSString *const kSVTAppControllerKeyPath = @"history";

@implementation SVTAppController

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    SVTModelController *model = [[SVTModelController alloc] initWithLibraryHistory:kSVTAppControllerKeyPath];
    self.model = model;
    SVTViewController *controller = [[SVTViewController alloc] init];
    [controller setModel:self.model];
    [self.window.contentView addSubview:controller.view];
    self.view = controller;
    [controller release];
    [model release];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.model.library];
    [data writeToFile:kSVTAppControllerKeyPath atomically:NO];
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

@end
