//
//  ViewController.m
//  折线图
//
//  Created by 石纯勇 on 16/4/5.
//  Copyright © 2016年 小石头. All rights reserved.
//

#import "ViewController.h"
#import "BrokenLineView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    BrokenLineView *lineView = [[BrokenLineView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 300)];
    lineView.backgroundColor = [UIColor yellowColor];
    lineView.xAxisArray = @[@"3-21", @"3-22", @"3-23", @"3-24", @"3-25", @"3-26", @"3-27"];
    lineView.dotValueArray = @[@"3.5", @"6.8", @"3.8", @"4.6", @"6.0", @"4.9", @"5.99"];
    lineView.yMaxValue = @(7);
    lineView.yMinValue = @(3);
    lineView.lineViewTheme = @{
                               XLabelColorKey:[UIColor blackColor],
                               XLabelFontKey:[UIFont systemFontOfSize:12],
                               YLabelColorKey:[UIColor blackColor],
                               YLabelFontKey:[UIFont systemFontOfSize:12],
                               XAxisColorKey:[UIColor blackColor],
                               YAxisColorKey:[UIColor blackColor],
                               CicleStrokeColorKey :[UIColor redColor],
                               CicleFillColorKey:[UIColor yellowColor],
                               LineStrokeColorKey:[UIColor redColor],
                               LineShadowColorKey:[UIColor redColor],
                               PopViewColorKey:[UIColor blackColor]
                               };
    [lineView line];
    [self.view addSubview:lineView];
    
    CAShapeLayer *graphLayer = [CAShapeLayer layer];
    graphLayer.frame = CGRectMake(0, 320+(self.view.frame.size.height-320)/2-100, self.view.frame.size.width, 200);
    graphLayer.fillColor = [UIColor clearColor].CGColor;
    graphLayer.backgroundColor = [UIColor redColor].CGColor;
    [graphLayer setStrokeColor:[UIColor blueColor].CGColor];
    [graphLayer setLineWidth:5];
    CGMutablePathRef graphPath = CGPathCreateMutable();
    
    CGPathAddEllipseInRect(graphPath, NULL, CGRectMake(self.view.center.x-100, 0, 200, 200));
    graphLayer.path = graphPath;
    graphLayer.zPosition = 0;
    [self.view.layer addSublayer:graphLayer];
    
    CABasicAnimation *lineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"]; // strokeStart
    lineAnimation.duration = 4;
    lineAnimation.fromValue = @(1.0);
    lineAnimation.toValue = @(0.0);
    lineAnimation.repeatCount = HUGE_VAL;
    lineAnimation.autoreverses = NO;
    [graphLayer addAnimation:lineAnimation forKey:@"strokeEnd"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
