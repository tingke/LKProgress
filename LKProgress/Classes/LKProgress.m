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

- (void)didInitialize {
    self.layer.masksToBounds = YES;
    self.radius = MIN(self.frame.size.width, self.frame.size.height) * 0.5;
    self.progressColor = [UIColor redColor];
    self.backgroundLayer.frame = self.layer.bounds;
    self.backgroundLayer.hidden = YES;
    [self.layer addSublayer:self.backgroundLayer];
    self.displayLayer.frame = self.layer.bounds;
    [self.layer addSublayer:self.displayLayer];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath *path = nil;
    CGFloat progress = 1.0;
    
    self.backgroundLayer.hidden = self.progressBackColor == nil;
    if (self.progressBackColor) {
        [self.layer insertSublayer:self.backgroundLayer below:self.displayLayer];
        switch (self.progressMode) {
            case LKProgressModeLine: {
                CGPoint startPoint = CGPointMake(0, (rect.size.height-self.progressWidth)*0.5);
                CGPoint endPoint = CGPointMake(rect.size.width * progress, (rect.size.height-self.progressWidth)*0.5);
                path = [UIBezierPath bezierPath];
                [path moveToPoint:startPoint];
                [path addLineToPoint:endPoint];
                self.backgroundLayer.strokeColor = self.progressBackColor.CGColor;
            }break;
            case LKProgressModePie:         case LKProgressModeArc: {
                CGFloat startAngle = -M_PI_2;
                CGFloat endAngle = startAngle + progress * M_PI * 2;
                CGFloat radius = self.radius - (self.progressMode == LKProgressModePie?0:self.progressWidth);
                CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
                path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
                if (self.progressMode == LKProgressModePie) {
                    [path addLineToPoint:center];
                    self.backgroundLayer.strokeColor = [UIColor clearColor].CGColor;
                    self.backgroundLayer.fillColor = self.progressBackColor.CGColor;
                }else {
                    self.backgroundLayer.fillColor = [UIColor clearColor].CGColor;
                    self.backgroundLayer.strokeColor = self.progressBackColor.CGColor;
                }
            }break;
            case LKProgressModeWave: {
                
            }break;
            default:
                break;
        }
        
        self.backgroundLayer.lineWidth = self.progressWidth;
        self.backgroundLayer.lineJoin = kCALineJoinRound;
        self.backgroundLayer.lineCap = kCALineCapRound;
        self.backgroundLayer.path = path.CGPath;
    }
    
    progress = self.progress;
    
    switch (self.progressMode) {
        case LKProgressModeLine: {
            CGPoint startPoint = CGPointMake(0, (rect.size.height-self.progressWidth)*0.5);
            CGPoint endPoint = CGPointMake(rect.size.width * progress, (rect.size.height-self.progressWidth)*0.5);
            path = [UIBezierPath bezierPath];
            [path moveToPoint:startPoint];
            [path addLineToPoint:endPoint];
            self.displayLayer.strokeColor = self.progressColor.CGColor;
        }break;
        case LKProgressModePie:         case LKProgressModeArc: {
            CGFloat startAngle = -M_PI_2;
            CGFloat endAngle = startAngle + progress * M_PI * 2;
            CGFloat radius = self.radius - (self.progressMode == LKProgressModePie?0:self.progressWidth);
            CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
            path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
            if (self.progressMode == LKProgressModePie) {
                [path addLineToPoint:center];
                self.displayLayer.strokeColor = [UIColor clearColor].CGColor;
                self.displayLayer.fillColor = self.progressColor.CGColor;
            }else {
                self.displayLayer.fillColor = [UIColor clearColor].CGColor;
                self.displayLayer.strokeColor = self.progressColor.CGColor;
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
