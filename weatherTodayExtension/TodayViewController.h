//
//  TodayViewController.h
//  weatherTodayExtension
//
//  Created by csy on 17/1/11.
//  Copyright © 2017年 csy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *temLabel;
@property (weak, nonatomic) IBOutlet UILabel *humLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirection;
@property (weak, nonatomic) IBOutlet UILabel *windenergy;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
