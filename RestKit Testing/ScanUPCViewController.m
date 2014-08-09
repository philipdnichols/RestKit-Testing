//
//  ScanUPCViewController.m
//  RestKit Testing
//
//  Created by Philip Nichols on 8/9/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "ScanUPCViewController.h"
#import "BooksTableViewController.h"
#import "MTBBarcodeScanner.h"

@interface ScanUPCViewController ()

@property (strong, nonatomic) MTBBarcodeScanner *scanner;
@property (strong, nonatomic) NSString *code; // TODO: should this be strong? Better way to handle passing the code to the table view controller?

@end

@implementation ScanUPCViewController

#pragma mark - Properties

- (MTBBarcodeScanner *)scanner
{
    if (!_scanner) {
        // TODO: Lookee
        //    scanner = [[MTBBarcodeScanner alloc] initWithMetadataObjectTypes:<#(NSArray *)#> previewView:<#(UIView *)#>]
        _scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.view];
    }
    return _scanner;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self startScanning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.scanner stopScanning];
}

- (void)startScanning
{
    [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
        AVMetadataMachineReadableCodeObject *code = [codes firstObject];
        NSLog(@"Code: %@", code.stringValue);
        self.code = code.stringValue;
        [self.scanner stopScanning];
        [self.delegate scanUPCViewController:self didFinishScanningWithCode:self.code];
        [self dismissViewControllerAnimated:YES completion:^{
//            [self.delegate scanUPCViewController:self didFinishScanningWithCode:self.code];
        }];
//        [self performSegueWithIdentifier:SearchBooksByUPCSegueIdentifier
//                                  sender:self];
    }];
}

//static NSString *SearchBooksByUPCSegueIdentifier = @"Search Books By UPC";
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:SearchBooksByUPCSegueIdentifier]) {
//        if ([segue.destinationViewController isKindOfClass:[BooksTableViewController class]]) {
//            if (self.code) {
//                [self prepareBooksTableViewController:segue.destinationViewController withSearch:self.code];
//            }
//        }
//    }
//}
//
//// TODO: This is copied from BookSearchViewController, should we subclass that or something? Delegate?
//- (void)prepareBooksTableViewController:(BooksTableViewController *)viewController withSearch:(NSString *)search
//{
//    viewController.query = search;
//    viewController.title = search;
//}

@end
