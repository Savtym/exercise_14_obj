//
//  SVTViewChangeVisitorControllerButtonGiveBook.m
//  Exericse7
//
//  Created by Тимофей Савицкий on 7/23/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTTableCellViewButton.h"

@implementation SVTTableCellViewButton
{
@private
    NSButton *_buttonGiveBook;
    NSPopUpButton *_popUpButtonTypeCover;
}

#pragma mark - setters

- (NSButton *)buttonGiveBook
{
    return _buttonGiveBook;
}

- (NSPopUpButton *)popUpButtonTypeCover
{
    return _popUpButtonTypeCover;
}


#pragma mark - getters

- (void)setButtonGiveBook:(NSButton *)buttonGiveBook
{
    _buttonGiveBook = buttonGiveBook;
}

- (void)setPopUpButtonTypeCover:(NSPopUpButton *)popUpButtonTypeCover
{
    _popUpButtonTypeCover = popUpButtonTypeCover;
}

@end
