//
//  LJInstrumentView.m
//  节能宝
//
//  Created by 卢杰 on 16/8/16.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "LJInstrumentView.h"

#import "NAUnSpeedView.h"

#import "NASpeedOverLabelView.h"


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

#define Calculate_radius ((self.bounds.size.height>self.bounds.size.width)?(self.bounds.size.width*0.5-self.lineWidth - 20):(self.bounds.size.height*0.5-self.lineWidth) - 20)
#define LuCenter CGPointMake(self.center.x-self.frame.origin.x, self.center.y-self.frame.origin.y)

static NSInteger ANIMATIOND = 3.0f;

@interface LJInstrumentView ()
/**
 *  圆盘开始角度
 */
@property(nonatomic,assign)CGFloat startAngle;
/**
 *  圆盘结束角度
 */
@property(nonatomic,assign)CGFloat endAngle;
/**
 *  圆盘总共弧度弧度
 */
@property(nonatomic,assign)CGFloat arcAngle;
/**
 *  线宽
 */
@property(nonatomic,assign)CGFloat lineWidth;
/**
 *  刻度值长度
 */
@property(nonatomic,assign)CGFloat scaleValueRadiusWidth;
/**
 *  速度表半径
 */
@property(nonatomic,assign)CGFloat arcRadius;
/**
 *  刻度半径
 */
@property(nonatomic,assign)CGFloat scaleRadius;
/**
 *  刻度值半径
 */
@property(nonatomic,assign)CGFloat scaleValueRadius;


/**
 圆球半径
 */
@property (nonatomic,assign) CGFloat scaleCircleRadius;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

/**
 圆指示器开始位置为原点 未加速的时候为原点 ，加速的时候为 小火箭 公转
 */
@property (nonatomic,strong) UIImageView *circleImageView;

/**
 中间圆饼
 */
@property (nonatomic,strong) UIImageView *centerRocketImageView;

/**
 圆饼外面自转的外圈  加速中  加速后  开始自转
 */
@property (nonatomic,strong) UIImageView *bordRocketImageView;


/**
 火箭 未加速 加速中 显示 ，加速后 移除 并显示 倒计时和速度值 和网络名
 */
@property (nonatomic,strong) NAUnSpeedView *rocketViews;

@property (nonatomic,strong) NASpeedOverLabelView *speedOverViews;


@end
@implementation LJInstrumentView
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    
    
}
/**
 *  画弧度
 *
 *  @param startAngle  开始角度
 *  @param endAngle    结束角度
 *  @param lineWitdth  线宽
 *  @param filleColor  扇形填充颜色
 *  @param strokeColor 弧线颜色
 */
-(void)drawArcWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle lineWidth:(CGFloat)lineWitdth fillColor:(UIColor*)filleColor strokeColor:(UIColor*)strokeColor{
    //保存弧线宽度,开始角度，结束角度
    self.lineWidth = lineWitdth;
    self.startAngle = startAngle;
    self.endAngle = endAngle;
    self.arcAngle = endAngle - startAngle;
    self.arcRadius = Calculate_radius;
    self.scaleRadius = self.arcRadius - self.lineWidth - 35;
    self.scaleValueRadius = self.arcRadius - self.lineWidth - 20;
    
    self.scaleCircleRadius = self.arcRadius;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    UIBezierPath* outArc=[UIBezierPath bezierPathWithArcCenter:LuCenter radius:self.arcRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
    CAShapeLayer* shapeLayer=[CAShapeLayer layer];
    shapeLayer.lineWidth=lineWitdth;
    shapeLayer.fillColor=filleColor.CGColor;
    shapeLayer.strokeColor=strokeColor.CGColor;
    shapeLayer.path=outArc.CGPath;
    shapeLayer.lineCap=kCALineCapRound;
    [self.layer addSublayer:shapeLayer];
    
    
}
/**
 *  画刻度
 *
 *  @param divide      刻度几等分
 *  @param remainder   刻度数
 *  @param strokeColor 轮廓填充颜色
 *  @param fillColor   刻度颜色
 */
//center:中心店，即圆心
//startAngle：起始角度
//endAngle：结束角度
//clockwise：是否逆时针
-(void)drawScaleWithDivide:(int)divide andRemainder:(NSInteger)remainder strokeColor:(UIColor*)strokeColor filleColor:(UIColor*)fillColor scaleLineNormalWidth:(CGFloat)scaleLineNormalWidth scaleLineBigWidth:(CGFloat)scaleLineBigWidth{
    
    CGFloat perAngle=self.arcAngle/divide;
    //我们需要计算出每段弧线的起始角度和结束角度
    //这里我们从- M_PI 开始，我们需要理解与明白的是我们画的弧线与内侧弧线是同一个圆心
    for (NSInteger i = 0; i<= divide; i++) {
        
        CGFloat startAngel = (self.startAngle+ perAngle * i);
        CGFloat endAngel   = startAngel + perAngle/5;
        
        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:LuCenter radius:self.scaleRadius startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        
        if((remainder!=0)&&(i % remainder) == 0) {
            perLayer.strokeColor = strokeColor.CGColor;
            perLayer.lineWidth   = scaleLineBigWidth;
            if (i != 0 && i != divide) {
                perLayer.strokeColor = strokeColor.CGColor;;
                perLayer.lineWidth   = scaleLineBigWidth/2;
            }
        }else{
            perLayer.strokeColor = strokeColor.CGColor;;
            perLayer.lineWidth   = scaleLineNormalWidth;
        }
        perLayer.path = tickPath.CGPath;
        [self.layer addSublayer:perLayer];
        
    }
}
//biggerRocket

/**
 添加圆指示器
 */
- (void)addCircleView
{
    
    CGPoint point = [self calculateImagePositonWithArcCenter:LuCenter Angle:-self.startAngle];
    self.circleImageView = ({
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"litleCircle"]];
        image.frame = CGRectMake(point.x - 20, point.y - 20, 40, 40);
        image;
    });
    [self addSubview:self.circleImageView];//圆指示器开始位置为原点
    
    [self addSubview:self.centerRocketImageView];//中间圆饼
    
    [self addSubview:self.rocketViews];//火箭
    
    
}




//默认计算半径-10,计算label的坐标
- (CGPoint)calculateImagePositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel
{
    CGFloat x = (self.scaleCircleRadius)* cosf(angel);
    CGFloat y = (self.scaleCircleRadius)* sinf(angel);
    return CGPointMake(center.x + x, center.y - y);
}

/**
 *  画刻度值，逆时针设定label的值，将整个仪表切分为N份，每次递增仪表盘弧度的N分之1
 *
 *  @param divide 刻度值几等分
 */
-(void)DrawScaleValueWithDivide:(NSInteger)divide{
    CGFloat textAngel =self.arcAngle/divide;
    if (divide==0) {
        return;
    }
    for (NSUInteger i = 0; i <= divide; i++) {
        CGPoint point = [self calculateTextPositonWithArcCenter:LuCenter Angle:-(self.endAngle-textAngel*i)];
        NSString *tickText = [NSString stringWithFormat:@"%.0fMB",1.6 * ((divide - i)*100/divide)];
        //默认label的大小23 * 14
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(point.x -20 , point.y -10, 40, 14)];
        text.text = tickText;
        text.font = [UIFont systemFontOfSize:11.f];
        text.textColor = [UIColor whiteColor];
        text.textAlignment = NSTextAlignmentCenter;    
        text.alpha = 0.52;
        
        CGFloat startAngel = ((- 1* M_PI /3) - (i* M_PI /3) - M_PI);

        text.transform = CGAffineTransformMakeRotation( startAngel);
        
        [self addSubview:text];
    }
}


//默认计算半径-10,计算label的坐标
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel
{
    CGFloat x = (self.scaleValueRadius+3*self.lineWidth)* cosf(angel);
    CGFloat y = (self.scaleValueRadius+3*self.lineWidth)* sinf(angel);
    return CGPointMake(center.x + x, center.y - y);
}
/**
 *  进度条曲线
 *
 *  @param fillColor   填充颜色
 *  @param strokeColor 轮廓颜色
 */
- (void)drawProgressCicrleWithfillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor{
//    CGFloat endA =  0.01 *  _speedValue * self.arcAngle + self.startAngle ;
    UIBezierPath *progressPath  = [UIBezierPath bezierPathWithArcCenter:LuCenter radius:self.arcRadius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    self.progressLayer = progressLayer;
    progressLayer.lineWidth = self.lineWidth+0.25f;
    progressLayer.fillColor = fillColor.CGColor;
    progressLayer.strokeColor = strokeColor.CGColor;
    progressLayer.path = progressPath.CGPath;
    progressLayer.strokeStart = 0;
    progressLayer.strokeEnd = 0.0;
    progressLayer.lineCap=kCALineCapRound;
    [self.layer addSublayer:progressLayer];
}

- (void)setSpeedValue:(NSUInteger)speedValue
{
    _speedValue = speedValue/1.6;
}

#pragma mark 开始动画

- (void)runSpeedProgress{
    
    [self addSubview:self.bordRocketImageView];
    [self borderCircleImageViewLayer];
    [self.centerRocketImageView setImage:[UIImage imageNamed:@"centerNAhomeCircleSpeed"]];
    [self imageAnimation];
    __weak typeof(self)weakSelf = self;
    
    [weakSelf.rocketViews speedSuccess:^{
        
        [weakSelf.rocketViews removeFromSuperview];
        
        [weakSelf addSubview:self.speedOverViews];
        
        [weakSelf.speedOverViews.speedLabel countFrom:0 to:weakSelf.speedValue * 1.6 withDuration:ANIMATIOND];
        [weakSelf setPercent:weakSelf.speedValue * 0.01 animtion:YES];
    }];
    
    
}
- (void)setPercent:(CGFloat)value animtion:(BOOL)animation
{
    [CATransaction begin]; 
    [CATransaction setDisableActions:!animation];
    [CATransaction setValue:@(ANIMATIOND) forKey:kCATransactionAnimationDuration];
    [CATransaction setValue:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear] forKey:kCATransactionAnimationTimingFunction];
    
    self.progressLayer.strokeEnd = value;//进度条其实为定值
    [CATransaction commit];
    
}


#pragma mark 外圈自转

- (void)borderCircleImageViewLayer
{
    CABasicAnimation *animation1 =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation1.fromValue = [NSNumber numberWithFloat:0.f];
    animation1.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation1.duration  = ANIMATIOND;
    animation1.autoreverses = NO;
    animation1.fillMode =kCAFillModeForwards;
    animation1.repeatCount = 1000;
    [_bordRocketImageView.layer addAnimation:animation1 forKey:nil];
}



#pragma mark 图片 动画  公转
- (void)imageAnimation
{
    [_circleImageView setImage: [UIImage imageNamed:@"littleRocket"]];
    CGFloat endA =  0.01 *  _speedValue * self.arcAngle + self.startAngle ;
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathAddArc(path2, NULL, LuCenter.x, LuCenter.y, self.scaleCircleRadius ,   self.startAngle ,endA , 0);
    CAKeyframeAnimation * animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation2.path = path2;
    CGPathRelease(path2);
    animation2.duration = ANIMATIOND ;
    animation2.repeatCount = 0;
    animation2.autoreverses = NO;
    animation2.removedOnCompletion = NO;
    animation2.rotationMode =kCAAnimationRotateAuto;
    animation2.fillMode =kCAFillModeForwards;
    animation2.calculationMode = kCAMediaTimingFunctionLinear;
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_circleImageView.layer addAnimation:animation2 forKey:@"animation2"];
}

/**
 *  添加渐变图层
 *
 *  @param colorGradArray 颜色数组，如果想达到红-黄-红效果，数组应该是红，黄，红
 */
-(void)setColorGrad:(NSArray*)colorGradArray{
    //渐变图层
    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    //增加渐变图层，frame为当前layer的frame
    gradientLayer1.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [gradientLayer1 setColors:colorGradArray];
    [gradientLayer1 setStartPoint:CGPointMake(0, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(1, 1)];
    
    [gradientLayer addSublayer:gradientLayer1];
    
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
}

#pragma mark View
/**
 *  懒加载速度只是Label
 *
 *  @return 返回速度指示表
 */
-(UILabel *)speedLabel{
    if (!_speedLabel) {
        _speedLabel=[[UICountingLabel alloc]init];
        _speedLabel.frame=CGRectMake(0, 0, HEIGHT(60), HEIGHT(60));
        _speedLabel.adjustsFontSizeToFitWidth=YES;
        _speedLabel.method=UILabelCountingMethodLinear;
        _speedLabel.format=@"%d";
        _speedLabel.font = [UIFont systemFontOfSize:60];
        _speedLabel.textColor=[UIColor whiteColor];
        _speedLabel.textAlignment=NSTextAlignmentCenter;
        _speedLabel.center=LuCenter;
    }
    return _speedLabel;
}

- (UIImageView *)centerRocketImageView
{
    if (!_centerRocketImageView) {
        _centerRocketImageView = ({
            UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"centerNAhomeCircle"]];
            imageView.frame =CGRectMake(0, 0, Calculate_radius *8/5, Calculate_radius*8/5);
            imageView.center = LuCenter;
            
            imageView;
        });
    }
    return _centerRocketImageView;
}

- (UIImageView *)bordRocketImageView
{
    if (!_bordRocketImageView) {
        _bordRocketImageView = ({
            UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"centercenterCircle"]];
            imageView.frame =CGRectMake(0, 0, Calculate_radius*8/5, Calculate_radius*8/5);
            imageView.center = LuCenter;
            imageView;
        });
    }
    return _bordRocketImageView;
}

- (NAUnSpeedView *)rocketViews
{
    if (!_rocketViews) {
        _rocketViews = [[NAUnSpeedView alloc]initWithFrame:CGRectMake(0, 0, Calculate_radius *8/5, Calculate_radius*8/5)];
        _rocketViews.center = LuCenter;
        
        __weak typeof(self) weakself = self;
        _rocketViews.SpeedBtnClickedBlock = ^{
            
            if (weakself.SpeedBtnClickedBlock) {
                weakself.SpeedBtnClickedBlock();
            }
            
        };
    }
    return _rocketViews;
}

-(NASpeedOverLabelView *)speedOverViews
{
    if (!_speedOverViews) {
        _speedOverViews = [[NASpeedOverLabelView alloc]initWithFrame:CGRectMake(0, 0, Calculate_radius *8/5, Calculate_radius*8/5)];
        _speedOverViews.center = LuCenter;
    }
    return _speedOverViews;
}


#pragma mark 重置动画

- (void)resetProgress
{
    [self.centerRocketImageView setImage:[UIImage imageNamed:@"centerNAhomeCircle"]];
    [self addSubview:self.rocketViews];
    [self.rocketViews  resetRocket];
    self.speedValue = 0;
    [_bordRocketImageView.layer removeAllAnimations];
    [_bordRocketImageView removeFromSuperview];
    [_circleImageView setImage: [UIImage imageNamed:@"litleCircle"]];
    [self setPercent:0 animtion:NO];
    
    [self.speedOverViews removeFromSuperview];
    
    [self.progressLayer removeAllAnimations];
    [_circleImageView.layer removeAllAnimations];
}


- (void)appDidEnterBackground
{
    
}

- (void)appDidEnterPlayGround
{
    if (self.bordRocketImageView) {
        [self borderCircleImageViewLayer];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
