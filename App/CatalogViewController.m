//
//  CatalogViewController.m
//  hardcore
//
//  Created by Donka Stoyanov on 2013-07-20.
//  Copyright (c) 2013 Donka Stoyanov. All rights reserved.
//-----------------------------------------------------------------------------------------------------|
////  2015.12.17 Christian Dimitrov added                                                              |
//-----------------------------------------------------------------------------------------------------|

#import "CatalogViewController.h"
#import "App.h"
#import "Catalog.h"
#import "Product.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "ProductViewController.h"
#import "ProductCell.h"
#import "ODRefreshControl.h"
#import "Reachability.h"
#import "MKStoreManager.h"



@interface CatalogViewController ()
{
    BOOL _bannerIsVisible;
    IBOutlet ADBannerView *_adBanner;
}

@end

@implementation CatalogViewController

ODRefreshControl *refreshControl = nil;
ProductViewController *productViewController = nil;



#pragma mark -
#pragma mark View Initialization Code

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI)
        name:UIApplicationWillEnterForegroundNotification object:nil];

    self.contentImageView.image = [UIImage imageNamed:@"Default Welcome Image.png"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStoreProductsFetched) name:kProductFetchedNotification object:nil];

    self.navigationController.navigationBarHidden = YES;
    self.productListTableView.backgroundColor = UIColor.clearColor;
    self.productListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImage *imageFB = [[UIImage imageNamed:@"FB.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.fbButton setImage:imageFB];
    
    UIImage *imageTw = [[UIImage imageNamed:@"Twitter.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.twButton setImage:imageTw];
    
    UIImage *imageIns = [[UIImage imageNamed:@"Instagram.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.instagramButton setImage:imageIns];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    _bannerIsVisible = FALSE;
    _adBanner.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged_Catalog:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

-(void)updateUI{
   [self.productListTableView reloadData];
    self.supportButton.enabled = true;
}


-(void)viewDidAppear:(BOOL)animated
{
    [self updateUI];
    self.toolbar.hidden = NO;
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.backgroundImageView.clipsToBounds = YES;
    
    //-----------------------------------------------------------------------------------------------------|
    ////  2015.12.21 Christian Dimitrov added                                                              |
    //-----------------------------------------------------------------------------------------------------|
    
    if(UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        
#ifdef HARDCORE
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [UIImage imageNamed:@"wwk_bg_Landscape.png"];
        });
#endif
        
        //#ifdef BRIDES
        //                [fbSheet setInitialText:@"Feeling #Fit & Fab after a #Workout with Kira! #SFL #Fitfam #FitLife"];
        //                [fbSheet addURL:[NSURL URLWithString:@"http://apple.co/1IF2Bc7"]];
        //#endif
        
#ifdef PILATES
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [UIImage imageNamed:@"pilates247_bg_landscape.png"];
        });
#endif
        
#ifdef BALLET
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [UIImage imageNamed:@"BalletBarreFitness_bg_Landscape.png"];
        });
#endif
        
    }
    else{
        
#ifdef HARDCORE
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [UIImage imageNamed:@"wwk_bg_Portrait.png"];
        });
#endif
        
        //#ifdef BRIDES
        //                [fbSheet setInitialText:@"Feeling #Fit & Fab after a #Workout with Kira! #SFL #Fitfam #FitLife"];
        //                [fbSheet addURL:[NSURL URLWithString:@"http://apple.co/1IF2Bc7"]];
        //#endif
        
#ifdef PILATES
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [UIImage imageNamed:@"pilates247_bg_portrait.png"];
        });
#endif
        
#ifdef BALLET
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [UIImage imageNamed:@"BalletBarreFitness_bg_Portrait.png"];
        });
#endif
        
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------|
}

-(void)showWelcomeImage
{
    if( App.instance.welcomeImageUrls.count > 0 ) {
        NSString *url = [App.instance.welcomeImageUrls objectAtIndex:0];
        // DebugLog(@"Loading welcomeImage: %@", url);
        [self.contentImageView setImageWithURL:[[NSURL alloc] initWithString:url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark -
#pragma mark View Layout Code

-(void)viewWillLayoutSubviews
{
 //  [self loadCatalog];

   // DebugLog(@"layoutSubViews");
   [self layoutSubviews];
}

- (void)layoutSubviews {
  //  [View  layoutSubviews];

    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    int margin = 8;
    int centerGap = 6;
    
    CGRect viewBounds = self.view.bounds;
    int height = viewBounds.size.height;
    int width = viewBounds.size.width;

    int centerX = width / 2;
    int centerY = height / 2;

    CGRect previewBounds;
    CGRect productListBounds;
    if( UIDeviceOrientationIsLandscape(orientation)){
        int controlWidth = centerX - margin - centerGap;
        int controlHeight = height - ( margin * 2);
        
        int adj = 75;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            productListBounds = CGRectMake( margin, margin, controlWidth + adj , controlHeight );
            previewBounds = CGRectMake( centerX + adj + centerGap, margin, controlWidth - adj, controlHeight );
        } else {
            productListBounds = CGRectMake( margin, margin, controlWidth, controlHeight );
            previewBounds = CGRectMake( centerX + adj + centerGap, margin, controlWidth - adj, controlHeight );
        }
        self.productListTableView.frame = productListBounds;
        if (_bannerIsVisible)
            self.productListTableView.frame = CGRectMake(self.productListTableView.frame.origin.x, self.productListTableView.frame.origin.y + _adBanner.bounds.size.height, self.productListTableView.frame.size.width, self.productListTableView.frame.size.height - self.toolbar.bounds.size.height);
    } else {
        int controlWidth = viewBounds.size.width - ( margin * 2 );
        int controlHeight = centerY - margin - centerGap;

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            previewBounds = CGRectMake( margin, margin, controlWidth, controlHeight );
            productListBounds = CGRectMake( margin, centerY + centerGap, controlWidth, controlHeight );
        } else {
            previewBounds = CGRectMake( margin, margin, controlWidth, controlHeight );
            productListBounds = CGRectMake( margin, centerY + centerGap, controlWidth, controlHeight );
        }
        self.productListTableView.frame = productListBounds;
    }
    self.contentImageView.frame = previewBounds;
    if (_bannerIsVisible)
        self.contentImageView.frame = CGRectMake(self.contentImageView.frame.origin.x, self.contentImageView.frame.origin.y + _adBanner.frame.size.height / 2, self.contentImageView.frame.size.width, self.contentImageView.frame.size.height);
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


#pragma mark -
#pragma mark product list table view methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return App.instance.catalog.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * productCellReuseID = @"Product_Cell";
    ProductCell * cell = [tableView dequeueReusableCellWithIdentifier:productCellReuseID];
    if( cell == nil ){
    
        NSString * deviceSuffix = @"";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            deviceSuffix = @"_iPhone";
        } else {
            deviceSuffix =  @"_iPad";
        }
        
        NSString * nibName = [@[@"ProductCell", deviceSuffix] componentsJoinedByString:@""];
    
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    
    Product *p = [App.instance.catalog.products objectAtIndex:indexPath.row];
    
    
    
    cell.titleLabel.text = p.title;
    cell.descriptionLabel.text = p.description;
    [cell setBackgroundColor:[ UIColor clearColor]];
    if( p.thumbnailImageUrls.count > 0 )
    {
        NSString * urlString = [p.thumbnailImageUrls objectAtIndex:0];
        // DebugLog(@"Product %@, thumbNail: %@", p.title, urlString);
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        [cell.productThumbnailImageView setImageWithURL:url usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
         
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return 75;
    }
    else {
        return 100;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( indexPath.row < App.instance.catalog.products.count ) {
        productViewController = [[ProductViewController alloc] initWithNibName:@"ProductView_iPad" bundle:nil];

        productViewController.product = [App.instance.catalog.products objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:productViewController animated:true];
    }
}

-(BOOL) designModeEnabled {
    return [UIDevice.currentDevice.name rangeOfString:@"*test*" options:NSCaseInsensitiveSearch].location != NSNotFound;
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{

    if( self.designModeEnabled ) {
        [self selectCatalogSource];
    }
    
}

-(void)onStoreProductsFetched
{

    NSLog(@"Appstore product information received");

    NSArray * storeProducts = [[MKStoreManager sharedManager] purchasableObjects];
    
    for( SKProduct * storeProduct in storeProducts ) {
        NSLog( @"- %@", storeProduct.productIdentifier);
        for( Product * product in App.instance.catalog.products) {
            for (Video * video in  product.videos ) {
              //  NSLog( @"  - %@", video.appStoreId);
                
                if( [video.appStoreId isEqualToString:storeProduct.productIdentifier] )
                {
                    video.price = storeProduct.price;
                    video.priceLocale = storeProduct.priceLocale;
                    video.purchasable = YES;
                }
            }
        }
    }

    [App.instance.catalog dump];

    [self.productListTableView reloadData];
    [self showWelcomeImage];
    [refreshControl endRefreshing];

}


-(void)refreshCatalog
{
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    
    [App.instance.catalog beginAsyncCatalogUpdate];
}

-(void)selectCatalogSource{
    UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Debug Mode" message:@"Select a catalog source" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Production", @"Test", @"Debug", nil];
    [v show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
       case 1:
            App.instance.catalogUrl = [[NSURL alloc] initWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"TestCatalogUrl"]];
            break;
       case 2:
            App.instance.catalogUrl = [[NSURL alloc] initWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"DebugCatalogUrl"]];
            break;
            
        default:
            App.instance.catalogUrl = [[NSURL alloc] initWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"ProductionCatalogUrl"] ];
            break;
    };
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refreshCatalog];
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setProductListTableView:nil];
    [self setContentImageView:nil];
    [self setToolbar:nil];
    [self setSupportButton:nil];
    [super viewDidUnload];
}

- (IBAction)restorePurchases:(id)sender {
    [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^{
        [self refreshCatalog];
    } onError:^(NSError *error) {
        // DebugLog(@"Error restoring purchases: %@", [error localizedDescription]);
    }];
}
- (IBAction)showHomePage:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.kiraelste.com"]];
}


//-----------------------------------------------------------------------------------------------------|
////  2015.12.17 Christian Dimitrov added                                                              |
//-----------------------------------------------------------------------------------------------------|

- (IBAction)postToFB:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/KirasWorkouts"]];
}

- (IBAction)postToInstagram:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.instagram.com/kira_elste"]];
}

- (IBAction)postToTwitter:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/KiraElste"]];
}

- (IBAction)emailToKira:(id)sender {
    //[[MKStoreManager sharedManager] removeAllKeychainData];
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
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else{
        //[APPLICATION showMessage:@"Your device could not send e-mail. Please check e-mail configuration and try again." withTitle:@"Error"];
    }
    
    // Present mail view controller on screen
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [APPLICATION showMessage:@"Mail cancelled" withTitle:@"Email"];
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            [APPLICATION showMessage:@"Mail saved" withTitle:@"Email"];
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            [APPLICATION showMessage:@"Mail sent" withTitle:@"Email"];
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            [APPLICATION showMessage:[NSString stringWithFormat:@"Mail sent failure: %@", [error localizedDescription]] withTitle:@"Email"];
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        [UIView commitAnimations];
        _bannerIsVisible = YES;
        banner.hidden = NO;
        self.contentImageView.frame = CGRectMake(self.contentImageView.frame.origin.x, self.contentImageView.frame.origin.y + _adBanner.frame.size.height / 2, self.contentImageView.frame.size.width, self.contentImageView.frame.size.height);
        if(UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
            self.productListTableView.frame = CGRectMake(self.productListTableView.frame.origin.x, self.productListTableView.frame.origin.y + _adBanner.frame.size.height, self.productListTableView.frame.size.width, self.productListTableView.frame.size.height - self.toolbar.bounds.size.height);
        }
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Failed to retrieve ad");
    
    if (_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        [UIView commitAnimations];
        
        _bannerIsVisible = NO;
    }
}

-(void) deviceOrientationChanged_Catalog:(NSNotification*)notification{
    
    if(UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        
#ifdef HARDCORE
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [UIImage imageNamed:@"wwk_bg_Landscape.png"];
        });
#endif
        
        //#ifdef BRIDES
        //                [fbSheet setInitialText:@"Feeling #Fit & Fab after a #Workout with Kira! #SFL #Fitfam #FitLife"];
        //                [fbSheet addURL:[NSURL URLWithString:@"http://apple.co/1IF2Bc7"]];
        //#endif
        
#ifdef PILATES
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [UIImage imageNamed:@"pilates247_bg_landscape.png"];
        });
#endif
        
#ifdef BALLET
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [UIImage imageNamed:@"BalletBarreFitness_bg_Landscape.png"];
        });
#endif
        
    }
    else{
        
#ifdef HARDCORE
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [UIImage imageNamed:@"wwk_bg_Portrait.png"];
        });
#endif
        
        //#ifdef BRIDES
        //                [fbSheet setInitialText:@"Feeling #Fit & Fab after a #Workout with Kira! #SFL #Fitfam #FitLife"];
        //                [fbSheet addURL:[NSURL URLWithString:@"http://apple.co/1IF2Bc7"]];
        //#endif
        
#ifdef PILATES
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [UIImage imageNamed:@"pilates247_bg_portrait.png"];
        });
#endif
        
#ifdef BALLET
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [UIImage imageNamed:@"BalletBarreFitness_bg_Portrait.png"];
        });
#endif
        
    }
}
//-----------------------------------------------------------------------------------------------------------------------------------|


@end
