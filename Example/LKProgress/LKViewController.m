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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupView];
}

- (void)setupView {
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(100, 80, 200, 20)];
    [slider addTarget:self action:@selector(handleSliderEvent:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:slider];
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithFrame:CGRectMake(100, 110, 200, 20)];
    [seg insertSegmentWithTitle:@"直线" atIndex:0 animated:NO];
    [seg insertSegmentWithTitle:@"饼状" atIndex:1 animated:NO];
    [seg insertSegmentWithTitle:@"圆弧" atIndex:2 animated:NO];
    [seg insertSegmentWithTitle:@"波浪" atIndex:3 animated:NO];
    [seg addTarget:self action:@selector(handleSegmentEvent:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:seg];
    
    self.progress = [[LKProgress alloc] initWithFrame:CGRectMake(100, 150, 200, 200)];
    self.progress.progressColor = [UIColor redColor];
    self.progress.progressWidth = 4;
    [self.view addSubview:self.progress];
}

- (void)handleSliderEvent:(UISlider *)sender {
    
    self.progress.progress = sender.value;
}

- (void)handleSegmentEvent:(UISegmentedControl *)sender {
    self.progress.progressMode = sender.selectedSegmentIndex;
}
@end
