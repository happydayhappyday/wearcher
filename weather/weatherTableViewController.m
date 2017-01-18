//
//  weatherTableViewController.m
//  weather
//
//  Created by csy on 17/1/9.
//  Copyright © 2017年 csy. All rights reserved.
//

#import "weatherTableViewController.h"
#import "suggestTableViewCell.h"
#import "forecastTableViewCell.h"
#import "weatherTableViewCell.h"
#import "weatherTodayTableViewCell.h"
#import "weatherHourTableViewCell.h"
#define XK_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define XK_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface weatherTableViewController (){
    weatherTableViewCell *weathercell;
    forecastTableViewCell *forecastcall; //天气预报
    suggestTableViewCell *suggestcell; //生活指数
    weatherTodayTableViewCell *todaycell; //今日天气
    weatherHourTableViewCell *hourcell;//小时预报
    
    NSDictionary *content;      //天气数据
    NSMutableArray *date;
    NSMutableDictionary *today;
    
    NSArray *cond;
    NSArray *condcode;
    NSArray *low;
    NSArray *high;
    NSArray *sc;
    NSString *nowTop;
    NSString *nowcond;
    NSArray *suggestTitle;
    NSArray *suggestText;
    NSArray *title;
    NSArray *weekday;
    NSMutableDictionary *hourArray;
    NSMutableArray *hourtmp;
    NSMutableArray *hourtime;
    long sumday;
    int week;
}@end

@implementation weatherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    //widget数据
//    NSString *groupID = @"group.com.2016.widgetweather";
//    NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:groupID];
//    [shared setObject:@"1000" forKey:@"number"];
//    [shared synchronize];
//    
    
    NSString *groupID1 = @"group.com.2016.widgetweather";
    NSUserDefaults *sharedd = [[NSUserDefaults alloc]initWithSuiteName:groupID1];
    NSString *string = [NSString stringWithFormat:@"%@",[sharedd objectForKey:@"number"]];
    NSLog(@"%@",string);
    
     NSString *httpUrl = @"https://free-api.heweather.com/v5/weather?city=CN101270401&key=0b405fc4725643e3a1a91a89738ad4fb";
     [self request:httpUrl];
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    self.navigationItem.title = @"";
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.mytableview.separatorStyle = NO;
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"weather"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:fullPath]){
        NSData *weather = [NSData dataWithContentsOfFile:fullPath];
        content = [NSJSONSerialization JSONObjectWithData:weather options:NSJSONReadingMutableContainers error:nil];//转换数据格式
        NSLog(@"%@",content);
    }

    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    sumday = time /(60*60*24);
    week =(int)sumday %7;
    weekday = [NSArray arrayWithObjects:@"星期四",@"星期五",@"星期六",@"星期日",@"星期一",@"星期二",@"星期三",nil];
    title = [NSArray arrayWithObjects:@"穿衣指数",@"感冒指数",@"运动指数",@"舒适度",@"旅游指数",@"紫外线指数",nil];
    [self ready];
}
-(void)request:(NSString *)httpUrl{
    NSURL *url = [NSURL URLWithString:httpUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
   NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"%@",data);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"weather"]];
    NSFileManager *fielManager = [NSFileManager defaultManager];
    if([fielManager fileExistsAtPath:fullPath]){
        [fielManager removeItemAtPath:fullPath error:nil];
    }
    [data writeToFile:fullPath atomically:YES];
    NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//转换数据格式
    NSLog(@"%@",content);
//     [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        if(connectionError){
//            NSLog(@"出错");
//        }else{
//            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//            
//            NSLog(@"responseCode == %ld",responseCode);
//            //存储json
//            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"weather"]];
//            NSFileManager *fielManager = [NSFileManager defaultManager];
//            if([fielManager fileExistsAtPath:fullPath]){
//                [fielManager removeItemAtPath:fullPath error:nil];
//            }
//            [data writeToFile:fullPath atomically:YES];
//            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//转换数据格式
//            
//                }
//    }];
}


-(void)ready{
    NSDictionary *jsondata = [[content objectForKey:@"HeWeather5"]lastObject];
    today = [[NSMutableDictionary alloc]init];
    NSLog(@"%@",jsondata);
    
    //第二层
    NSDictionary *now = [jsondata objectForKey:@"now"];
    //当前风力数据
    NSDictionary *wind = [now objectForKey:@"wind"];
    //当前天气数据
    NSDictionary *conddic = [now objectForKey:@"cond"];
    //保存widget数据
    NSString *groupID = @"group.com.2016.widgetweather";
    NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:groupID];
    [shared setObject:[now objectForKey:@"tmp"] forKey:@"tmp"];
    [shared setObject:[now objectForKey:@"hum"] forKey:@"hum"];
    [shared setObject:[wind objectForKey:@"dir"] forKey:@"dir"];
    [shared setObject:[wind objectForKey:@"sc"] forKey:@"sc"];
    [shared setObject:[conddic objectForKey:@"txt"] forKey:@"txt"];
    [shared setObject:[conddic objectForKey:@"code"] forKey:@"code"];
    [shared synchronize];
    NSLog(@"%@",now);
    NSDictionary *jsondata1 = [[jsondata objectForKey:@"daily_forecast"]objectAtIndex:0];
    NSDictionary *jsondata2 = [[jsondata objectForKey:@"daily_forecast"]objectAtIndex:1];
    NSDictionary *jsondata3 = [[jsondata objectForKey:@"daily_forecast"]objectAtIndex:2];
    hourArray = [[NSMutableDictionary alloc]init];
    for (int i = 0; i< [[jsondata objectForKey:@"hourly_forecast"]count]; i++) {
        NSDictionary *hour = [[jsondata objectForKey:@"hourly_forecast"]objectAtIndex:i];
        [hourArray setObject:hour forKey:[NSString stringWithFormat:@"%d", i]];
    }
    NSDictionary *suggestion = [jsondata objectForKey:@"suggestion"];
    
    //解析风力
    NSDictionary *sc1 = [jsondata1 objectForKey:@"wind"];
    NSDictionary *sc2 = [jsondata2 objectForKey:@"wind"];
    NSDictionary *sc3 = [jsondata3 objectForKey:@"wind"];

    //解析温度
    nowTop = [now objectForKey:@"tmp"];
    NSDictionary *tem1 = [jsondata1 objectForKey:@"tmp"];
    NSDictionary *tem2 = [jsondata2 objectForKey:@"tmp"];
    NSDictionary *tem3 = [jsondata3 objectForKey:@"tmp"];

   
    //解析天气
    NSDictionary *cond0 = [now objectForKey:@"cond"];
    nowcond = [cond0 objectForKey:@"txt"];
    nowcond =[nowcond stringByAppendingString:@"  "];
    
    NSDictionary *cond1 = [jsondata1 objectForKey:@"cond"];
    NSDictionary *cond2 = [jsondata2 objectForKey:@"cond"];
    NSDictionary *cond3 = [jsondata3 objectForKey:@"cond"];

    //解析建议
    NSDictionary *drsg = [suggestion objectForKey:@"drsg"];
    NSDictionary *uv = [suggestion objectForKey:@"uv"];
    NSDictionary *trav = [suggestion objectForKey:@"trav"];
    NSDictionary *sport = [suggestion objectForKey:@"sport"];
    NSDictionary *comf = [suggestion objectForKey:@"comf"];
    NSDictionary *flu = [suggestion objectForKey:@"flu"];
    
    
    date = [[NSMutableArray alloc]init];
    for(int i = 0;i < 7; i++){
        if(week > 6){
            week = 0;
 
        }
        [date addObject:[weekday objectAtIndex:week]];
        week++;
    }
    NSDictionary *temp = [jsondata1 objectForKey:@"astro"];
    NSString *tempstring =@"";
    [today setObject:[temp objectForKey:@"ss"] forKey:@"ss"];//日落
    [today setObject:[temp objectForKey:@"sr"] forKey:@"sr"];//日出
    tempstring = [jsondata1 objectForKey:@"pres"];
    tempstring = [tempstring stringByAppendingString:@"百帕"];
    
    [today setObject:tempstring forKey:@"pres"];//气压
    temp = [jsondata1 objectForKey:@"wind"];
    tempstring = [temp objectForKey:@"dir"];
    tempstring = [tempstring stringByAppendingString:@" "];
    tempstring = [tempstring stringByAppendingString:[temp objectForKey:@"spd"]];
    tempstring = [tempstring stringByAppendingString:@"Kmph"];
    [today setObject:tempstring forKey:@"spd"];//风速
    
    tempstring = [now objectForKey:@"fl"];
    tempstring = [tempstring stringByAppendingString:@"°"];
    [today setObject:tempstring forKey:@"fl"];//体感温度
    
    tempstring = [jsondata1 objectForKey:@"hum"];
    tempstring = [tempstring stringByAppendingString:@"%"];
    [today setObject:tempstring forKey:@"hum"];//湿度
    
    tempstring = [jsondata1 objectForKey:@"vis"];
    tempstring = [tempstring stringByAppendingString:@"千米"];
    [today setObject:tempstring forKey:@"vis"];//能见度
    
    tempstring = [jsondata1 objectForKey:@"pcpn"];
    tempstring = [tempstring stringByAppendingString:@"毫米"];
    [today setObject:tempstring forKey:@"pcpn"];//降雨量
    
    tempstring = [jsondata1 objectForKey:@"pop"];
    tempstring = [tempstring stringByAppendingString:@"%"];
    [today setObject:tempstring forKey:@"pop"];//降雨概率
    temp = [[jsondata objectForKey:@"aqi"]objectForKey:@"city"];
    [today setObject:[temp objectForKey:@"aqi"] forKey:@"aqi"];//空气质量指数
    [today setObject:[temp objectForKey:@"qlty"] forKey:@"qlty"];//空气质量类别
    [today setObject:[uv objectForKey:@"brf"] forKey:@"brf"];//紫外线指数
    //每个小时的温度
    hourtmp = [[NSMutableArray alloc]init];
    hourtime = [[NSMutableArray alloc]init];
    NSLog(@"%@",hourArray);
    for(int i= 0;i<  [hourArray count];i++){
        NSDictionary *dict = [hourArray objectForKey:[NSString stringWithFormat:@"%d", i]];
        [hourtmp addObject:[dict objectForKey:@"tmp"]];
        [hourtime addObject:[dict objectForKey:@"date"]];
    }
    sc = [NSArray arrayWithObjects:[sc1 objectForKey:@"sc"],[sc2 objectForKey:@"sc"],[sc3 objectForKey:@"sc"],nil];
    
    low = [NSArray arrayWithObjects:[tem1 objectForKey:@"min"],[tem2 objectForKey:@"min"],[tem3 objectForKey:@"min"],nil];
    
    high = [NSArray arrayWithObjects:[tem1 objectForKey:@"max"],[tem2 objectForKey:@"max"],[tem3 objectForKey:@"max"],nil];
    
    cond = [NSArray arrayWithObjects:[cond1 objectForKey:@"txt_d"],[cond2 objectForKey:@"txt_d"],[cond3 objectForKey:@"txt_d"],nil];
    
    condcode = [NSArray arrayWithObjects:[cond1 objectForKey:@"code_d"],[cond2 objectForKey:@"code_d"],[cond3 objectForKey:@"code_d"],nil];
    
    suggestTitle = [NSArray arrayWithObjects:[drsg objectForKey:@"brf"],[flu objectForKey:@"brf"],[sport objectForKey:@"brf"],[comf objectForKey:@"brf"],[trav objectForKey:@"brf"],[uv objectForKey:@"brf"], nil];
    
    suggestText = [NSArray arrayWithObjects:[drsg objectForKey:@"txt"],[flu objectForKey:@"txt"],[sport objectForKey:@"txt"],[comf objectForKey:@"txt"],[trav objectForKey:@"txt"],[uv objectForKey:@"txt"], nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return XK_SCREEN_HEIGHT/12*5;
    }else if (indexPath.row >4 && indexPath.row<11){
        return (XK_SCREEN_HEIGHT-64)/6;
    }else if (indexPath.row<=3 && indexPath.row != 0){
        return (XK_SCREEN_HEIGHT - XK_SCREEN_HEIGHT/12*5)/7;
    }else if (indexPath.row == 4){
        return 64;
    }
    else
        return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.row <=3 && indexPath.row != 0) ) {
        if (forecastcall == nil) {
            forecastcall = [tableView dequeueReusableCellWithIdentifier:@"foreacasecell"];
        }
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"forecastTableViewCell" owner:nil options:nil];
        forecastcall = [nib objectAtIndex:0];
        //foreacstcell.cond.text = [cond objectAtIndex:indexPath.row-1];
        forecastcall.low.text = [[low objectAtIndex:indexPath.row-1]stringByAppendingString:@"°"];
        forecastcall.high.text = [[high objectAtIndex:indexPath.row-1]stringByAppendingString:@"°"];
        //foreacstcell.sc.text = [sc objectAtIndex:indexPath.row-1];
        forecastcall.date.text = [date objectAtIndex:indexPath.row-1];
        NSString *tmp = [condcode objectAtIndex:indexPath.row-1];
        forecastcall.image.image = [UIImage imageNamed:tmp];
        forecastcall.spe.hidden = YES;
        if(indexPath.row != 1){
            forecastcall.today.hidden = YES;
        }
        if (indexPath.row == 7) {
            forecastcall.spe.hidden = NO;
            forecastcall.spe.alpha = 0.3;
        }
        forecastcall.backgroundColor = [UIColor clearColor];
        // foreacstcell.alpha = 1;
        forecastcall.selectionStyle = UITableViewCellSelectionStyleNone;
        return forecastcall;
    }else if(indexPath.row > 4 && indexPath.row < 11){
        
        if(suggestcell == nil){
            suggestcell = [tableView dequeueReusableCellWithIdentifier:@"suggestcell"];
        }
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"suggestTableViewCell" owner:nil options:nil];
        suggestcell = [nib objectAtIndex:0];
        suggestcell.spe.alpha = 0.3;
        suggestcell.sugTitle.text = [suggestTitle objectAtIndex:indexPath.row - 5];
        suggestcell.sugText.text = [suggestText objectAtIndex:indexPath.row - 5];
        suggestcell.title.text = [title objectAtIndex:indexPath.row - 5];
        suggestcell.selectionStyle = UITableViewCellSelectionStyleNone;
        suggestcell.backgroundColor = [UIColor clearColor];
        
        if (indexPath.row == 10) {
            suggestcell.spe.hidden = NO;
        }else{
            suggestcell.spe.hidden = YES;
        }
        
        return  suggestcell;
    }else if(indexPath.row == 0){
        
        if (weathercell == nil) {
            weathercell = [tableView dequeueReusableCellWithIdentifier:@"weatherVC"];
        }
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"weatherTableViewCell" owner:nil options:nil];
        weathercell = [nib objectAtIndex:0];
        weathercell.tem.text = nowTop;
        weathercell.weather.text = nowcond;
        weathercell.backgroundColor = [UIColor clearColor];
        // weathercell.alpha = 1;
        weathercell.selectionStyle = UITableViewCellSelectionStyleNone;
        return weathercell;
    }else if (indexPath.row == 4){
        if(hourcell == nil){
            hourcell = [tableView dequeueReusableCellWithIdentifier:@"hourcell"];
        }
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"weatherHourTableViewCell" owner:nil options:nil];
          hourcell = [nib objectAtIndex:0];
        NSString *timee = [[NSString alloc]init];
        NSString *timeee = [[NSString alloc]init];
        NSString *tmp =[[NSString alloc]init];
        for(int i=0;i<[hourtime count];i++){
            timeee = [[hourtime objectAtIndex:i]substringFromIndex:10];
            timee = [[timee stringByAppendingString:timeee]stringByAppendingString:@"      "];
            hourcell.hour1time.text = timee;
            
            tmp = [[[tmp stringByAppendingString:[hourtmp objectAtIndex:i]]stringByAppendingString:@"°"]stringByAppendingString:@"              "];
            hourcell.hour1tmp.text = tmp;
        }
        return hourcell;
        
    }
    else{
        
        if (todaycell == nil) {
            todaycell = [tableView dequeueReusableCellWithIdentifier:@"TodayweatherVC"];
        }
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"weatherTodayTableViewCell" owner:nil options:nil];
        todaycell = [nib objectAtIndex:0];
        if (indexPath.row == 11) {
            todaycell.l1key.text = @"日出：";
            todaycell.l2key.text = @"日落：";
            todaycell.l1value.text = [today objectForKey:@"sr"];
            todaycell.l2value.text = [today objectForKey:@"ss"];
        }else if (indexPath.row == 12) {
            todaycell.l1key.text = @"降雨概率：";
            todaycell.l2key.text = @"湿度：";
            todaycell.l1value.text = [today objectForKey:@"pop"];
            todaycell.l2value.text = [today objectForKey:@"hum"];
        }else if (indexPath.row == 13) {
            todaycell.l1key.text = @"风速：";
            todaycell.l2key.text = @"体感温度：";
            todaycell.l1value.text = [today objectForKey:@"spd"];
            todaycell.l2value.text = [today objectForKey:@"fl"];
        }else if (indexPath.row == 14) {
            todaycell.l1key.text = @"降水量：";
            todaycell.l2key.text = @"气压：";
            todaycell.l1value.text = [today objectForKey:@"pcpn"];
            todaycell.l2value.text = [today objectForKey:@"pres"];
        }else if (indexPath.row == 15) {
            todaycell.l1key.text = @"能见度：";
            todaycell.l2key.text = @"紫外线指数：";
            todaycell.l1value.text = [today objectForKey:@"vis"];
            todaycell.l2value.text = [today objectForKey:@"brf"];
        }else if (indexPath.row == 16) {
            todaycell.l1key.text = @"空气质量指数：";
            todaycell.l2key.text = @"空气质量：";
            todaycell.l1value.text = [today objectForKey:@"aqi"];
            todaycell.l2value.text = [today objectForKey:@"qlty"];
        }
        todaycell.selectionStyle = UITableViewCellSelectionStyleNone;
        todaycell.backgroundColor = [UIColor clearColor];
        return todaycell;
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 17;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
