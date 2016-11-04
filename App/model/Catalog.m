//
//  Catalog.m
//  hardcore
//
//  Created by Garth S. Tissington on 7/8/13.
//  Copyright (c) 2013 Kira Elste. All rights reserved.
//

#import "Catalog.h"
#import "Product.h"
#import "Video.h"
#import "App.h"
#import "UIImageView+WebCache.h"
#import "MKStoreManager.h"

#include <pthread.h>

#define jsonCatalogKey @"jsonCatalog"
#define jsonCatalogCacheTimeKey @"jsonCatalogCacheTime"

NSLock *lock = NULL;

NSString *const kCatalogChangedNotification = @"kCatalogChangedNotification";

@implementation Catalog

@synthesize products;

NSDate * jsonCatalogCachedTime = NULL;


-(id)init
{
    if( self = [super init]) {
        lock = [[NSLock alloc] init];

        NSLog(@"Init Catalog");
        if( products == nil )
        {
            products = [[NSMutableArray alloc ] init];
            [self initializeCatalogFromLocalCache];
        }
        return self;
    }
    else {
        return nil;
    }
}

-(BOOL)isValid
{
    if( jsonCatalogCachedTime == NULL )
    {
        return FALSE;
    }
    
    NSTimeInterval age = [jsonCatalogCachedTime timeIntervalSinceNow];
    double expiry = (-1.0 * 24.0 * 60.0 * 60.0 );
    
    return age > expiry;

}

-(void)initializeCatalogFromLocalCache
{
    // try to load the Catalog from user defaults;

    NSData * jsonCatalog = [[NSUserDefaults standardUserDefaults] objectForKey:jsonCatalogKey];
 //   jsonCatalogCachedTime = [[NSUserDefaults standardUserDefaults] objectForKey:jsonCatalogCacheTimeKey];
    if( jsonCatalog == NULL ) {
        // load the default catalog
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"catalog" ofType:@"json"];
        jsonCatalog = [NSData dataWithContentsOfFile:jsonPath];
        NSLog(@"Loaded default catalog" );
    }
    else
    {
        NSLog(@"Loaded cached catalog from %@", jsonCatalogCachedTime );
    }
    [self parseCatalog:jsonCatalog];
}


-(void)beginAsyncCatalogUpdate
{
    
    NSLog(@"Load on-line catalog from: %@", App.instance.catalogUrl );
    dispatch_async(kBgQueue,
        ^{
            if( [lock tryLock]) {
        
                NSError *error = nil;
                NSData* data = [NSData dataWithContentsOfURL:App.instance.catalogUrl options:NSDataReadingUncached error:&error];
                if (data != nil) {
                    NSLog(@"Online catalog data received");

                    jsonCatalogCachedTime = [NSDate date];
                    
                    [self parseSettings:data];
                            
                    if( [self parseCatalog:data ]  )
                    {
                        if( products.count > 0 ) {
                            
                            // cache the catalog
                            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"jsonCatalog"];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"jsonCatalogCacheTimeKey"];
                            
                            [[MKStoreManager sharedManager] reloadProducts];
                        }
                    }
                }
        
                [lock unlock];
            }
        });
       
    
}

-(NSMutableArray *)appStoreIdList{
    
    NSMutableArray * idList = [[NSMutableArray alloc] init];
    
    for( Product *p in products){
        for( Video *v in p.videos ) {
            if( v.appStoreId != NULL && v.appStoreId.length > 0)
                [idList addObject:v.appStoreId];
        }
    }
   // for (int productIndex =0; productIndex < products.count; productIndex++) {
   //     Product *p = [products objectAtIndex:productIndex];
   //     for (int videoIndex =0; videoIndex < p.videos.count; videoIndex++) {
   //         Video *v = [p.videos objectAtIndex:videoIndex];
   //         if( v.appStoreId != NULL && v.appStoreId.length > 0)
   //             [idList addObject:v.appStoreId];
   //     }
   // }
    // NSLog(@"Dumping %d appids from catalog product list", products.count);
//    for( NSString *s in idList)
        // NSLog(@"appStoreId: %@", s );
    return idList;
}

- (BOOL)parseCatalog:(NSData *)catalogData
{
    // initialize a new empty catalog
    [products removeAllObjects];

    
    if( catalogData == NULL ) {
        // no catalog data supplied so simply exit with an empty catalog
       
        return TRUE;
    }
    
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:catalogData //1
                          
                          options:kNilOptions
                          error:&error];
    if( error ) {
        return FALSE;
    }

    // scan json and deserialize to products and videos
    NSArray* jsonProducts = [json objectForKey:@"products"];
    for( NSDictionary *jsonProduct in jsonProducts) {
        Product *product = [[Product alloc] init];
        product.title = (NSString *)[jsonProduct objectForKey:@"title"];
        product.description = (NSString *)[jsonProduct objectForKey:@"description"];
        product.thumbnailImageUrls = [jsonProduct objectForKey:@"thumbnailImageUrls"];
        product.previewImageUrls = [jsonProduct objectForKey:@"previewImageUrls"];
        product.previewVideoUrls = [jsonProduct objectForKey:@"previewVideoUrls"];
        product.videos = [[NSMutableArray alloc] init];
        NSArray * jsonVideos = [jsonProduct objectForKey:@"videos"];
        for( NSDictionary *jsonVideo in jsonVideos ) {
            Video *video = [[Video alloc] init];
            video.title = (NSString *)[jsonVideo objectForKey:@"title"];
            video.description = (NSString *)[jsonVideo objectForKey:@"description"];
            
            NSString *appId = (NSString *)[jsonVideo objectForKey:@"appStoreId"];
            NSString *trimmedAppId = [appId stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceCharacterSet]];
            video.appStoreId = trimmedAppId;
            
            video.thumbnailImageUrls = [jsonVideo objectForKey:@"thumbnailImageUrls"];
            video.previewImageUrls = [jsonVideo objectForKey:@"previewImageUrls"];
            video.videoUrl = [jsonVideo objectForKey:@"videoUrl"];
            video.purchasable = NO;
            video.price = 0;
            [product.videos addObject:video];
        
        }
        [products addObject:product];
      
    };
    
   
    #ifdef DEBUG
    
  //  [self dump];
    
    #endif
    
    return TRUE;
}

- (BOOL)parseSettings:(NSData *)responseData
{
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    if( !json ) {
        return FALSE;
    }
    
    NSDictionary* jsonSettings = [json objectForKey:@"settings"];
    App.instance.welcomeImageUrls = [jsonSettings objectForKey:@"welcomeImageUrls"];
    App.instance.welcomeVideoUrls = [jsonSettings objectForKey:@"welcomeVideoUrls"];
   
    App.instance.debugMode = [[jsonSettings objectForKey:@"debugMode"] boolValue];
    
    return TRUE;
    // NSLog(@"settings: %@", jsonSettings);
}

-(void)dump
{
     NSLog(@"=======================");
     NSLog(@"=== Dumping Catalog ===");
     NSLog(@"=======================");
     NSLog(@" Catalog URL : %@", App.instance.catalogUrl);
     NSLog(@" WelcomImageUrls: [");
        for( NSString *s in App.instance.welcomeImageUrls) {
            NSLog(@"        : %@", s);
        }
    NSLog(@"        ]");
    
    for( Product *p in products){
         NSLog(@" ");
         NSLog(@"Product");
         NSLog(@"     Title: %@", p.title);
         NSLog(@"     Description: %@", p.description);
         NSLog(@"     thumbnailImageUrls: [");
        for( NSString *s in p.thumbnailImageUrls) {
            NSLog(@"        : %@", s);
        }
        
        NSLog(@" ");
        NSLog(@"     ------------------------ ");
        NSLog(@"     Videos: %lu", (unsigned long)p.videos.count);
        for (Video *v in p.videos ) {
        
            NSLog(@"          Title: %@", v.title);
            NSLog(@"          Description: %@", v.description);
            NSLog(@"          AppStoreId: %@", v.appStoreId);
            NSLog(@"          Price: %@", v.priceAsString);
            NSLog(@"          AppStoreId: %@", v.appStoreId);
            NSLog(@"          Purchasable: %i", v.purchasable);
            NSLog(@"          Price: %@", v.price);
        
            NSLog(@"          thumbnailImageUrls: [");
            for( NSString *s in v.thumbnailImageUrls) {
                NSLog(@"        : %@", s);
            }
            NSLog(@"        ]");
        }
        NSLog(@" ");
        NSLog(@" ");
    }
}
@end
