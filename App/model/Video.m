//
//  Video.m
//  p1
//
//  Created by Garth S. Tissington on 7/14/13.
//  Copyright (c) 2013 Kira Elste. All rights reserved.
//

#import "Video.h"
#import "App.h"

@implementation Video

@synthesize title;
@synthesize description;
@synthesize appStoreId;
@synthesize thumbnailImageUrls;
@synthesize previewImageUrls;
@synthesize previewVideoUrls;
@synthesize priceLocale;
@synthesize price;
@synthesize videoUrl;
@synthesize purchasable;

- (NSString *) priceAsString
{
    if( appStoreId.length == 0 )
        {
        return @"free";
    }

    if( !purchasable) {
        return @"";
    }

    if( price == NULL ){
        return @"";
    }

    if( [price floatValue]  < 0.01f )
    {
        return @"free";
    }
    

    return [App priceAsString:price :priceLocale];
    
  //  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  //  [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
  //  [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  //  [formatter setLocale:[self priceLocale]];
    
  //  NSString *str = [formatter stringFromNumber:[self price]];
//    [formatter release];
   // return str;
}

@end
