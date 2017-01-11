//
//  suggestTableViewCell.h
//  weather
//
//  Created by csy on 17/1/9.
//  Copyright © 2017年 csy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface suggestTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *sugTitle;
@property (weak, nonatomic) IBOutlet UILabel *sugText;
@property (weak, nonatomic) IBOutlet UIImageView *spe;

@end
