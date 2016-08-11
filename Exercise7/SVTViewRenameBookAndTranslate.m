//
//  SVTViewRenameBookAndTranslate.m
//  Exercise8
//
//  Created by Тимофей Савицкий on 8/10/16.
//  Copyright © 2016 Тимофей Савицкий. All rights reserved.
//

#import "SVTViewRenameBookAndTranslate.h"
#import "SVTModelController.h"

@interface SVTViewRenameBookAndTranslate ()
@property (retain, readwrite) SVTBook *book;
@property (readwrite, copy) NSString *textOfTranslate;
@property (readwrite, copy) NSDictionary *lang;
@property (readwrite, copy) NSDictionary *langTranslate;
@property (readwrite, copy) NSString *languageTranslate;
@property (readwrite, copy) NSArray<NSString *> *accessLanguageTranslate;
@end

NSString * const kSVTViewRenameBookAndTranslateLanguage = @"langs";
NSString * const kSVTViewRenameBookAndTranslateLanguageDirs = @"dirs";
NSString * const kSVTViewRenameBookAndTranslateApiLanguage = @"https://translate.yandex.net/api/v1.5/tr.json/getLangs";
NSString * const kSVTViewRenameBookAndTranslateApiLanguageTranslate = @"https://translate.yandex.net/api/v1.5/tr.json/translate";
NSString * const kSVTViewRenameBookAndTranslateApiLanguageKey = @"trnsl.1.1.20160810T173532Z.3cd57aaa8ea0b9c0.542d7a19d0f80a7f86c1cc1002932cfdd11d81f9";
NSString * const kSVTViewRenameBookAndTranslateApiLanguageGet = @"en";
NSString * const kSVTViewRenameBookAndTranslateApiLanguageTranslateText = @"text";

@implementation SVTViewRenameBookAndTranslate

- (instancetype)initWithBook:(SVTBook *)book row:(NSUInteger)row
{
    self = [super initWithNibName:@"SVTViewRenameBookAndTranslate" bundle:nil];
    if (self)
    {
        _row = row;
        _book = [book retain];
        _lang = [[NSDictionary alloc] init];
        _languageTranslate = [[NSString alloc] init];
        self.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self getLanguage];
    }
    return self;
}

- (void)getLanguage
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?ui=%@&key=%@",kSVTViewRenameBookAndTranslateApiLanguage, kSVTViewRenameBookAndTranslateApiLanguageGet, kSVTViewRenameBookAndTranslateApiLanguageKey]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^
      (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          if (error != nil)
          {
              NSLog(@"ERROR: %@", error);
          }
          else
          {
              id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
              
              if ([json isKindOfClass:[NSDictionary class]])
              {
                  NSDictionary *location = (NSDictionary *)json;
                  if ([[location objectForKey:@"status"] compare:@"ok"] == NSOrderedSame)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^
                         {
                             self.lang = location[kSVTViewRenameBookAndTranslateLanguage];
                             self.langTranslate = location[kSVTViewRenameBookAndTranslateLanguageDirs];
                             self.textOfTranslate = [location description];
                             [self popUpButtonChange];
                         });
                  }
                  else
                  {
                      dispatch_async(dispatch_get_main_queue(), ^
                         {
                             NSLog(@"Error");
                         });
                  }
              }
          }
      }];
    [task resume];
}

- (IBAction)popUpButtonClickLanguage:(NSPopUpButton *)sender
{
    [self popUpButtonChange];
}

- (IBAction)popupButtonSelectedLanguageTranslate:(NSPopUpButton *)sender
{
    [self translate];
}

- (void)popUpButtonChange
{
    NSArray *translateAccess = [self.lang allKeysForObject:self.book.language];
    NSMutableArray *translatePost = [[[NSMutableArray alloc] init] autorelease];
    for (NSString *lang in self.langTranslate)
    {
        if ([lang containsString:[NSString stringWithFormat:@"%@-", translateAccess[0]]])
        {
            [translatePost addObject:lang];
        }
    }
    NSMutableArray *popUpButtonTranslate = [[[NSMutableArray alloc] init] autorelease];
    for (NSString *language in translatePost)
    {
        NSString *lang = [language substringFromIndex:3];
        [popUpButtonTranslate addObject:self.lang[lang]];
    }
    self.accessLanguageTranslate = popUpButtonTranslate;
}

- (void)translate
{
    NSArray *translateAccess = [self.lang allKeysForObject:self.languageTranslate];
    NSArray *bookLanguage = [self.lang allKeysForObject:self.book.language];
    NSString *lang = [NSString stringWithFormat:@"%@-%@", bookLanguage[0], translateAccess[0]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?key=%@&lang=%@",kSVTViewRenameBookAndTranslateApiLanguageTranslate, kSVTViewRenameBookAndTranslateApiLanguageKey, lang]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *text = [NSString stringWithFormat:@"text=%@", self.book.containsOfBook];
    NSData *jsonObject = [text dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = jsonObject;
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^
      (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          if (error != nil)
          {
              NSLog(@"ERROR: %@", error);
          }
          else
          {
              id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
              
              if ([json isKindOfClass:[NSDictionary class]])
              {
                  NSDictionary *location = (NSDictionary *)json;
                  if ([[location objectForKey:@"status"] compare:@"ok"] == NSOrderedSame)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^
                         {
                             self.textOfTranslate = location[@"text"][0];
                         });
                  }
                  else
                  {
                      dispatch_async(dispatch_get_main_queue(), ^
                         {
                             NSLog(@"Error");
                         });
                  }
              }
          }
      }];
    [task resume];
}


@end
