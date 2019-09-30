//
//  LKProgress.m
//  LKProgress
//
//  Created by dosn-001 on 2019/9/30.
//  Copyright © 2019 tinker. All rights reserved.
//

#import "LKProgress.h"

@interface LKProgress ()

@property(nonatomic, strong) CAShapeLayer *backgroundLayer;
@property(nonatomic, strong) CAShapeLayer *displayLayer;

@property(nonatomic, strong) UIBezierPath *bezierPath;

@end

@implementation LKProgress

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialize];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.displayLayer.fillColor = self.progressColor.CGColor;
    self.displayLayer.strokeColor = self.progressColor.CGColor;
    
    UIBezierPath *path = nil;
    switch (self.progressMode) {
        case LKProgressModeLine: {
            CGPoint startPoint = CGPointMake(0, (rect.size.height-self.progressWidth)*0.5);
            CGPoint endPoint = CGPointMake(rect.size.width * self.progress, (rect.size.height-self.progressWidth)*0.5);
            path = [UIBezierPath bezierPath];
            [path moveToPoint:startPoint];
            [path addLineToPoint:endPoint];
        }break;
        case LKProgressModePie:
        case LKProgressModeArc: {
            CGFloat startAngle = -M_PI_2;
            CGFloat endAngle = startAngle + self.progress * M_PI * 2;
            CGFloat radius = self.radius - (self.progressMode == LKProgressModePie?0:self.progressWidth);
            CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
            path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
            if (self.progressMode == LKProgressModePie) {
                [path addLineToPoint:center];
                self.displayLayer.strokeColor = [UIColor clearColor].CGColor;
            }else {
                self.displayLayer.fillColor = [UIColor clearColor].CGColor;
            }
        }break;
        case LKProgressModeWave: {
            
        }break;
        default:
            break;
    }

    self.displayLayer.lineWidth = self.progressWidth;
    self.displayLayer.lineJoin = kCALineJoinRound;
    self.displayLayer.lineCap = kCALineCapRound;
    self.displayLayer.path = path.CGPath;
}

- (void)didInitialize {
    self.layer.masksToBounds = YES;
    self.radius = MIN(self.frame.size.width, self.frame.size.height) * 0.5;
    self.progressColor = [UIColor redColor];
    self.displayLayer.frame = self.layer.bounds;
    [self.layer addSublayer:self.displayLayer];
}

///MARK: - ————— Setter —————

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    [self setNeedsDisplay];
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self setNeedsDisplay];
}

- (void)setProgressMode:(LKProgressMode)progressMode {
    _progressMode = progressMode;
    [self setNeedsDisplay];
}

///MARK: - ————— Getter —————

- (CAShapeLayer *)displayLayer {
    if (!_displayLayer) {
        _displayLayer = [CAShapeLayer layer];
    }
    return _displayLayer;
}

- (CAShapeLayer *)backgroundLayer {
    if (!_backgroundLayer) {
        _backgroundLayer = [CAShapeLayer layer];
    }
    return _backgroundLayer;
}

@end
