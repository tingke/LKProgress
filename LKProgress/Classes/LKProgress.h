//
//  LKProgress.h
//  LKProgress
//
//  Created by dosn-001 on 2019/9/30.
//  Copyright © 2019 tinker. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LKProgressMode) {
    LKProgressModeLine,
    LKProgressModePie,
    LKProgressModeArc,
    LKProgressModeWave
};

@interface LKProgress : UIView

@property(nonatomic, assign) LKProgressMode progressMode;

@property(nonatomic, strong) UIColor *progressColor;  // 进度条颜色

@property(nonatomic, strong) UIColor *progressBackColor; // 背景颜色

@property(nonatomic, assign) CGFloat progressWidth;   // 进度条宽度

@property(nonatomic, assign) CGFloat progress;        // 进度

@property(nonatomic, assign) CGFloat startAngle;      // 开始角度，默认-M_PI_2

@property(nonatomic, assign) CGFloat radius;

@end

NS_ASSUME_NONNULL_END
