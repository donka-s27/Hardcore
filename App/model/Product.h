//
//  Product.h
//  hardcore
//
//  Created by Garth S. Tissington on 7/7/13.
//  Copyright (c) 2013 Kira Elste. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject {
}

@property (nonatomic, retain) NSMutableArray * videos;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * description;
@property (nonatomic, retain) NSArray *  thumbnailImageUrls;
@property (nonatomic, retain) NSArray *  previewImageUrls;
@property (nonatomic, retain) NSArray *  previewVideoUrls;



@end
