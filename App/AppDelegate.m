//
//  AppDelegate.m
//  hardcore
//
//  Created by Donka Stoyanov on 2013-07-20.
//  Copyright (c) 2013 Donka Stoyanov. All rights reserved.
//-----------------------------------------------------------------------------------------------------|
////  2015.12.17 Christian Dimitrov added                                                              |
//-----------------------------------------------------------------------------------------------------|


#ifdef DEBUG
#define userDefaultsFileName @"UserDefaultsForDebug"
#else
#define userDefaultsFileName @"UserDefaults"
#endif

#import "Reachability.h"
#import "App.h"
#import "AppDelegate.h"
#import "CatalogViewController.h"
#import "UIImageView+WebCache.h"
//#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "MKStoreManager.h"


@implementation AppDelegate

UINavigationController *navigationController;
CatalogViewController *catalogViewController = nil;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [self registerUserDefaults];
    
    // Allocate a reachability object
    self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];

    // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
    self.reachability.reachableOnWWAN = YES;

    // Here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                         selector:@selector(reachabilityChanged:) 
                                             name:kReachabilityChangedNotification 
                                           object:nil];

 //   dispatch_async(dispatch_get_global_queue(0,0), ^{
        [self.reachability startNotifier];
 //   });

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        catalogViewController = [[CatalogViewController alloc] initWithNibName:@"CatalogViewController_iPad" bundle:nil];
    } else {
        catalogViewController = [[CatalogViewController alloc] initWithNibName:@"CatalogViewController_iPad" bundle:nil];
    }
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:catalogViewController];

    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    [App.instance.catalog beginAsyncCatalogUpdate];
    
    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    application.applicationIconBadgeNumber = 0;

    
//----------Configuration Parse----------------------------------------------------
    
#ifdef HARDCORE
    [Parse setApplicationId:@"x1qxcRQkFIJmuYcRDpZSXjRktNgyNwJVoCMOB6NG"
                  clientKey:@"5wzQMhQEZBxjKSKnO9EwprfBQ7I0Y9XSMnHodvjt"];
#endif
    
    //#ifdef BRIDES
    //                [fbSheet setInitialText:@"Feeling #Fit & Fab after a #Workout with Kira! #SFL #Fitfam #FitLife"];
    //                [fbSheet addURL:[NSURL URLWithString:@"http://apple.co/1IF2Bc7"]];
    //#endif
    
#ifdef PILATES
    [Parse setApplicationId:@"XbwKxXpRY4QwhqkLAn0RZbcgAY2C6piqeJdvBIP7"
                  clientKey:@"0FwXUX6en6Gg1xuyybGaQIfcOsjfSOsXg6AaWWnL"];
#endif
    
#ifdef BALLET
    [Parse setApplicationId:@"SktxEJDwLcJxWq7T3qvf5pMk0BOyp02CBjwMVljS"
                  clientKey:@"z9yXvww731I0vi2LZ5ApdjmRydGXFOTvX3MRMCPi"];
#endif
    
    
//------------------------------------------------------------------------------
    
    return YES;
}

#pragma mark - Reachability

- (void)reachabilityChanged:(NSNotification *)note {

    NetworkStatus ns = [(Reachability *)[note object] currentReachabilityStatus];

    if (ns == NotReachable) {

        if (![self.networkAlert isVisible]) {

            if ([self networkAlert] == nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\n\nNo Internet Connection" message:@"This application needs an internet connection to view the online catalog." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                [self setNetworkAlert:alert];
            }

            [self.networkAlert show];  
        }
    } else {

        if ([self networkAlert] != nil) {

            [self.networkAlert dismissWithClickedButtonIndex:0 animated:YES]; 
        }
        
        if( ![App.instance.catalog isValid])
        {
            [App.instance.catalog beginAsyncCatalogUpdate];
        }
    }
    
}

-(void)registerUserDefaults {
    // DebugLog(@"Loading defaults from %@", userDefaultsFileName);
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:userDefaultsFileName ofType:@"plist"]]];
    
    App.instance.catalogUrl = [[NSURL alloc] initWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"ProductionCatalogUrl"] ];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}


//-----------------------------------------------------------------------------------------------------|
////  2015.12.21 Christian Dimitrov added                                                              |
//-----------------------------------------------------------------------------------------------------|


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger appLaunchAmounts = [userDefaults integerForKey:@"LaunchAmounts"];
    if (appLaunchAmounts == 10)
    {
        //Use AlertView
        self.rateAlert = [[UIAlertView alloc] initWithTitle:@"Kira Elste"
                                    message:@"Are you loving your workouts?"
                                   delegate:self
                          cancelButtonTitle:@"Yes"
                          otherButtonTitles:@"No", nil];
        [self.rateAlert show];
    }
    [userDefaults setInteger:appLaunchAmounts+1 forKey:@"LaunchAmounts"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.rateAlert) {
        switch (buttonIndex) {
            case 0:{
                
#ifdef HARDCORE
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id651185676"]];
#endif
                
#ifdef PILATES
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id566829078"]];
#endif
                
#ifdef BALLET
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id539386047"]];
#endif

                
                break;
            }
            case 1:
            {
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                
                // Email Subject
                NSString *emailTitle = @"You can ask questions of Kira & her team by emailing here:";
                // Email Content
                NSString *messageBody = @"";
                // To address
                NSArray *toRecipents = [NSArray arrayWithObject:@"info@kirasworkouts.com"];
                
                if([MFMailComposeViewController canSendMail])
                {
                    [mc setSubject:emailTitle];
                    [mc setMessageBody:messageBody isHTML:NO];
                    [mc setToRecipients:toRecipents];
                    mc.mailComposeDelegate = self;
                    [catalogViewController presentViewController:mc animated:YES completion:NULL];
                }
                else{
                    //[APPLICATION showMessage:@"Your device could not send e-mail. Please check e-mail configuration and try again." withTitle:@"Error"];
                }
                
                // Present mail view controller on screen
            }
            default:
                break;
        }
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [catalogViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings // NS_AVAILABLE_IOS(8_0);
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


//-----------------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------|
////  2015.12.17 Christian Dimitrov added                                                              |
//-----------------------------------------------------------------------------------------------------|
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Parse the incoming URL to look for a target_url parameter
                                      NSString *query = [url fragment];
                                      if (!query) {
                                          query = [url query];
                                      }
                                      NSDictionary *params = [self parseURLParams:query];
                                      // Check if target URL exists
                                      NSString *targetURLString = [params valueForKey:@"target_url"];
                                      if (targetURLString) {
                                          // Show the incoming link in an alert
                                          // Your code to direct the user to the appropriate flow within your app goes here
                                          [[[UIAlertView alloc] initWithTitle:@"Received link:"
                                                                      message:targetURLString
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil] show];
                                      }
                                  }];
    
    return urlWasHandled;
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

// A function for parsing URL parameters
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}
//---------------------------------------------------------------------------------------------------------------------------|


@end
