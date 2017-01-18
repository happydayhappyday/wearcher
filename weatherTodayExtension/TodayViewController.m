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
  
}
-(void)config{
    NSString *groupID = @"group.com.2016.widgetweather";
    NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:groupID];
    self.temLabel.text = [NSString stringWithFormat:@"%@°",[shared objectForKey:@"tmp"]];
    self.detailLabel.text = [NSString stringWithFormat:@"%@",[shared objectForKey:@"txt"]];
    self.windenergy.text = [NSString stringWithFormat:@"%@",[shared objectForKey:@"sc"]];
    self.windDirection.text = [NSString stringWithFormat:@"%@",[shared objectForKey:@"dir"]];
    self.humLabel.text = [NSString stringWithFormat:@"%@",[shared objectForKey:@"hum"]];
    self.image.image = [UIImage imageNamed:[shared objectForKey:@"code"]];
    
   // self.detailLabel.text = string;
}
- (void)openURLContainingAPP{
    //通过extensionContext借助host app调起app
    [self.extensionContext openURL:[NSURL URLWithString:@"DailyToolBox://"] completionHandler:^(BOOL success) {
        NSLog(@"open url result:%d",success);
    }];
}
- (IBAction)GoToHost:(UIButton *)sender {
    [self openURLContainingAPP];
    NSLog(@"进入到主应用");
    
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
