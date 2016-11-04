//
//  App.m
//  p1
//
//  Created by Donka Stoyanov on 2013-07-13.
//  Copyright (c) 2013 Kira Elste. All rights reserved.
//

#import "App.h"
#import "Catalog.h"

@implementation App

-(id)init {
    return self = [super init];
}

// catalog property getter
-(Catalog *)catalog{
    if( _catalog == nil)
    {
        static dispatch_once_t initCatalogOnce = 0;
        dispatch_once(&initCatalogOnce, ^{
            _catalog = [[Catalog alloc] init];
        });
    }
    return _catalog;
}

+ (App *)instance
{
    //  Static local predicate must be initialized to 0
    static App *instance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[App alloc] init];
        // Do any other initialisation stuff here
    });
    return instance;
}

//+(NSString *)nibNameForDeviceFromId:(NSString *)nibId
//{
//    // Override point for customization after application launch.
//    NSString * deviceSuffix = @"";
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        deviceSuffix = @"_iPhone";
//    } else {
//        deviceSuffix =  @"_iPad";
//    }
    
//    return [@[nibId, deviceSuffix] componentsJoinedByString:@""];
//}

+ (NSString *)priceAsString:(NSNumber *)price :(NSLocale *)priceLocale
{

  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
  [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  [formatter setLocale:priceLocale];

  NSString *str = [formatter stringFromNumber:price];
  return str;
}

@end
