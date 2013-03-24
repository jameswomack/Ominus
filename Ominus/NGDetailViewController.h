//
//  NGDetailViewController.h
//  Ominus
//
//  Created by James Womack on 3/23/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaveformImageVew;

@interface NGDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet WaveformImageVew *waveformImageVIew;


@end
