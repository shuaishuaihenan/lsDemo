//
//  NACircleView.h
//  CircleDemo
//
//  Created by shuai on 2019/1/11.
//  Copyright © 2019 YX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NACircleView : UIView

- (void) setUnSpeededStatue;

- (void) startAcceWithSpeed:(NSInteger)speed andLast:(NSInteger)second;


@end

NS_ASSUME_NONNULL_END
