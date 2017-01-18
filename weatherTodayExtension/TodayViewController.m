 //
//  TodayViewController.m
//  weatherTodayExtension
//
//  Created by csy on 17/1/11.
//  Copyright © 2017年 csy. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self config];
}
- (void)viewWillAppear:(BOOL)animated{
  
    
    [self config];
}
-(void)config{
    NSString *groupID = @"group.com.2016.widgetweather";
    NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:groupID];
    NSString *string = [NSString stringWithFormat:@"%@",[shared objectForKey:@"number"]];
    NSLog(@"%@",string);
    self.detailLabel.text = string;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
