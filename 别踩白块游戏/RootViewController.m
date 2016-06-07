//
//  RootViewController.m
//  别踩白块游戏
//
//  Created by I三生有幸I on 16/1/29.
//  Copyright (c) 2016年 盛辰. All rights reserved.
//

#import "RootViewController.h"
#import "MyView.h"
@interface RootViewController ()<UIAlertViewDelegate>
// 显示用时的label
@property(nonatomic, retain)UILabel *timeLabel;

// 记录点击的正确色块个数
@property(nonatomic, assign)NSInteger count;

// 记录秒数
@property(nonatomic, assign)NSInteger second;

@property(nonatomic, retain)NSTimer *timer;
@end

@implementation RootViewController
- (void)dealloc
{
    [_timeLabel release];
    [_timer release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 200, 30)];
    self.timeLabel.backgroundColor = [UIColor redColor];
    self.timeLabel.text = [NSString stringWithFormat:@"用时：%ld秒 个数：%ld", self.second, self.count];
    [self.view addSubview:_timeLabel];
    [_timeLabel release];
    
    // 开始游戏
    [self startGame];
    
}

- (void)timeAction
{
    self.second++;
    self.timeLabel.text = [NSString stringWithFormat:@"用时：%ld秒 个数：%ld", self.second, self.count];
}

#pragma mark --- 开始游戏的方法 ---
// 重新布局 重新添加色块
- (void)startGame
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];

    for (int i = 0; i < 6; i++)
    {
        MyView *view1 = [[MyView alloc] initWithFrame:CGRectMake(30, 60 + i *(100 + 1), 80, 100)];
        view1.backgroundColor = [UIColor whiteColor];
        view1.target = self;
        view1.action = @selector(viewClick:);
        view1.tag = 1000 + i;
        [self.view addSubview:view1];
        [view1 release];
        
        MyView *view2 = [[MyView alloc] initWithFrame:CGRectMake(111, 60 + i *(100 + 1), 80, 100)];
        view2.backgroundColor = [UIColor whiteColor];
        view2.target = self;
        view2.action = @selector(viewClick:);
        view2.tag = 2000 + i;
        [self.view addSubview:view2];
        [view2 release];
        
        MyView *view3 = [[MyView alloc] initWithFrame:CGRectMake(192, 60 + i *(100 + 1), 80, 100)];
        view3.backgroundColor = [UIColor whiteColor];
        view3.target = self;
        view3.action = @selector(viewClick:);
        view3.tag = 3000 + i;
        [self.view addSubview:view3];
        [view3 release];
        
        MyView *view4 = [[MyView alloc] initWithFrame:CGRectMake(273, 60 + i *(100 + 1), 80, 100)];
        view4.backgroundColor = [UIColor whiteColor];
        view4.target = self;
        view4.action = @selector(viewClick:);
        view4.tag = 4000 + i;
        [self.view addSubview:view4];
        [view4 release];
    }
    for (int i  = 0; i < 6; i++)
    {
        int j = arc4random() % (4 - 1 + 1) + 1;
        MyView *view = (MyView *)[self.view viewWithTag:j * 1000 + i];
        CGFloat red = arc4random() % (250 - 50 + 1) + 1;
        CGFloat green = arc4random() % (250 - 50 + 1) + 1;
        CGFloat blue = arc4random() % (250 - 50 + 1) + 1;
        view.backgroundColor = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
    }

}

- (void)viewClick:(MyView *)myview
{
    if (myview.backgroundColor != [UIColor whiteColor] && (myview.tag % 1000 == 5)) {
        // 遍历所有的view,将上一行的颜色赋给下一行
        for (int i = 6; i > 0; i--)
        {
            for (int j = 1; j < 5; j++)
            {
                MyView *view1 = (MyView *)[self.view viewWithTag:j * 1000 + i];
                NSLog(@"%d", j * 1000 + i);
                MyView *view2 = (MyView *)[self.view viewWithTag:j * 1000 + i - 1];
                NSLog(@"%d", j * 1000 + i - 1);
                view1.backgroundColor = view2.backgroundColor;
            }
        }
        // 创建最上一行颜色
        for (int i = 1; i < 5; i++)
        {
            MyView *newView = (MyView *)[self.view viewWithTag:i * 1000 + 0];
            newView.backgroundColor = [UIColor whiteColor];
        }
        int j = arc4random() % (4 - 1 + 1) + 1;
        MyView *newView1 = (MyView *)[self.view viewWithTag:j * 1000 + 0];
        CGFloat red = arc4random() % (250 - 50 + 1) + 1;
        CGFloat green = arc4random() % (250 - 50 + 1) + 1;
        CGFloat blue = arc4random() % (250 - 50 + 1) + 1;
        newView1.backgroundColor = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
        self.count++;
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"渣渣,才玩了%ld行", self.count];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手残吗?" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新开始", nil];
        [alertView show];
        [alertView release];
        
        // 定时器暂停
        [self.timer invalidate];
        // 定时器重新置成nil
        self.timer = nil;
        
        // 秒数 和 个数 重新变成0
        self.second = 0;
        self.count = 0;

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        // 先删除所有的视图 然后再重新添加
        for (UIView *view in self.view.subviews)
        {
            if ([view isKindOfClass:[MyView class]])
            {
                [view removeFromSuperview];
            }
        }
        self.timeLabel.text = [NSString stringWithFormat:@"用时：%ld秒 个数：%ld", self.second, self.count];
        // 重新开始游戏
        [self startGame];
    }
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
