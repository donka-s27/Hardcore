//
//  ProductCell.h
//  hardcore
//
//  Created by Donka Stoyanov on 2013-07-20.
//  Copyright (c) 2013 Donka Stoyanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productThumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end
