//
//  iSangatItemCell.h
//  isangat
//
//  Created by Ravneet Khalsa on 3/15/15.
//  Copyright (c) 2015 isangat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iSangatItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;


@end
