//
//  App.h
//  p1
//
//  Created by Donka Stoyanov on 2013-07-13.
//  Copyright (c) 2013 Kira Elste. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Catalog.h"
@interface App : NSObject
{
}


@property (nonatomic) BOOL debugMode;
@property (nonatomic) Catalog * catalog;
@property (nonatomic) NSArray  * welcomeImageUrls;
@property (nonatomic) NSArray  * welcomeVideoUrls;
@property (nonatomic) NSURL * catalogUrl;

+(App *)instance;


//+(NSString *)nibNameForDeviceFromId:(NSString *)nibId;

+ (NSString *)priceAsString:(NSNumber *)price :(NSLocale *)priceLocale;

@end
