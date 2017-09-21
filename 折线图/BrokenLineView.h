//
//  BrokenLineView.h
//  折线图
//
//  Created by 石纯勇 on 16/3/28.
//  Copyright © 2016年 石纯勇. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 折线图
@interface BrokenLineView : UIView

/**
 点数据 
 */
@property (nonatomic, strong) NSArray      *dotValueArray;

/**
 x轴数据数组 
 */
@property (nonatomic, strong) NSArray      *xAxisArray;

/**
 y轴最大值 
 */
@property (nonatomic, strong) NSNumber     *yMaxValue;

/**
 y轴最小值 
 */
@property (nonatomic, strong) NSNumber     *yMinValue;

/**
 文字 线 颜色、字体大小等等 
 */
@property (nonatomic, retain) NSDictionary *lineViewTheme;

/**
 画图 
 */
- (void)line;


#pragma mark - ThemeKeys
// x轴文字颜色
UIKIT_EXTERN NSString *const XLabelColorKey;
// x轴文字字体
UIKIT_EXTERN NSString *const XLabelFontKey;
// y轴文字颜色
UIKIT_EXTERN NSString *const YLabelColorKey;
// y轴文字字体
UIKIT_EXTERN NSString *const YLabelFontKey;
// x轴线颜色
UIKIT_EXTERN NSString *const XAxisColorKey;
// y轴线颜色
UIKIT_EXTERN NSString *const YAxisColorKey;
// 圆环颜色
UIKIT_EXTERN NSString *const CicleStrokeColorKey;
// 圆环内填充颜色
UIKIT_EXTERN NSString *const CicleFillColorKey;
// 折线颜色
UIKIT_EXTERN NSString *const LineStrokeColorKey;
// shadow阴影颜色
UIKIT_EXTERN NSString *const LineShadowColorKey;
// 弹出pop背景颜色
UIKIT_EXTERN NSString *const PopViewColorKey;

@end
