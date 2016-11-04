//
//  VideoTableViewCell.h
//  p1
//
//  Created by Garth S. Tissington on 7/15/13.
//  Copyright (c) 2013 Kira Elste. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"
@interface VideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoThumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;

@end
