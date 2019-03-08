//
//  NAUnSpeedView.h
//  CircleDemo
//
//  Created by shuai on 2019/1/14.
//  Copyright © 2019 YX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NAUnSpeedView : UIView

@property (nonatomic,copy) void(^SpeedBtnClickedBlock)(void);

- (void)speedSuccess:(void(^)(void))complete;

- (void)resetRocket;


@end

NS_ASSUME_NONNULL_END
