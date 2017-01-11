//
//  weatherTableViewController.h
//  weather
//
//  Created by csy on 17/1/9.
//  Copyright © 2017年 csy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface weatherTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mytableview;

@end
