//
//  ZCYStyleDefine.h
//  在重邮
//
//  Created by 周维康 on 16/10/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "UIColor+Additions.h"
#import "DDLog.h"
#ifndef ZCYStyleDefine_h
#define ZCYStyleDefine_h

#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelInfo;
#endif

#define kProportionWidthFactor  (kScreenWidth / kStanderWidth)   //设备屏幕宽度与基准屏幕宽度比例
#define kProportionHeightFactor (kScreenHeight / kStanderHeight) //设备屏幕宽度与基准屏幕宽度比例

#define kStandardPx(Px) round(Px/1.92 * 10)/10          //把标注转化成实际宽高

#define kFont(x) [UIFont systemFontOfSize:x]


#define kProportionWidth(w) round((w * kProportionWidthFactor)*10)/10
#define kProportionHeight(h) round((h * kProportionHeightFactor)*10)/10

#define kDefaultFont  kFont(13.5)

#define kCommonGreen_Color              [UIColor colorWithRGBHex:0x2ac99a]
#define kCommonRed_Color                [UIColor colorWithRGBHex:0xf86365]
#define kCommonOrange_Color             [UIColor colorWithRGBHex:0xe96600]
#define kCommonRed_Color_Highlighted    [UIColor colorWithRGBHex:0xbd494a]
#define kCommonLightGray_Color          [UIColor colorWithRGBHex:0xf7f7f7]
#define kCommonGray_Color               [UIColor colorWithRGBHex:0xeaeaea]
#define kCommonWhite_Color              [UIColor colorWithRGBHex:0xffffff]
#define kCommonLightYellow_Color        [UIColor colorWithRGBHex:0xfff8ea]

#define kCommonBorder_Color             [UIColor colorWithRGBHex:0xbbbbbb]
#define kCommonLightBlue_Color          [UIColor colorWithRGBHex:0x268ddd]


#define kCommonYellow_Color             [UIColor colorWithRGBHex:0xffeca0]
#define kCommonGolden_Color             [UIColor colorWithRGBHex:0xfda00d]


#define kAppBg_Color                    [UIColor whiteColor]

#define kCommonText_Color               [UIColor colorWithRGBHex:0x000000]
#define kText_Color_Blue                [UIColor colorWithRGBHex:0x0e9be3]
#define kText_Color_Blue_Highlighted    [UIColor colorWithRGBHex:0x107bb2]
#define kText_Color_Green               [UIColor colorWithRGBHex:0x15bb8a]
#define kText_Color_Green_Highlighted   [UIColor colorWithRGBHex:0x108261]
#define kText_Color_LightGreen          [UIColor colorWithRGBHex:0x5cd272]
#define kText_Color_LightGray           [UIColor colorWithRGBHex:0xbbbbbb]
#define kText_Color_Gray                [UIColor colorWithRGBHex:0x838383]
#define kText_Color_Default             [UIColor colorWithRGBHex:0x404040]
#define kText_Color_ParaGray            [UIColor colorWithRGBHex:0x5d5d5d]
#define KText_Color_White               [UIColor colorWithRGBHex:0xffffff]
#define kText_Color_RealLightGreen      [UIColor colorWithRGBHex:0x9d9d9d]

#define kGray_Line_Color                [UIColor colorWithRGBHex:0xdfdfdf]
#define kGray_Background_Color          [UIColor colorWithRGBHex:0xf0f0f0]

#define LGray_Line_Color                [UIColor colorWithRGBHex:0xcfcfcf]
#define Gray_Line_Color                 [UIColor colorWithRGBHex:0xd0d0d0]
#define onTopLabel_Color_Red            [UIColor colorWithRGBHex:0xfd4141]

#define kLight_Color_Red                [UIColor colorWithRGBHex:0xff4222]
#define kPageControl_CurrentGray        [UIColor colorWithRGBHex:0xc4c4c4]
#define kPageControl_Gray               [UIColor colorWithRGBHex:0xe1e1e1]



#define kNavBar_TitleColor              [UIColor whiteColor]
#define kNavBar_TitleHighlightColor     [UIColor grayColor]

#define kNavbar_BgImage                 [UIImage imageWithColor:kNavBar_Color]
#define kTabbar_BgImage                 [UIImage imageWithColor:[UIColor whiteColor]]


#endif /* ZCYStyleDefine_h */
