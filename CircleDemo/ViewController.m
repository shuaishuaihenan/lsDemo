//
//  ViewController.m
//  CircleDemo
//
//  Created by shuai on 2019/1/11.
//  Copyright © 2019 YX. All rights reserved.
//

#import "ViewController.h"
#import "NACircleView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setcolorview];
    NACircleView * view = [[NACircleView alloc]initWithFrame:CGRectMake(14, 157, self.view.frame.size.width - 28 , self.view.frame.size.width - 28)];  
    [self.view addSubview:view];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setcolorview
{
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = [UIScreen mainScreen].bounds;
    gl.startPoint = CGPointMake(0.5, 0.05);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:145/255.0 green:84/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:2/255.0 green:198/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:20/255.0 green:54/255.0 blue:160/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f), @(1.0f)];
    
    [self.view.layer addSublayer:gl];
}

@end
