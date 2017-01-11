//
//  WXViewController.m
//  weather
//
//  Created by csy on 17/1/9.
//  Copyright © 2017年 csy. All rights reserved.
//

#import "WXViewController.h"
#import "weatherTableViewController.h"
#define XK_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define XK_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface WXViewController (){
    NSString *tem;//体感温度
    NSString *weather;//天气
    NSString *hum;//湿度
    NSString *dir;//风向
    NSString *sc;//风力大小
    NSString *WeatherCode;//天气代码
    UIView *WeatherView;
    
}

@end

@implementation WXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WeatherView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 15+self.view.bounds.size.height/4 -64)];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,15+self.view.bounds.size.height/4, XK_SCREEN_WIDTH, 1)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:line];
    
    
    
    WeatherView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:WeatherView];
    NSString *httpUrl = @"https://free-api.heweather.com/v5/weather?city=CN101270401&key=cb30db2c8c294d1995245e1a4c2914a0";
//    //7-10天气预报
//    NSString *httpUrlfore = @"https://free-api.heweather.com/v5/forecast?city=CN101270401&key=cb30db2c8c294d1995245e1a4c2914a0";
//    //每小时的预报
//    NSString *httpUrlHourly = @"https://free-api.heweather.com/v5/hourly?city=CN101270401&key=cb30db2c8c294d1995245e1a4c2914a0";
//    //生活指数
//    NSString *httpUrlsugg = @"https://free-api.heweather.com/v5/suggestion?city=CN101270401&key=cb30db2c8c294d1995245e1a4c2914a0";
//    //灾害预警
//    NSString *httpUrlalarm = @"https://free-api.heweather.com/v5/alarm?city=CN101270401&key=cb30db2c8c294d1995245e1a4c2914a0";
//    //天气预报
//    NSString *httpUrlwea = @"https://free-api.heweather.com/v5/weather?city=CN101270401&key=cb30db2c8c294d1995245e1a4c2914a0";
// //https://free-api.heweather.com/x3/weather?cityid=CN101270401&key=10c06d08ef0a4a95af46125391498031
//    [self request:httpUrlwea];
//    [self request:httpUrlalarm];
//    [self request:httpUrlwea];
//    [self request:httpUrlfore];
      [self request:httpUrl];
//    [self request:httpUrlsugg];
  //  [self request:httpUrlHourly];
    
}
-(void)request:(NSString *)httpUrl{
    NSURL *url = [NSURL URLWithString:httpUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *  response, NSData * data, NSError *  error) {
        if(error){
            NSLog(@"出错");
        }else{
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            
            NSLog(@"responseCode == %ld",responseCode);
            //存储json
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"weather"]];
            NSFileManager *fielManager = [NSFileManager defaultManager];
            if([fielManager fileExistsAtPath:fullPath]){
                [fielManager removeItemAtPath:fullPath error:nil];
            }
            [data writeToFile:fullPath atomically:YES];
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//转换数据格式
            
         //   NSLog(@"RESPONSE　DATA: %@", content);//打印结果、
            NSDictionary *jsondata = [[content objectForKey:@"HeWeather5"]lastObject];
            NSLog(@"%@",jsondata);
            NSDictionary *jsondata2 = [jsondata objectForKey:@"now"];
           NSLog(@"%@",jsondata2);
            hum = [jsondata2 objectForKey:@"hum"];
            hum = [hum stringByAppendingString:@"%"];
            tem = [jsondata2 objectForKey:@"tmp"];
            tem = [tem stringByAppendingString:@"°"];
            
            NSDictionary *jsondata3 = [jsondata2 objectForKey:@"cond"];
            weather = [jsondata3 objectForKey:@"txt"];
            WeatherCode = [jsondata3 objectForKey:@"code"];
            
            NSDictionary *jsondata4 = [jsondata2 objectForKey:@"wind"];
            dir = [jsondata4 objectForKey:@"dir"];
            sc = [jsondata4 objectForKey:@"sc"];
            sc = [sc stringByAppendingString:@"级"];
            
            [self addWeatherData];
        }
    }];
}
-(void)addWeatherData{
    
    UILabel *temperatureLabel = [[UILabel alloc]init];
    temperatureLabel.frame = CGRectMake(12, 64+12,15+(15+XK_SCREEN_HEIGHT/4-64)/2 ,(15+XK_SCREEN_HEIGHT/4-64)/2);
    [temperatureLabel setBackgroundColor:[UIColor clearColor]];
    [temperatureLabel setText:tem];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.font = [UIFont systemFontOfSize:39];
    [self.view addSubview:temperatureLabel];
    
    UILabel *weatherLabel = [[UILabel alloc]init];
    weatherLabel.frame = CGRectMake(6+12+15+(15+XK_SCREEN_HEIGHT/4-64)/2, 64+12+(15+XK_SCREEN_HEIGHT/4-64)/4, (15+XK_SCREEN_HEIGHT/4-64)/2, (15+XK_SCREEN_HEIGHT/4-64)/4);
    [weatherLabel setBackgroundColor:[UIColor clearColor]];
    [weatherLabel setText:weather];
    weatherLabel.textColor = [UIColor whiteColor];
    //weatherLabel.textAlignment = UITextWritingDirectionLeftToRight;
    weatherLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:weatherLabel];
    
    UILabel *humNumLabel = [[UILabel alloc]init];
    humNumLabel.frame = CGRectMake(12, 64+12+(15+XK_SCREEN_HEIGHT/4-64)/2+10, (15+XK_SCREEN_HEIGHT/4-64)/3, (15+XK_SCREEN_HEIGHT/4-64)/6);
    [humNumLabel setBackgroundColor:[UIColor clearColor]];
    [humNumLabel setText:@"湿度"];
    humNumLabel.textColor = [UIColor whiteColor];
    humNumLabel.textAlignment = UITextAlignmentCenter;
    humNumLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:humNumLabel];
    
    UILabel *humValueLabel = [[UILabel alloc]init];
    humValueLabel.frame = CGRectMake(12+(15+XK_SCREEN_HEIGHT/4-64)/3+8, 64+12+(15+XK_SCREEN_HEIGHT/4-64)/2+10, (15+XK_SCREEN_HEIGHT/4-64)/3, (15+XK_SCREEN_HEIGHT/4-64)/6);
    [humValueLabel setBackgroundColor:[UIColor clearColor]];
    [humValueLabel setText:hum];
    humValueLabel.textColor = [UIColor whiteColor];
    humValueLabel.textAlignment = UITextAlignmentCenter;
    humValueLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:humValueLabel];
    
    UILabel *DirLabel = [[UILabel alloc]init];
    DirLabel.frame = CGRectMake(12+(15+XK_SCREEN_HEIGHT/4-64)/3+8+(15+XK_SCREEN_HEIGHT/4-64)/3+8, 64+12+(15+XK_SCREEN_HEIGHT/4-64)/2+10, (15+XK_SCREEN_HEIGHT/4-64)/3, (15+XK_SCREEN_HEIGHT/4-64)/6);
    [DirLabel setBackgroundColor:[UIColor clearColor]];
    [DirLabel setText:dir];
    DirLabel.textColor = [UIColor whiteColor];
    DirLabel.textAlignment = UITextAlignmentCenter;
    DirLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:DirLabel];
    
    UILabel *ScLabel = [[UILabel alloc]init];
    ScLabel.frame = CGRectMake(12+(15+XK_SCREEN_HEIGHT/4-64)/3+8+(15+XK_SCREEN_HEIGHT/4-64)/3+8+(15+XK_SCREEN_HEIGHT/4-64)/3+8, 64+12+(15+XK_SCREEN_HEIGHT/4-64)/2+10, (15+XK_SCREEN_HEIGHT/4-64)/3+15, (15+XK_SCREEN_HEIGHT/4-64)/6);
    [ScLabel setBackgroundColor:[UIColor clearColor]];
    [ScLabel setText:sc];
    ScLabel.textColor = [UIColor whiteColor];
    ScLabel.textAlignment = UITextAlignmentCenter;
    ScLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:ScLabel];
    
    UIImageView *weatherImage = [[UIImageView alloc]initWithFrame:CGRectMake(XK_SCREEN_WIDTH-12-(15+XK_SCREEN_HEIGHT/4-64)+24, 64+12, (15+XK_SCREEN_HEIGHT/4-64)-24, (15+XK_SCREEN_HEIGHT/4-64)-24)];
    weatherImage.image = [UIImage imageNamed:WeatherCode];
    [self.view addSubview:weatherImage];
    
    weatherImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toShowWeather)];
    [weatherImage addGestureRecognizer:gesture];
}

-(void)toShowWeather{
    NSLog(@"进入到另一个页面");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    weatherTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"weatherVC"];
    
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]init];
    backitem.title = @"";
    self.navigationItem.backBarButtonItem = backitem;
    
    vc.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
