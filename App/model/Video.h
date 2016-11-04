//
//  Video.h
//  p1
//
//  Created by Garth S. Tissington on 7/14/13.
//  Copyright (c) 2013 Kira Elste. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * description;
@property (nonatomic, retain) NSString * appStoreId;
@property (nonatomic, retain) NSArray *  thumbnailImageUrls;
@property (nonatomic, retain) NSArray *  previewImageUrls;
@property (nonatomic, retain) NSArray *  previewVideoUrls;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * priceAsString;
@property (nonatomic, retain) NSLocale * priceLocale;
@property (nonatomic) BOOL purchasable;
@property (nonatomic, strong) NSString * videoUrl;

@end
