//
//  NACircleView.m
//  CircleDemo
//
//  Created by shuai on 2019/1/11.
//  Copyright © 2019 YX. All rights reserved.
//

#import "NACircleView.h"
#import "LJInstrumentView.h"

@interface NACircleView ()
@property (strong,nonatomic)LJInstrumentView* checkMeter;
@end

@implementation NACircleView

-(LJInstrumentView *)checkMeter{
    if (!_checkMeter) {
        _checkMeter = [[LJInstrumentView  alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
        _checkMeter.backgroundColor=[UIColor clearColor];
        
    }
    return _checkMeter;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self circle2:0];
    }
    return self;
}

- (void)circle2:(NSInteger)speed
{
    [self addSubview:self.checkMeter];
    
    self.checkMeter.timeInterval = 0;
    //弧线
    [_checkMeter drawArcWithStartAngle:-M_PI*7/6 endAngle:M_PI/6 lineWidth:2.0f fillColor:[UIColor clearColor] strokeColor:[UIColor whiteColor]];
    // 计时器
    //最大值160
    _checkMeter.speedValue = speed;
    
//    [NSTimer scheduledTimerWithTimeInterval:_checkMeter.timeInterval target:_checkMeter selector:@selector(runSpeedProgress) userInfo:nil repeats:NO];
    
    //刻度
    [_checkMeter drawScaleWithDivide:40 andRemainder:10 strokeColor:[[UIColor whiteColor]colorWithAlphaComponent:0.52] filleColor:[UIColor clearColor]scaleLineNormalWidth:0 scaleLineBigWidth:20];
    // 增加刻度值
    [_checkMeter DrawScaleValueWithDivide:4];
    
    
    // 进度的曲线
    [_checkMeter drawProgressCicrleWithfillColor:[UIColor clearColor] strokeColor:[UIColor whiteColor]];
    
    [_checkMeter setColorGrad:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:2.0/255 green:186.0/255 blue:197.0/255 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:44.0/255 green:203.0/255 blue:112.0/255 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:254.0/255 green:136.0/255 blue:5.0/255 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:247.0/255 green:21.0/255 blue:47.0/255 alpha:1.0] CGColor],nil]];
    
    [_checkMeter addCircleView];
    
    
     __weak typeof(self)weakself = self;
    
    [_checkMeter setSpeedBtnClickedBlock:^{
      
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakself startAcceWithSpeed:(arc4random()%159 +1) andLast:1000];
        });
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_checkMeter resetProgress];
}

- (void)setUnSpeededStatue
{
    [_checkMeter resetProgress];
}

- (void)startAcceWithSpeed:(NSInteger)speed andLast:(NSInteger)second
{
    [self->_checkMeter setSpeedValue:speed];
    
    self->_checkMeter.lastTimeValue = second;
    
    [self->_checkMeter runSpeedProgress];
}

@end
