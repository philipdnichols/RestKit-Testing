//
//  BooksTableViewController.m
//  RestKit Testing
//
//  Created by Philip Nichols on 8/8/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "BooksTableViewController.h"
#import "BookDetailViewController.h"
#import "BookCell.h"
#import "Book.h"

@interface BooksTableViewController ()

@property (strong, nonatomic) NSArray *books;

@end

@implementation BooksTableViewController

#pragma mark - Properties

- (void)setQuery:(NSString *)query
{
    _query = query;
    if (self.view.window) {
        [self updateUI];
    }
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupRestKit];
    [self updateUI];
}

- (void)updateUI
{
    [self loadBooks];
}

- (void)setupRestKit
{
    NSURL *baseUrl = [NSURL URLWithString:@"https://www.googleapis.com"];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:baseUrl];

    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Book mapping
    RKObjectMapping *bookMapping = [RKObjectMapping mappingForClass:[Book class]];
    [bookMapping addAttributeMappingsFromDictionary:@{
                                                      @"volumeInfo.title" : @"title",
                                                      @"volumeInfo.publisher" : @"publisher",
                                                      @"volumeInfo.publishedDate" : @"publishedDate",
                                                      @"volumeInfo.description" : @"descriptionText",
                                                      @"volumeInfo.imageLinks.thumbnail": @"thumbnailURL",
                                                      @"volumeInfo.authors" : @"authorsArray",
                                                      @"volumeInfo.categories" : @"categoriesArray",
                                                      @"volumeInfo.pageCount" : @"pageCount",
                                                      }];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *bookDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:bookMapping
                                                                                        method:RKRequestMethodGET
                                                                                   pathPattern:@"/books/v1/volumes"
                                                                                       keyPath:@"items"
                                                                                   statusCodes:statusCodes];
    
    [objectManager addResponseDescriptor:bookDescriptor];
}

- (void)loadBooks
{
    NSDictionary *queryParams = @{
                                  @"q": self.query,
                                  @"maxResults" : @(40)
                                  };
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/books/v1/volumes"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.books = [mappingResult array];
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"There was an error retrieving books: %@", error.localizedDescription);
                                              }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.books count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BookCellIdentifier = @"Book Cell";
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:BookCellIdentifier
                                                            forIndexPath:indexPath];
    
    Book *book = self.books[indexPath.row];
    cell.titleLabel.text = book.title;
    cell.authorsLabel.text = book.authors;
    cell.dateLabel.text = book.publishedDate;
    cell.bookImageView.image = nil;
    dispatch_queue_t imageQ = dispatch_queue_create("image queue", NULL);
    dispatch_async(imageQ, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:book.thumbnailURL]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.bookImageView.image = image;
            [cell setNeedsLayout];
        });
    });
    
    return cell;
}

#pragma mark - UINavigationController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString *BookDetailSegueIdentifier = @"Book Detail";
    
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if ([segue.identifier isEqualToString:BookDetailSegueIdentifier]) {
        if (indexPath) {
            if ([segue.destinationViewController isKindOfClass:[BookDetailViewController class]]) {
                [self prepareBookDetailViewController:segue.destinationViewController withBook:self.books[indexPath.row]];
            }
        }
    }
}

- (void)prepareBookDetailViewController:(BookDetailViewController *)viewController withBook:(Book *)book
{
    viewController.book = book;
}

@end
