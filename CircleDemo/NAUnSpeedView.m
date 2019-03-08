//
//  NAUnSpeedView.m
//  CircleDemo
//
//  Created by shuai on 2019/1/14.
//  Copyright © 2019 YX. All rights reserved.
//

#import "NAUnSpeedView.h"

#define IPhone4s CGSizeEqualToSize(CGSizeMake(320, 480), [UIScreen mainScreen].bounds.size)
#define IPad CGSizeEqualToSize(CGSizeMake(768, 1024), [UIScreen mainScreen].bounds.size)
#define IPadMini CGSizeEqualToSize(CGSizeMake(768, 1024), [UIScreen mainScreen].bounds.size)
#define IPadPro CGSizeEqualToSize(CGSizeMake(1024, 1366), [UIScreen mainScreen].bounds.size)
#define IPhone5 CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size)
#define IPhone6 CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size)
#define IPhone6p CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size)
#define IPhoneX CGSizeEqualToSize(CGSizeMake(375, 812), [UIScreen mainScreen].bounds.size)
#define IPhoneXR CGSizeEqualToSize(CGSizeMake(414, 896), [UIScreen mainScreen].bounds.size)

#define ScaleHigh (IPhone5 ? 0.8515 : ((IPhone6 || IPhoneX) ? 1.0000 : ((IPhone6p || IPhoneXR) ? 1.1034 : ((IPad || IPadMini) ? 1.5352 : (IPadPro ? 2.0479 : (IPhone4s ? 0.7196 : 1.0000))))))


#define HEIGHT(H)    ScaleHigh * H
@interface NAUnSpeedView ()

/**
 火箭 未加速 加速中 显示 ，加速后 移除 并显示 倒计时和速度值 和网络名
 */
@property (nonatomic,strong) UIButton *RocketUnSpeedBtn;

@property (nonatomic,strong) UILabel *currentNetSpeedLabel;

@property (nonatomic,strong) UILabel *netNameLabel;

@end

@implementation NAUnSpeedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.RocketUnSpeedBtn];
        [self addSubview:self.currentNetSpeedLabel];
        [self addSubview:self.netNameLabel];
    }
    return self;
}

- (UIButton *)RocketUnSpeedBtn
{
    if (!_RocketUnSpeedBtn) {
        _RocketUnSpeedBtn = ({
            UIButton * button = [ UIButton buttonWithType:UIButtonTypeCustom];
            
            UIImage *picture = [UIImage imageNamed:@"newunspeedRoket"];
            CGFloat pHeight = HEIGHT(120);
            CGFloat pWidth = picture.size.width * pHeight / picture.size.height;
            button.frame = CGRectMake(self.frame.size.width/2 - pWidth/2 , 30, pWidth, pHeight);
            [button setBackgroundImage:picture forState:UIControlStateNormal];
            [button addTarget:self action:@selector(startAcceClicked) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _RocketUnSpeedBtn;
}

-(UILabel *)currentNetSpeedLabel{
    if (!_currentNetSpeedLabel) {
        _currentNetSpeedLabel=[[UILabel alloc]init];
        _currentNetSpeedLabel.frame=CGRectMake(0, _RocketUnSpeedBtn.frame.size.height + _RocketUnSpeedBtn.frame.origin.y + 8, self.frame.size.width, 11);
        
        _currentNetSpeedLabel.font = [UIFont systemFontOfSize:11];
        _currentNetSpeedLabel.textColor=[UIColor whiteColor];
        _currentNetSpeedLabel.textAlignment=NSTextAlignmentCenter;
        _currentNetSpeedLabel.text = @"当前网速 50M";
    }
    return _currentNetSpeedLabel;
}

-(UILabel *)netNameLabel{
    if (!_netNameLabel) {
        _netNameLabel=[[UILabel alloc]init];
        _netNameLabel.frame=CGRectMake(0, _currentNetSpeedLabel.frame.size.height + _currentNetSpeedLabel.frame.origin.y + 2, self.frame.size.width, 9);
        
        _netNameLabel.font = [UIFont systemFontOfSize:9];
        _netNameLabel.textColor=[UIColor whiteColor];
        _netNameLabel.textAlignment=NSTextAlignmentCenter;
        _netNameLabel.text = @"中国电信";
    }
    return _netNameLabel;
}

- (void)startAcceClicked
{
    if (self.SpeedBtnClickedBlock) {
        self.SpeedBtnClickedBlock();
    } 
}
- (void)speedSuccess:(void (^)(void))complete
{
    [UIView animateKeyframesWithDuration:3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        CGRect frame   ;
        frame.origin.x =  self.RocketUnSpeedBtn.frame.origin.x;
        frame.origin.y =  - 400;
        frame.size.width = self.RocketUnSpeedBtn.frame.size.width ;
        frame.size.height = self.RocketUnSpeedBtn.frame.size.height ;
        self.RocketUnSpeedBtn.frame = frame;
        
    } completion:^(BOOL finished) {
        self.RocketUnSpeedBtn .hidden = YES;
        UIImage *picture = [UIImage imageNamed:@"newunspeedRoket"];
        CGFloat pHeight = HEIGHT(120);
        CGFloat pWidth = picture.size.width * pHeight / picture.size.height;
        self.RocketUnSpeedBtn.frame = CGRectMake(self.frame.size.width/2 - pWidth/2 , 30, pWidth, pHeight);
        complete();
    }];
}

- (void)resetRocket
{
    self.RocketUnSpeedBtn.hidden = NO;
}





@end
