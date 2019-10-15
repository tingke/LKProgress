//
//  LKProgress.m
//  LKProgress
//
//  Created by dosn-001 on 2019/9/30.
//  Copyright © 2019 tinker. All rights reserved.
//

#import "LKProgress.h"

@interface LKProgress ()

@property(nonatomic, strong) CAShapeLayer  *backgroundLayer;
@property(nonatomic, strong) CAShapeLayer  *displayLayer;
@property(nonatomic, strong) CADisplayLink *displayLink;
@property(nonatomic, assign) CGFloat offset;

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
    self.offset = 0.0;
    self.progressColor = [UIColor redColor];
    self.backgroundLayer.frame = self.layer.bounds;
    self.backgroundLayer.hidden = YES;
    [self.layer addSublayer:self.backgroundLayer];
    self.displayLayer.frame = self.layer.bounds;
    [self.layer addSublayer:self.displayLayer];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.backgroundLayer.hidden = self.progressBackColor == nil;
    if (self.progressBackColor) {
        [self.layer insertSublayer:self.backgroundLayer below:self.displayLayer];
        UIBezierPath *path = [self bezierPathWithprogress:1.0 progressMode:self.progressMode == LKProgressModeWave?LKProgressModeArc:self.progressMode rect:rect];
        self.backgroundLayer.lineWidth = self.progressWidth;
        self.backgroundLayer.lineJoin = kCALineJoinRound;
        self.backgroundLayer.lineCap = kCALineCapRound;
        self.backgroundLayer.path = path.CGPath;
    }
    
    UIBezierPath *path = [self bezierPathWithprogress:self.progress progressMode:self.progressMode rect:rect];
    switch (self.progressMode) {
        case LKProgressModeLine: {
            self.displayLayer.strokeColor = self.progressColor.CGColor;
            if (self.progressBackColor) {
                self.backgroundLayer.strokeColor = self.progressBackColor.CGColor;
            }
        }break;
        case LKProgressModePie: {
            self.displayLayer.strokeColor = [UIColor clearColor].CGColor;
            self.displayLayer.fillColor = self.progressColor.CGColor;
            if (self.progressBackColor) {
                self.backgroundLayer.strokeColor = [UIColor clearColor].CGColor;
                self.backgroundLayer.fillColor = self.progressBackColor.CGColor;
            }
        }break;
        case LKProgressModeArc: {
            self.displayLayer.fillColor = [UIColor clearColor].CGColor;
            self.displayLayer.strokeColor = self.progressColor.CGColor;
            if (self.progressBackColor) {
                self.backgroundLayer.fillColor = [UIColor clearColor].CGColor;
                self.backgroundLayer.strokeColor = self.progressBackColor.CGColor;
            }
        }break;
        case LKProgressModeWave: {
            self.displayLayer.fillColor = self.progressColor.CGColor;
            if (self.progressBackColor) {
                self.backgroundLayer.fillColor = self.progressBackColor.CGColor;
            }
            self.displayLayer.mask = self.backgroundLayer;
        }break;
        default:
            break;
    }
    self.displayLayer.lineWidth = self.progressWidth;
    self.displayLayer.lineJoin = kCALineJoinRound;
    self.displayLayer.lineCap = kCALineCapRound;
    self.displayLayer.path = path.CGPath;
}

- (void)dealloc {
    if (_backgroundLayer) {
        [_backgroundLayer removeFromSuperlayer];
        _backgroundLayer = nil;
    }
    if (_displayLayer) {
        [_displayLayer removeFromSuperlayer];
        _displayLayer = nil;
    }
}

- (UIBezierPath *)bezierPathWithprogress:(CGFloat)progress progressMode:(LKProgressMode)mode rect:(CGRect)rect {
    UIBezierPath *path;
    
    switch (mode) {
        case LKProgressModeLine: {
            CGPoint startPoint = CGPointMake(0, (rect.size.height-self.progressWidth)*0.5);
            CGPoint endPoint = CGPointMake(rect.size.width * progress, (rect.size.height-self.progressWidth)*0.5);
            path = [UIBezierPath bezierPath];
            [path moveToPoint:startPoint];
            [path addLineToPoint:endPoint];
        }break;
        case LKProgressModePie:
        case LKProgressModeArc: {
            CGFloat startAngle = self.startAngle?:-M_PI_2;
            CGFloat endAngle = startAngle + progress * M_PI * 2;
            CGFloat radius = self.radius - (self.progressMode == LKProgressModePie?0:self.progressWidth);
            CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
            path = [UIBezierPath bezierPathWithArcCenter:center
                                                  radius:radius
                                              startAngle:startAngle
                                                endAngle:endAngle
                                               clockwise:YES];
            if (mode == LKProgressModePie) {
                [path addLineToPoint:center];
            }
        }break;
        case LKProgressModeWave: {
            path = [UIBezierPath bezierPath];
            CGFloat waveHeight = 10; // 振幅/最大浪高
            CGFloat wavePalstance = 0.032; // 角速度变大，则波形在X轴上收缩
            CGFloat waveY = rect.size.height * (1 - progress); // 曲线偏移
            CGPoint startPoint = CGPointMake(0, waveHeight * sin(wavePalstance * 0 + self.offset) + waveY);
            [path moveToPoint:startPoint];
            for (CGFloat x = 0; x <= rect.size.width; x++) {
                CGFloat y = waveHeight * sin(wavePalstance * x + self.offset) + waveY;
                CGPoint point = CGPointMake(x, y);
                [path addLineToPoint:point];
            }
            
            [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
            [path addLineToPoint:CGPointMake(0, rect.size.height)];
            [path addLineToPoint:startPoint];
        }break;
        default:
            break;
    }
    
    return path;
}

- (void)updateContent:(CADisplayLink *)sender {
    self.offset += 0.1;
    [self setNeedsDisplay];
}

- (void)start {
    _displayLink = [CADisplayLink displayLinkWithTarget:self
                                               selector:@selector(updateContent:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                       forMode:NSRunLoopCommonModes];
}

- (void)stop {
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
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
    progressMode == LKProgressModeWave?[self start]:[self stop];
    [self setNeedsDisplay];
}

///MARK: - ————— Getter —————

- (CAShapeLayer *)displayLayer {
    if (!_displayLayer) {
        _displayLayer = [CAShapeLayer layer];
        _displayLayer.masksToBounds = YES;
    }
    return _displayLayer;
}

- (CAShapeLayer *)backgroundLayer {
    if (!_backgroundLayer) {
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.masksToBounds = YES;
    }
    return _backgroundLayer;
}

@end
