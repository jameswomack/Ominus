//
//  NGDetailViewController.m
//  Ominus
//
//  Created by James Womack on 3/23/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import "NGDetailViewController.h"

#import "WaveformImageView.h"

@interface NGDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation NGDetailViewController



#pragma mark —
#pragma mark View lifecycle


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!NGDeviceiPad)
    {
        [self setupWaveformView];
    }
}



#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
        
        if (NGDeviceiPad)
        {
            [self setupWaveformView];
        }
        
        [self configureView];
    }

    if (self.masterPopoverController != nil)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    if (self.detailItem)
    {
        self.detailDescriptionLabel.text = $(self.detailItem).description;
    }
}


- (void)setupWaveformView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NGNotificationHash *hash = [NGNotificationHash hashWithType:NGNotificationTypePath andObject:_detailItem];
        
        [NSNotification notificationWithName:NGReadyNamePath andHash:hash shouldAutoPost:YES];
    });
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
