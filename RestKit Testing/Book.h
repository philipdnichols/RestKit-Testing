//
//  Book.h
//  RestKit Testing
//
//  Created by Philip Nichols on 8/8/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *authors;
@property (strong, nonatomic) NSString *publisher;
@property (strong, nonatomic) NSString *publishedDate;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSString *categories;
@property (strong, nonatomic) NSString *thumbnailURL;

@property (strong, nonatomic) NSArray *authorsArray;
@property (strong, nonatomic) NSArray *categoriesArray;

@property (nonatomic) NSUInteger pageCount;

@end
