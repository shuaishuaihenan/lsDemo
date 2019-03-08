//
//  NASpeedOverLabelView.h
//  CircleDemo
//
//  Created by shuai on 2019/1/14.
//  Copyright © 2019 YX. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UICountingLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NASpeedOverLabelView : UIView

/**
 *  设定速度值
 */
@property (nonatomic,assign)NSUInteger speedValue;

/**
 网络名称
 */
@property (nonatomic,strong) UILabel *netNameLabel;

/**
 *  速度值
 */
@property (nonatomic, strong) UICountingLabel *speedLabel;

/**
 剩余时间
 */
@property (nonatomic,strong) UILabel *lastLabel;

/**
 剩余时间label
 */
@property (nonatomic,strong) UILabel *lasTimeLabel;

/**
 剩余时间值 second
 */
@property (nonatomic,assign) NSInteger lastTimeValue;


@end

NS_ASSUME_NONNULL_END
