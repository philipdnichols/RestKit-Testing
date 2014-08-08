//
//  BookDetailViewController.m
//  RestKit Testing
//
//  Created by Philip Nichols on 8/8/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "BookDetailViewController.h"

@interface BookDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;

@end

@implementation BookDetailViewController

#pragma mark - Properties

- (void)setBook:(Book *)book
{
    _book = book;
    if (self.view.window) {
        [self updateUI];
    }
}

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI
{
    self.titleLabel.text = self.book.title;
    self.authorsLabel.text = self.book.authors;
    self.publisherLabel.text = self.book.publisher;
    self.publishedDateLabel.text = self.book.publishedDate;
    self.pageCountLabel.text = [NSString stringWithFormat:@"%d pages", self.book.pageCount];
    self.descriptionTextView.text = self.book.descriptionText;
    self.categoriesLabel.text = self.book.categories;
    dispatch_queue_t imageQ = dispatch_queue_create("image queue", NULL);
    dispatch_async(imageQ, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.book.thumbnailURL]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bookImageView.image = image;
        });
    });
}

@end
