//
//  BookSearchViewController.m
//  RestKit Testing
//
//  Created by Philip Nichols on 8/8/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "BookSearchViewController.h"
#import "BooksTableViewController.h"

@interface BookSearchViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation BookSearchViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchTextField.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.searchTextField resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.searchTextField.text = @"";
}

#pragma mark - UIViewController

static NSString *SearchBooksSegueIdentifier = @"Search Books";

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:SearchBooksSegueIdentifier]) {
        if (![self.searchTextField.text length]) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Please enter a search!"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil] show];
            return NO;
        }
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SearchBooksSegueIdentifier]) {
        if ([segue.destinationViewController isKindOfClass:[BooksTableViewController class]]) {
            [self prepareBooksTableViewController:segue.destinationViewController withSearch:self.searchTextField.text];
        }
    }
}

- (void)prepareBooksTableViewController:(BooksTableViewController *)viewController withSearch:(NSString *)search
{
    viewController.query = search;
    viewController.title = search;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.searchTextField) {
        if ([self shouldPerformSegueWithIdentifier:SearchBooksSegueIdentifier sender:textField]) {
            [self performSegueWithIdentifier:SearchBooksSegueIdentifier sender:textField];
        
            return NO;
        }
    }
    return YES;
}

@end
