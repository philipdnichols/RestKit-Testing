//
//  Book.m
//  RestKit Testing
//
//  Created by Philip Nichols on 8/8/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "Book.h"

@implementation Book

#pragma mark - Properties

- (NSString *)publishedDate
{
    NSArray *components = [_publishedDate componentsSeparatedByString:@"-"];
    return components[0];
}

- (NSString *)authors
{
    return [self.authorsArray componentsJoinedByString:@", "];
}

- (NSString *)categories
{
    return [self.categoriesArray componentsJoinedByString:@", "];
}

@end
