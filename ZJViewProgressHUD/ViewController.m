//
//  ViewController.m
//  ZJViewProgressHUD
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 zhangjian. All rights reserved.
//

#import "ViewController.h"
#import "ZJProgressHUD.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 120, 80)];
    [self.view addSubview:btn];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    
    btn.backgroundColor = [UIColor redColor];
    
    [btn addTarget:self action:@selector(tapBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)tapBtn{
    
    ZJProgressHUD *hud = [[ZJProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        NSLog(@"++++++++++");
    } completionBlock:^{
        NSLog(@"000000000000000000++++++++++");
        self.view.backgroundColor = [UIColor greenColor];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
