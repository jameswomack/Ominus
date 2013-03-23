//
//  NGMasterViewController.h
//  Ominus
//
//  Created by James Womack on 3/23/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NGDetailViewController;

@interface NGMasterViewController : UITableViewController

@property (strong, nonatomic) NGDetailViewController *detailViewController;

@end
