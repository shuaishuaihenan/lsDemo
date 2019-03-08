//
//  NASpeedOverLabelView.m
//  CircleDemo
//
//  Created by shuai on 2019/1/14.
//  Copyright © 2019 YX. All rights reserved.
//

#import "NASpeedOverLabelView.h"




@interface NASpeedOverLabelView ()




@end

@implementation NASpeedOverLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.speedLabel];
        [self addSubview:self.netNameLabel];
        [self addSubview:self.lastLabel];
        [self addSubview:self.lasTimeLabel];
    }
    return self;
}

/**
 *  懒加载速度只是Label
 *
 *  @return 返回速度指示表
 */
-(UILabel *)speedLabel{
    if (!_speedLabel) {
        _speedLabel=[[UICountingLabel alloc]init];
        _speedLabel.frame=CGRectMake(self.frame.size.width/2 - 30, self.frame.size.height/2 - 30 - 20, 60, 60);
        _speedLabel.adjustsFontSizeToFitWidth=YES;
        _speedLabel.method=UILabelCountingMethodLinear;
        _speedLabel.format=@"%d";
        _speedLabel.font = [UIFont systemFontOfSize:60];
        _speedLabel.textColor=[UIColor whiteColor];
        _speedLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _speedLabel;
}

-(UILabel *)netNameLabel{
    if (!_netNameLabel) {
        _netNameLabel=[[UILabel alloc]init];
        
        _netNameLabel.frame=CGRectMake(0, _speedLabel.frame.origin.y - 20, self.frame.size.width, 9);
        _netNameLabel.font = [UIFont systemFontOfSize:9];
        _netNameLabel.textColor=[UIColor whiteColor];
        _netNameLabel.textAlignment=NSTextAlignmentCenter;
        _netNameLabel.text = @"中国电信";
    }
    return _netNameLabel;
}

-(UILabel *)lastLabel{
    if (!_lastLabel) {
        _lastLabel=[[UILabel alloc]init];
        
        _lastLabel.frame=CGRectMake(0, self.frame.size.height/2 + 20, self.frame.size.width, 13);
        _lastLabel.font = [UIFont systemFontOfSize:13];
        _lastLabel.textColor=[UIColor whiteColor];
        _lastLabel.textAlignment=NSTextAlignmentCenter;
        _lastLabel.text = @"剩余时间";
    }
    return _lastLabel;
} 
-(UILabel *)lasTimeLabel{
    if (!_lasTimeLabel) {
        _lasTimeLabel=[[UILabel alloc]init];
        
        _lasTimeLabel.frame=CGRectMake(0, _lastLabel.frame.origin.y + _lastLabel.frame.size.height + 10, self.frame.size.width, 20);
        _lasTimeLabel.font = [UIFont systemFontOfSize:20];
        _lasTimeLabel.textColor=[UIColor whiteColor];
        _lasTimeLabel.textAlignment=NSTextAlignmentCenter;
        _lasTimeLabel.text = @"00:00:00";
    }
    return _lasTimeLabel;
}






@end
