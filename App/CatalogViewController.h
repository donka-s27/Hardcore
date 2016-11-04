//
//  CatalogViewController.h
//  hardcore
//
//  Created by Donka Stoyanov on 2013-07-20.
//  Copyright (c) 2013 Donka Stoyanov. All rights reserved.
//-----------------------------------------------------------------------------------------------------|
////  2015.12.17 Christian Dimitrov added                                                              |
//-----------------------------------------------------------------------------------------------------|

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

#import "App.h"
#import "AppDelegate.h"
#import "JSWaiter.h"


#define APPLICATION ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@interface CatalogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *productListTableView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

- (IBAction)restorePurchases:(id)sender;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *supportButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *fbButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *instagramButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *twButton;

- (IBAction)emailToKira:(id)sender;
- (IBAction)showHomePage:(id)sender;
- (IBAction)postToFB:(id)sender;
- (IBAction)postToInstagram:(id)sender;
- (IBAction)postToTwitter:(id)sender;

-(void) deviceOrientationChanged_Catalog:(NSNotification*)notification;


@end
