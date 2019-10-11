//
//  LKViewController.m
//  LKProgress
//
//  Created by tingke on 10/11/2019.
//  Copyright (c) 2019 tingke. All rights reserved.
//

#import "LKViewController.h"
#import <LKProgress/LKProgress.h>

@interface LKViewController ()

@property(nonatomic, strong) LKProgress *progress;

@end

@implementation LKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupView];
}

- (void)setupView {
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(100, 80, 200, 20)];
    [slider addTarget:self
               action:@selector(handleSliderEvent:)
     forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:slider];

    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithFrame:CGRectMake(100, 110, 200, 20)];
    [seg addTarget:self
                  action:@selector(handleSegmentEvent:)
        forControlEvents:(UIControlEventValueChanged)];
    NSArray *titles = @[@"直线", @"饼状", @"圆弧", @"波浪"];
    [titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        [seg insertSegmentWithTitle:obj atIndex:idx animated:NO];
    }];
    [self.view addSubview:seg];

    self.progress = [[LKProgress alloc] initWithFrame:CGRectMake(100, 150, 200, 200)];
    self.progress.progressColor = [UIColor redColor];
//    self.progress.progressBackColor = [UIColor greenColor];
    self.progress.progressWidth = 4;
    [self.view addSubview:self.progress];
    
    slider.value = 0.3;
    [self handleSliderEvent:slider];
}

- (void)handleSliderEvent:(UISlider *)sender {
    self.progress.progress = sender.value;
}

- (void)handleSegmentEvent:(UISegmentedControl *)sender {
    self.progress.progressMode = sender.selectedSegmentIndex;
}

@end
