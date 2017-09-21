//
//  BrokenLineView.m
//  折线图
//
//  Created by 石纯勇 on 16/3/28.
//  Copyright © 2016年 小石头. All rights reserved.
//

#import "BrokenLineView.h"
#import "PopoverView.h"

// 下边距
#define View_Bottom_Space 25.0
// 上边距
#define View_Top_Space   25.0
// y轴间隔数
#define Y_Interval 5


@implementation BrokenLineView {
    float _leftDistance;
    float _rightDistance;
    NSMutableArray *xCenterArray;
}

NSString *const XLabelColorKey = @"XLabelColorKey";
NSString *const XLabelFontKey = @"XLabelFontKey";
NSString *const YLabelColorKey = @"YLabelColorKey";
NSString *const YLabelFontKey = @"YLabelFontKey";
NSString *const XAxisColorKey = @"XAxisColorKey";
NSString *const YAxisColorKey = @"YAxisColorKey";
NSString *const CicleStrokeColorKey = @"CicleStrokeColorKey";
NSString *const CicleFillColorKey = @"CicleFillColorKey";
NSString *const LineStrokeColorKey = @"LineStrokeColorKey";
NSString *const PopViewColorKey = @"PopViewColorKey";
NSString *const LineShadowColorKey = @"LineShadowColorKey";

- (instancetype)init {
    if((self = [super init])) {
        _leftDistance = 5;
        _rightDistance = 5;
        [self loadDefaultLineViewTheme];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _leftDistance = 5;
        _rightDistance = 5;
        [self loadDefaultLineViewTheme];
    }
    return self;
}

- (void)loadDefaultLineViewTheme {
    _lineViewTheme = @{
               XLabelColorKey : [UIColor lightGrayColor],
               XLabelFontKey :[UIFont systemFontOfSize:12.f],
               YLabelColorKey : [UIColor lightGrayColor],
               YLabelFontKey : [UIFont systemFontOfSize:12.f],
               XAxisColorKey:[UIColor blackColor],
               YAxisColorKey:[UIColor blackColor],
               CicleStrokeColorKey:[UIColor redColor],
               CicleFillColorKey:[UIColor yellowColor],
               LineStrokeColorKey:[UIColor redColor],
               LineShadowColorKey:[UIColor redColor],
               PopViewColorKey:[UIColor blackColor]
               
                         };
}

#pragma mark - public method
- (void)line {
    
    NSAssert(_dotValueArray.count == _xAxisArray.count, @"折线图数据不成对");

    [self drawYLabels];
    
    [self drawXLabels];
    
    [self drawXLines];
    
    [self drawYLines];
    
    [self drawLine];
}

#pragma mark - private method
/**< Y轴数据label >*/
- (void)drawYLabels {

    double minNumber = [_yMinValue doubleValue];
    double maxNumber = [_yMaxValue doubleValue];
    double yIntervalValue = (maxNumber-minNumber)/Y_Interval;
    double intervalInPx = (self.bounds.size.height-View_Bottom_Space-View_Top_Space)/Y_Interval;
    
    NSMutableArray *labelArray = [NSMutableArray array];
    float maxWidth=0, _left=0;
    for(int i=0; i<=Y_Interval; i++) {
        CGPoint currentLinePoint = CGPointMake(0, View_Top_Space + i*intervalInPx);
        CGRect lableFrame = CGRectMake(0, currentLinePoint.y - (intervalInPx/2), 100, intervalInPx);
        
        UILabel *yLabel = [[UILabel alloc] initWithFrame:lableFrame];
        yLabel.backgroundColor = [UIColor clearColor];
        yLabel.font = _lineViewTheme[YLabelFontKey];
        yLabel.textColor = _lineViewTheme[YLabelColorKey];
        yLabel.textAlignment = NSTextAlignmentCenter;
        float val = minNumber + (yIntervalValue * (Y_Interval-i));
        yLabel.text = [NSString stringWithFormat:@"%.2f", val];
        [yLabel sizeToFit];
        CGRect newLabelFrame = CGRectMake(_leftDistance, currentLinePoint.y - (yLabel.layer.frame.size.height/2), yLabel.frame.size.width, yLabel.layer.frame.size.height);
        yLabel.frame = newLabelFrame;
        if(newLabelFrame.size.width > maxWidth) {
            maxWidth = newLabelFrame.size.width;
        }
        [labelArray addObject:yLabel];
        [self addSubview:yLabel];
        _left = maxWidth;
    }
    _leftDistance = _left+_leftDistance+2;
}

/**< X轴数据label >*/
- (void)drawXLabels {
    NSInteger xIntervalCount = [_xAxisArray count];
    double xIntervalInPx = (self.bounds.size.width-_leftDistance)/xIntervalCount;
    xCenterArray = [NSMutableArray array];
    for(int i=0; i < xIntervalCount; i++){
        CGPoint currentLabelPoint = CGPointMake((xIntervalInPx * i)+_leftDistance, self.bounds.size.height - View_Bottom_Space);
        CGRect xLabelFrame = CGRectMake(currentLabelPoint.x , currentLabelPoint.y, xIntervalInPx, View_Bottom_Space);
        UILabel *xLabel = [[UILabel alloc] initWithFrame:xLabelFrame];
        xLabel.backgroundColor = [UIColor clearColor];
        xLabel.font = _lineViewTheme[XLabelFontKey];
        xLabel.textColor = _lineViewTheme[XLabelColorKey];
        xLabel.textAlignment = NSTextAlignmentCenter;
        xLabel.text = _xAxisArray[i];
        [self addSubview:xLabel];
        [xCenterArray addObject:[NSNumber numberWithDouble:xLabel.center.x]];
    }
}

/**< 画横线 >*/
- (void)drawXLines {

    CAShapeLayer *linesLayer = [CAShapeLayer layer];
    linesLayer.frame = self.bounds;
    linesLayer.fillColor = [UIColor clearColor].CGColor;
    linesLayer.backgroundColor = [UIColor clearColor].CGColor;
    linesLayer.strokeColor = ((UIColor *)_lineViewTheme[XAxisColorKey]).CGColor;
    linesLayer.lineWidth = 1;
    
    CGMutablePathRef linesPath = CGPathCreateMutable();
    double intervalInPx = (self.bounds.size.height - View_Bottom_Space-View_Top_Space)/Y_Interval;
    CGPoint currentLinePoint = CGPointZero;
    
    for(int i=0; i<=Y_Interval; i++){
        currentLinePoint = CGPointMake(_leftDistance, View_Top_Space+(i*intervalInPx));
        CGPathMoveToPoint(linesPath, NULL, currentLinePoint.x, currentLinePoint.y);
        CGPathAddLineToPoint(linesPath, NULL, currentLinePoint.x + self.bounds.size.width-_leftDistance-_rightDistance, currentLinePoint.y);
    }
    
    CGPathMoveToPoint(linesPath, NULL, currentLinePoint.x, self.bounds.size.height-3);
    CGPathAddLineToPoint(linesPath, NULL, currentLinePoint.x + self.bounds.size.width-_leftDistance-_rightDistance, self.bounds.size.height-3);
    linesLayer.path = linesPath;
    [self.layer addSublayer:linesLayer];
}

/**< 画竖线 >*/
- (void)drawYLines {

    CAShapeLayer *linesLayer = [CAShapeLayer layer];
    linesLayer.frame = self.bounds;
    linesLayer.fillColor = [UIColor clearColor].CGColor;
    linesLayer.backgroundColor = [UIColor clearColor].CGColor;
    linesLayer.strokeColor = ((UIColor *)_lineViewTheme[YAxisColorKey]).CGColor;
    linesLayer.lineWidth = 1;
    
    CGMutablePathRef linesPath = CGPathCreateMutable();
    NSInteger xIntervalCount = [_xAxisArray count];
    double xIntervalInPx = (self.bounds.size.width-_leftDistance)/xIntervalCount;
    CGPoint currentLinePoint = CGPointZero;
    for(NSInteger i=0; i<xIntervalCount; i++){
        
        currentLinePoint = CGPointMake((2*i+1)*xIntervalInPx/2+_leftDistance, View_Top_Space);
        
        CGPathMoveToPoint(linesPath, NULL, currentLinePoint.x, currentLinePoint.y);
        CGPathAddLineToPoint(linesPath, NULL, currentLinePoint.x , self.bounds.size.height-View_Bottom_Space);
    }
    
    CGPathMoveToPoint(linesPath, NULL, 2, 20);
    CGPathAddLineToPoint(linesPath, NULL, 2 , self.bounds.size.height-20);
    linesLayer.path = linesPath;
    [self.layer addSublayer:linesLayer];
}

/**< 画折线图 >*/
- (void)drawLine {
    // shadow层
    CAShapeLayer *shadowLayer = [CAShapeLayer layer];
    shadowLayer.frame = self.bounds;
    shadowLayer.fillColor = [_lineViewTheme[LineShadowColorKey] colorWithAlphaComponent:0.3].CGColor;
    shadowLayer.backgroundColor = [UIColor clearColor].CGColor;
    [shadowLayer setStrokeColor:[UIColor clearColor].CGColor];
    CGMutablePathRef shadowPath = CGPathCreateMutable();
    
    // 圆环层
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = self.bounds;
    circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    [circleLayer setStrokeColor:((UIColor *)_lineViewTheme[CicleStrokeColorKey]).CGColor];
    [circleLayer setFillColor:((UIColor *)_lineViewTheme[CicleFillColorKey]).CGColor];
    [circleLayer setLineWidth:1.5];
    CGMutablePathRef circlePath = CGPathCreateMutable();
    
    // 线层
    CAShapeLayer *graphLayer = [CAShapeLayer layer];
    graphLayer.frame = self.bounds;
    graphLayer.fillColor = [UIColor clearColor].CGColor;
    graphLayer.backgroundColor = [UIColor clearColor].CGColor;
    [graphLayer setStrokeColor:((UIColor *)_lineViewTheme[LineStrokeColorKey]).CGColor];
    [graphLayer setLineWidth:1.5];
    CGMutablePathRef graphPath = CGPathCreateMutable();
    
    double minNumber = [_yMinValue doubleValue];
    double maxNumber = [_yMaxValue doubleValue];
    double height = self.bounds.size.height-View_Bottom_Space;
    double maxToMin = maxNumber-minNumber;
    NSInteger count = _xAxisArray.count;
    NSMutableArray *yArray = [NSMutableArray array];
    
    for (int i=0; i<count; i++) {
        double y = height - ((height-View_Top_Space)/maxToMin) * ([_dotValueArray[i] doubleValue]-minNumber);
        [yArray addObject:[NSNumber numberWithDouble:y]];
    }
    // 起点
    CGPoint startPoint = CGPointMake([xCenterArray[0] doubleValue], [yArray[0] doubleValue]);
    // 终点
    CGPoint endPoint = CGPointMake([[xCenterArray lastObject] doubleValue], [[yArray lastObject] doubleValue]);
    
    
    CGPathMoveToPoint(graphPath, NULL, startPoint.x, startPoint.y);
    CGPathMoveToPoint(shadowPath, NULL, startPoint.x, startPoint.y);
    for(int i=0; i<count; i++) {
        CGPoint point = CGPointMake([xCenterArray[i] doubleValue], [yArray[i] doubleValue]);
        CGPathAddLineToPoint(shadowPath, NULL, point.x, point.y);
        CGPathAddLineToPoint(graphPath, NULL, point.x, point.y);
        CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(point.x-3.5, point.y-3.5, 6, 6));
    }
    
    CGPathAddLineToPoint(shadowPath, NULL, endPoint.x, self.bounds.size.height-View_Bottom_Space);
    CGPathAddLineToPoint(shadowPath, NULL, startPoint.x, self.bounds.size.height-View_Bottom_Space);
    CGPathAddLineToPoint(shadowPath, NULL, startPoint.x, startPoint.y);
    
    
    // 渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[
                             (id)((UIColor *)_lineViewTheme[LineShadowColorKey]).CGColor,
                             (id)[_lineViewTheme[LineShadowColorKey] colorWithAlphaComponent:.8].CGColor,
                             (id)[_lineViewTheme[LineShadowColorKey] colorWithAlphaComponent:.6].CGColor,
                             (id)[_lineViewTheme[LineShadowColorKey] colorWithAlphaComponent:.4].CGColor,
                             (id)[_lineViewTheme[LineShadowColorKey] colorWithAlphaComponent:.2].CGColor,
                             (id)[_lineViewTheme[LineShadowColorKey] colorWithAlphaComponent:.0].CGColor];
    
    shadowLayer.path = shadowPath;
    graphLayer.path = graphPath;
    circleLayer.path = circlePath;
    
    // 动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 3;
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    [graphLayer addAnimation:animation forKey:@"strokeEnd"];
    
    // 层级关系
    shadowLayer.zPosition = 0;
    graphLayer.zPosition = 1;
    circleLayer.zPosition = 2;
    
    //    [self.layer addSublayer:shadowLayer];
    gradientLayer.mask = shadowLayer; // 剪切
    [self.layer addSublayer:gradientLayer]; // 使用渐变色
    [self.layer addSublayer:graphLayer];
    [self.layer addSublayer:circleLayer];
    
    
    CGPathCloseSubpath(shadowPath);
    CGPathRelease(shadowPath);
    
    // 按钮点击
    for(int i=0; i<count; i++){
        CGPoint point = CGPointMake([xCenterArray[i] doubleValue], [yArray[i] doubleValue]);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        btn.frame = CGRectMake(point.x - 15, point.y - 15, 30, 30);
        [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)clicked:(UIButton *)btn {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
    lbl.backgroundColor = [UIColor clearColor];
    NSUInteger tag = btn.tag;
    lbl.text = _dotValueArray[tag];
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:12.f];
    [lbl sizeToFit];
    lbl.frame = CGRectMake(0, 0, lbl.frame.size.width + 5, lbl.frame.size.height);
    
    CGPoint point = btn.center;
    point.y -= 7;
    [PopoverView showPopoverAtPoint:point
                             inView:self
                    withContentView:lbl
                             shadow:[_lineViewTheme[PopViewColorKey] colorWithAlphaComponent:0.8]
                           delegate:nil];
}
@end
