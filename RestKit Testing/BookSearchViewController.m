//
//  BookSearchViewController.m
//  RestKit Testing
//
//  Created by Philip Nichols on 8/8/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "BookSearchViewController.h"
#import "BooksTableViewController.h"
#import "ScanUPCViewController.h"

@interface BookSearchViewController () <UITextFieldDelegate, ScanUPCViewControllerDelegate>

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
static NSString *ScanUPCSegueIdentifier = @"Scan UPC";

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
            NSString *query = [sender isKindOfClass:[NSString class]] ? sender : self.searchTextField.text;
            [self prepareBooksTableViewController:segue.destinationViewController withSearch:query];
        }
    } else if ([segue.identifier isEqualToString:ScanUPCSegueIdentifier]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            [self prepareScanUPCViewController:[((UINavigationController *)segue.destinationViewController).viewControllers firstObject]];
        }
    }
}

- (void)prepareBooksTableViewController:(BooksTableViewController *)viewController withSearch:(NSString *)search
{
    viewController.query = search;
    viewController.title = search;
}

- (void)prepareScanUPCViewController:(ScanUPCViewController *)viewController
{
    viewController.delegate = self;
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

#pragma mark - ScanUPCViewControllerDelegate

-(void)scanUPCViewController:(ScanUPCViewController *)viewController didFinishScanningWithCode:(NSString *)code
{
    [self performSegueWithIdentifier:SearchBooksSegueIdentifier sender:code];
}

@end
