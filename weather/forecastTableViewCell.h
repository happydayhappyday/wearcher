//
//  forecastTableViewCell.h
//  weather
//
//  Created by csy on 17/1/9.
//  Copyright © 2017年 csy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forecastTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *low;
@property (weak, nonatomic) IBOutlet UILabel *high;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *today;
@property (weak, nonatomic) IBOutlet UIImageView *spe;

@end
