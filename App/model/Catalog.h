//
//  Catalog.h
//  hardcore
//
//  Created by Garth S. Tissington on 7/8/13.
//  Copyright (c) 2013 Kira Elste. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import <Foundation/Foundation.h>

typedef void(^CatalogLoadCompleteBlock)(void);
typedef void(^CatalogLoadErrorBlock)(NSError * error);


extern NSString *const kCatalogChangedNotification;


@class Catalog;

@interface Catalog  : NSObject
{
}

-(id)init;

@property NSMutableArray * products;
@property (nonatomic, weak) NSMutableArray * appStoreIdList;


-(void)beginAsyncCatalogUpdate;

-(void)dump;

-(BOOL)isValid;

@end
