//
//  AppDelegate.h
//  hardcore
//
//  Created by Donka Stoyanov on 2013-07-20.
//  Copyright (c) 2013 Donka Stoyanov. All rights reserved.
//-----------------------------------------------------------------------------------------------------|
////  2015.12.17 Christian Dimitrov added                                                              |
//-----------------------------------------------------------------------------------------------------|

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <Parse/Parse.h>

#import "Reachability.h"
#import "JSWaiter.h"

@class ViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UIActionSheetDelegate>
{

}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) Reachability *reachability;
@property (strong, nonatomic) UIAlertView * networkAlert;
@property (strong, nonatomic) UIAlertView * rateAlert;


- (NSDictionary*)parseURLParams:(NSString *)query;
- (void)showMessage:(NSString *)text withTitle:(NSString *)title;

@end
