//
//  ScanUPCViewController.h
//  RestKit Testing
//
//  Created by Philip Nichols on 8/9/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScanUPCViewController;

@protocol ScanUPCViewControllerDelegate <NSObject>

- (void)scanUPCViewController:(ScanUPCViewController *)viewController didFinishScanningWithCode:(NSString *)code;

@end

@interface ScanUPCViewController : UIViewController

@property (weak, nonatomic) id <ScanUPCViewControllerDelegate> delegate;

@end
