//
//  ProductViewController.m
//  hardcore
//
//  Created by Donka Stoyanov on 2013-07-20.
//  Copyright (c) 2013 Donka Stoyanov. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------|
////  2015.12.17 Christian Dimitrov added                                                              |
//-----------------------------------------------------------------------------------------------------|

#import "ProductViewController.h"
#import "App.h"
#import "AppDelegate.h"
#import "VideoCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <AVFoundation/AVFoundation.h>
#import "MKStoreManager.h"
#import "MediaPlayer/MediaPlayer.h"
#import "MediaPlayer/MPMediaPlayback.h"


@interface ProductViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;

@end

@implementation ProductViewController

UIActivityIndicatorView *activityIndicator;

#define APPLICATION ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#pragma mark -
#pragma mark View Initialization Code


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.videoListTableView.backgroundColor = UIColor.clearColor;
    self.videoListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.purchaseControlsContainerView.hidden = YES;
    
    // create preview image child control
    self.contentImageView.frame = self.contentContainerView.bounds ;
    [self.contentContainerView addSubview:self.contentImageView];
    self.contentImageView.hidden = YES;
    
    // create activity indicator child control
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = self.contentContainerView.bounds;
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator stopAnimating];
    [self.contentContainerView addSubview:activityIndicator];

    // create movie player child control
 	self.moviePlayerController = [[MPMoviePlayerController alloc] init];
    self.moviePlayerController.view.frame = self.contentContainerView.bounds;
    self.moviePlayerController.view.backgroundColor = UIColor.clearColor;
    
    [self.contentContainerView addSubview:self.moviePlayerController.view];
    self.moviePlayerController.view.hidden = YES;
    self.moviePlayerController.movieSourceType = MPMovieSourceTypeStreaming;
    self.moviePlayerController.controlStyle = MPMovieControlStyleEmbedded;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStoreProductsFetched) name:kProductFetchedNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackStateChanged:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged_Product:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];

    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CALayer *btnLayer = [self.purchaseButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [self.purchaseButton setBackgroundColor:[UIColor whiteColor]];
    self.purchaseButton.hidden = YES;
}

-(void)onStoreProductsFetched
{

    NSLog(@"ProductViewController: Appstore product information received");

    NSArray * storeProducts = [[MKStoreManager sharedManager] purchasableObjects];
    
    for( SKProduct * storeProduct in storeProducts ) {
        for (Video * video in  self.product.videos ) {
            if( [video.appStoreId isEqualToString:storeProduct.productIdentifier] )
            {
                video.price = storeProduct.price;
                video.priceLocale = storeProduct.priceLocale;
                video.purchasable = YES;
            }
        }
    }

 //   [App.instance.catalog dump];

    [self.videoListTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self hidePlayer];
    self.purchaseButton.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.backgroundImageView.clipsToBounds = YES;
    
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
            self.backgroundImageView.image = [UIImage imageNamed:@"wwk_bg_Portrait2.png"];
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
    
    //----------------------------------------------------------------------------------------------------------------------------------------------|
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
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
    [self layoutSubviews];
}


- (void)layoutSubviews {
  //  [View  layoutSubviews];

    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    int margin = 8;
    int centerGap = 6;
    
    CGRect viewBounds = self.view.bounds;

    int centerX = viewBounds.size.width / 2;
    int centerY = viewBounds.size.height / 2;

    CGRect previewBounds;
    CGRect productListBounds;
    if( UIDeviceOrientationIsLandscape( orientation )){
        int controlWidth = centerX - margin - centerGap;
        int controlHeight = viewBounds.size.height - ( margin * 2);
 
        int adj = 75;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            productListBounds = CGRectMake( margin, margin, controlWidth + adj , controlHeight );
            previewBounds = CGRectMake( centerX + adj + centerGap, margin, controlWidth - adj, controlHeight );
        } else {
            productListBounds = CGRectMake( margin, margin, controlWidth, controlHeight );
            previewBounds = CGRectMake( centerX + centerGap, margin, controlWidth, controlHeight );
        }

    } else {
        int controlWidth = viewBounds.size.width - ( margin * 2 );
        int controlHeight = centerY - margin - centerGap;
        previewBounds = CGRectMake( margin, margin, controlWidth, controlHeight );
        productListBounds = CGRectMake( margin, centerY + centerGap, controlWidth, controlHeight );
    }
    
    self.videoListTableView.frame = productListBounds;
    self.contentContainerView.frame = previewBounds;
    if( self.moviePlayerController != NULL   ) {
        self.moviePlayerController.view.frame = self.contentContainerView.bounds;
        activityIndicator.center = self.moviePlayerController.view.center;
    }
    
    [self showProductPreviewImage:self.product];
}


#pragma mark -
#pragma mark product list table view methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.product.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * videoCellReuseID = @"Video_Cell";
    VideoCell * cell = [tableView dequeueReusableCellWithIdentifier:videoCellReuseID];
 

    if( cell == nil ) {
       NSString * deviceSuffix = @"";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            deviceSuffix = @"_iPhone";
        } else {
            deviceSuffix =  @"_iPad";
        }
        
        NSString * nibName = [@[@"VideoCell", deviceSuffix] componentsJoinedByString:@""];
    
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];

    }

    Video *video = [self.product.videos objectAtIndex:indexPath.row];
    
    BOOL isPurchased = [MKStoreManager isFeaturePurchased:video.appStoreId];

  //  float price = video.price.floatValue;
  //  BOOL isFree = ((video.price != NULL) && (price < 0.01)) || (video.appStoreId.length == 0 );
    

    
    cell.videoTitleLabel.text = video.title;
    cell.videoDescriptionLabel.text = video.description;
    [cell setBackgroundColor:[ UIColor clearColor]];

    [cell.indicatorImage setHidden: !isPurchased];
    cell.priceLabel.text = video.priceAsString;
    if( video.thumbnailImageUrls.count > 0 )
    {
        NSString * urlString = [video.thumbnailImageUrls objectAtIndex:0];
        // DebugLog(@"Video %@, thumbNail: %@", video.title, urlString);
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        [cell.videoThumbnailImageView setImageWithURL:url usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
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

Video *selectedVideo = nil;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // If you want to push another view upon tapping one of the cells on your table.
    
    if( indexPath.row < self.product.videos.count ) {
        selectedVideo = [self.product.videos objectAtIndex:indexPath.row];
        [self showSelectedVideo:TRUE];
    }
 }

-(void)showSelectedVideo: (BOOL)autoPlay{
    [self showVideo:selectedVideo :autoPlay];
}

-(void)showVideo: (Video *)video :(BOOL)autoPlay
{
    [self showVideoPreviewImage:video];

    BOOL isStoreReady = (video.purchasable == YES) && (video.price != NULL);

    BOOL isPurchased = [MKStoreManager isFeaturePurchased:video.appStoreId];

    float price = video.price.floatValue;
    BOOL isFree = ((video.price != NULL) && (price < 0.01)) || (video.appStoreId.length == 0 );
    
    if( isPurchased || isFree ) {
        [self hidePurchaseControls];
        [self prepareVideo:video :autoPlay];
    }
    else if( isStoreReady)
    {
        [self showPurchaseControls:video];
        [self hidePlayer];
    }
    else
    {
        NSLog(@"Cannot show video with App Store ID: %@", video.appStoreId);
    }
  //  [self hidePurchaseControls];
  //  [self prepareVideo:video :autoPlay];
}


-(void)prepareVideo:(Video *)video :(BOOL)autoPlay
{
    if( video.videoUrl == NULL || video.videoUrl.length == 0 )
        return;

    NSURL *movieUrl = [NSURL URLWithString:video.videoUrl];
    NSLog(@"Start Video:%@", [movieUrl absoluteString]);

    [self stopVideo];
    [self hidePlayer];
    [self showVideoPreviewImage:video];
    [self hidePurchaseControls];
    [self.moviePlayerController setContentURL:movieUrl];
    [self.moviePlayerController prepareToPlay];
    [self.moviePlayerController setCurrentPlaybackTime:0.0];
    self.moviePlayerController.shouldAutoplay = autoPlay;
    if( autoPlay ) {
        [self showActivityIndicator];
    }
    else
    {
        [self hideActivityIndicator];
    }

}

-(void)pauseVideo
{
    if( self.moviePlayerController.playbackState == MPMoviePlaybackStatePlaying ) {
        [self.moviePlayerController pause];
    }
    else
    {
        [self.moviePlayerController play];
    }
}

-(void)stopVideo
{
    [self.moviePlayerController stop];
    
}

-(void)showActivityIndicator
{
    [self.contentContainerView bringSubviewToFront:activityIndicator];
    [activityIndicator startAnimating];
}

-(void)hideActivityIndicator
{
     [activityIndicator stopAnimating];
}

-(void)setPreviewImage:(NSString *)fileName
{
    self.contentImageView.image = [UIImage imageNamed:fileName];
}

-(void)hidePreviewImage
{
     self.contentImageView.hidden = YES;
}

-(void)showPlayer
{
    self.moviePlayerController.view.hidden = NO;
    [self.contentContainerView bringSubviewToFront:self.moviePlayerController.view];
    [self hidePreviewImage];
    [self hideActivityIndicator];
    self.purchaseControlsContainerView.hidden = YES;

}

-(void)hidePlayer
{
    self.moviePlayerController.view.hidden = YES;
    self.purchaseControlsContainerView.hidden = NO;
    [self hideActivityIndicator];
}




#pragma mark notification handlers #pragma mark -


- (void) moviePlayerPlaybackStateChanged:(NSNotification *)notification
{
   MPMoviePlayerController * player = [notification object];
    
   if (player.playbackState == MPMoviePlaybackStateInterrupted) {
        NSLog(@"Playback State: MPMoviePlaybackStateInterrupted");
       [self showActivityIndicator];
       
   } else if (player.playbackState & MPMoviePlaybackStatePaused ) {
        NSLog(@"Playback State: MPMoviePlaybackStatePaused");
       
   } else if (player.playbackState & MPMoviePlaybackStatePlaying ) {
        NSLog(@"Playback State: MPMoviePlaybackStatePlaying");
       [self showPlayer];
   
   } else if (player.playbackState & MPMoviePlaybackStateSeekingBackward ) {
        NSLog(@"Playback State: MPMoviePlaybackStateSeekingBackward");
   
   } else if (player.playbackState & MPMoviePlaybackStateSeekingForward ) {
        NSLog(@"Playback State: MPMoviePlaybackStateSeekingForward");
   
   } else if (player.playbackState &  MPMoviePlaybackStateStopped) {
        NSLog(@"Playback State: MPMoviePlaybackStateStopped");
       
   } else {
        NSLog(@"Playback State: Error - invalid playback state %ld", (long)player.playbackState);
   }
}



- (void) moviePlayerLoadStateChanged:(NSNotification *)notification
{

    MPMoviePlayerController * player = [notification object];
    NSLog(@"moviePlayerLoadStateChanged received with loadstate=%lu", (unsigned long)player.loadState);


    if (player.loadState & MPMovieLoadStatePlayable) {
        NSLog(@"playbackState: MPMovieLoadStatePlayable");
        [self showPlayer];
    }
    
    if(player.loadState & MPMovieLoadStatePlaythroughOK) {
        NSLog(@"playbackState: MPMovieLoadStatePlaythroughOK");
    }
    
    if(player.loadState & MPMovieLoadStateStalled)
    {
        NSLog(@"playbackState: MPMovieLoadStateStalled");
    }
    
    if(player.loadState == MPMovieLoadStateUnknown) {
        NSLog(@"playbackState: MPMovieLoadStateUnknown");
    }
}
  
- (void)moviePlayerPlaybackFinished:(NSNotification *)notification
{
    NSDictionary *notificationUserInfo = [notification userInfo];
    NSNumber *resultValue = [notificationUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    MPMovieFinishReason reason = [resultValue intValue];

    if (reason == MPMovieFinishReasonPlaybackEnded) {
        //movie finished playin
        [self.moviePlayerController setFullscreen:NO animated:YES];
        [self showActionsheet];
    }else if (reason == MPMovieFinishReasonUserExited) {
        //user hit the done button
        NSLog(@"User hit the done button");

    }else if (reason == MPMovieFinishReasonPlaybackError)
    {
            NSError *mediaPlayerError = [notificationUserInfo objectForKey:@"error"];
        if (mediaPlayerError) 
        {
            NSLog(@"playback failed with error description: %@", [mediaPlayerError localizedDescription]);
        }
        else
        {
            NSLog(@"playback failed without any given reason");
        }
    }

    [self showSelectedVideo:FALSE];
}

-(void)hidePurchaseControls
{
    self.purchaseControlsContainerView.hidden = YES;
}

-(void)showPurchaseControls:(Video *)video
{
    self.purchaseControlsContainerView.hidden = NO;

    // update the purchase button
    NSString *priceAsString = video.priceAsString;
    NSString *priceLabel = [NSString stringWithFormat:@"Buy: %@", priceAsString];

    [self.purchaseButton setTitle:priceLabel forState:UIControlStateNormal];
    [self.purchaseButton setBackgroundColor:[UIColor whiteColor]];
}

-(void)showVideoPreviewImage:(Video *)video
{
    // update the preview image

    if( video.previewImageUrls.count > 0 )
    {
        __weak typeof(self) weakSelf = self;
         NSString *url = [video.previewImageUrls objectAtIndex:0];
         NSLog(@"Loading video preview image: %@", url);
        
         [self.contentImageView setImageWithURL:[NSURL URLWithString:[video.previewImageUrls objectAtIndex:0]]
            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
            if( image) {
                CGRect imageBounds = AVMakeRectWithAspectRatioInsideRect(self.contentImageView.image.size, self.contentContainerView.bounds);
   
            // DebugLog(@"%f %f %f %f", imageBounds.origin.x,imageBounds.origin.y,imageBounds.size.width,imageBounds.size.height );
            // DebugLog(@"%f %f %f %f", purchaseControlsContainerView.bounds.origin.x,purchaseControlsContainerView.bounds.origin.y,purchaseControlsContainerView.bounds.size.width,purchaseControlsContainerView.bounds.size.height );
   
            self.purchaseControlsContainerView.frame = CGRectMake(
                imageBounds.size.width + imageBounds.origin.x - self.purchaseControlsContainerView.bounds.size.width - 10,
                imageBounds.size.height + imageBounds.origin.y - self.purchaseControlsContainerView.bounds.size.height - 10,
                self.purchaseControlsContainerView.bounds.size.width,
                self.purchaseControlsContainerView.bounds.size.height);


            [weakSelf.contentContainerView bringSubviewToFront:weakSelf.purchaseControlsContainerView];
            }
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.contentImageView.hidden = NO;
        self.purchaseButton.hidden = NO;
        self.purchaseControlsContainerView.hidden = NO;
    } else
    {
        self.contentImageView.hidden = YES;
        [self hidePurchaseControls];
    }
}

-(void)showProductPreviewImage:(Product *)prod
{
    // update the preview image

    if( prod.previewImageUrls.count > 0 )
    {
        __weak typeof(self) weakSelf = self;
    //   NSString *url = [video.thumbnailImageUrls objectAtIndex:0];
        // DebugLog(@"Loading video preview image: %@", url);

         [self.contentImageView setImageWithURL:[NSURL URLWithString:[prod.previewImageUrls objectAtIndex:0]]
            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *urlImage) {
        
                if( !error ) {
                CGRect imageBounds = AVMakeRectWithAspectRatioInsideRect(self.contentImageView.image.size, self.contentContainerView.bounds);
   
            // DebugLog(@"%f %f %f %f", imageBounds.origin.x,imageBounds.origin.y,imageBounds.size.width,imageBounds.size.height );
            // DebugLog(@"%f %f %f %f", purchaseControlsContainerView.bounds.origin.x,purchaseControlsContainerView.bounds.origin.y,purchaseControlsContainerView.bounds.size.width,purchaseControlsContainerView.bounds.size.height );
   
            self.purchaseControlsContainerView.frame = CGRectMake(
                imageBounds.size.width + imageBounds.origin.x - self.purchaseControlsContainerView.bounds.size.width - 10,
                imageBounds.size.height + imageBounds.origin.y - self.purchaseControlsContainerView.bounds.size.height - 10,
                self.purchaseControlsContainerView.bounds.size.width,
                self.purchaseControlsContainerView.bounds.size.height);


            [weakSelf.contentContainerView bringSubviewToFront:weakSelf.purchaseControlsContainerView];
            }
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.contentImageView.hidden = NO;
    } else
    {
        self.contentImageView.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContentImageView:nil];
    [self setVideoListTableView:nil];
    [self setPurchaseControlsContainerView:nil];
    [self setContentContainerView:nil];
    [self setPurchaseButton:nil];
    [super viewDidUnload];
}

- (IBAction)buyNow:(id)sender {

  [[MKStoreManager sharedManager] buyFeature:selectedVideo.appStoreId
                                    onComplete:^(NSString* purchasedFeature,
                                                 NSData* purchasedReceipt,
                                                 NSArray* availableDownloads)
     {
        // DebugLog(@"Purchased: %@", purchasedFeature);
        [self showSelectedVideo:TRUE];
     }
     onCancelled:^
     {
         // User cancels the transaction, you can log this using any analytics software like Flurry.
     }];

}




//-----------------------------------------------------------------------------------------------------|
////  2015.12.17 Christian Dimitrov added                                                              |
//-----------------------------------------------------------------------------------------------------|
#pragma mark actionSheet Delegate
-(void)showActionsheet
{
    UIActionSheet *popup = nil;
    popup = [[UIActionSheet alloc] initWithTitle:@"Great workout! \n You can post about it to inspire your friends." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
             @"Share on Facebook",
             @"Share on Twitter",
             nil];
    
    [popup showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self performSelector:@selector(shareFacebook) withObject:nil afterDelay:0.5];
            break;
            
        case 1:{
            [self performSelector:@selector(shareTwitter) withObject:nil afterDelay:0.5];
            break;
        }
        default:
            break;
    }
}

- (void)shareFacebook {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        [JSWaiter ShowWaiter:self title:@"Requesting..." type:0];
        
        SLComposeViewController* fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
#ifdef HARDCORE
        [fbSheet setInitialText:@"Feeling #Fit & Fab after a #Workout with Kira! #SFL #Fitfam #FitLife"];
        [fbSheet addURL:[NSURL URLWithString:@"http://apple.co/1TLJaiV"]];
#endif
        
        //#ifdef BRIDES
        //                [fbSheet setInitialText:@"Feeling #Fit & Fab after a #Workout with Kira! #SFL #Fitfam #FitLife"];
        //                [fbSheet addURL:[NSURL URLWithString:@"http://apple.co/1IF2Bc7"]];
        //#endif
        
#ifdef PILATES
        [fbSheet setInitialText:@"Feeling great after a #Pilates247 #Workout!"];
        [fbSheet addURL:[NSURL URLWithString:@"http://apple.co/1QzaOjc"]];
#endif
        
#ifdef BALLET
        [fbSheet setInitialText:@"I Just toned up with a #Barre #Workout from the #Ballet #Barre #Fit App!"];
        [fbSheet addURL:[NSURL URLWithString:@"http://apple.co/1IF2Bc7"]];
#endif
        
        
        [fbSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    [APPLICATION showMessage:@"Posting Failed." withTitle:@"Fail"];
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    [APPLICATION showMessage:@"You are inspiring your friends!" withTitle:@"Success"];
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:fbSheet animated:YES completion:^{
            [JSWaiter HideWaiter];
        }];
        
    }
    else{
        [APPLICATION showMessage:@"Accounts" withTitle:@"Please login to a Facebook account to share."];
    }
}

- (void)shareTwitter{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        [JSWaiter ShowWaiter:self title:@"Requesting..." type:0];
        
        SLComposeViewController* twitSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
#ifdef HARDCORE
        [twitSheet setInitialText:@"@kiraelste\n"];
        [twitSheet addURL:[NSURL URLWithString:@"http://apple.co/1TLJaiV"]];
#endif
        
        //#ifdef BRIDES
        //                [twitSheet addURL:[NSURL URLWithString:@"http://apple.co/1IF2Bc7"]];
        //#endif
        
        
#ifdef PILATES
        [twitSheet setInitialText:@"@kiraelste\n"];
        [twitSheet addURL:[NSURL URLWithString:@"http://apple.co/1QzaOjc"]];
#endif
        
#ifdef BALLET
        [twitSheet setInitialText:@"@kiraelste\n"];
        [twitSheet addURL:[NSURL URLWithString:@"http://apple.co/1IF2Bc7"]];
#endif
        
        [twitSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [twitSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    [APPLICATION showMessage:@"Posting Failed." withTitle:@"Fail"];
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    [APPLICATION showMessage:@"You are inspiring your friends!" withTitle:@"Success"];
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:twitSheet animated:YES completion:^{
            //put your code here
            [JSWaiter HideWaiter];
        }];
    }
    else{
        [APPLICATION showMessage:@"Accounts" withTitle:@"Please login to a Twitter account to share."];
    }
}

-(void) deviceOrientationChanged_Product:(NSNotification*)notification{
    
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
            self.backgroundImageView.image = [UIImage imageNamed:@"wwk_bg_Portrait2.png"];
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
    
    //---------------------------------------------------------------------------------------------------------------------------------------------|
}

@end
