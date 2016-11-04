//
//  ProductViewController.h
//  hardcore
//
//  Created by Donka Stoyanov on 2013-07-20.
//  Copyright (c) 2013 Donka Stoyanov. All rights reserved.
//-----------------------------------------------------------------------------------------------------|
////  2015.12.17 Christian Dimitrov added                                                              |
//-----------------------------------------------------------------------------------------------------|

#import <UIKit/UIKit.h>
#import "Product.h"
#import "Video.h"
#import "JSWaiter.h"
#import "AppDelegate.h"

@interface ProductViewController : UIViewController

@property (strong, nonatomic) Product * product;

@property (strong, nonatomic) IBOutlet UIImageView *contentImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIView *contentContainerView;

@property (strong, nonatomic) IBOutlet UITableView *videoListTableView;
@property (strong, nonatomic) IBOutlet UIView *purchaseControlsContainerView;
@property (strong, nonatomic) IBOutlet UIButton *purchaseButton;

- (IBAction)buyNow:(id)sender;

- (void) moviePlayerLoadStateChanged:(NSNotification *)notification;
- (void) moviePlayerPlaybackStateChanged:(NSNotification *)notification;
- (void) moviePlayerPlaybackFinished:(NSNotification *)notification;
-(void) deviceOrientationChanged_Product:(NSNotification*)notification;

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
