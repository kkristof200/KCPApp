//
//  UIColor+AIOColors.h
//
//  Created by Kovács Kristóf on 30/09/16.
//  Copyright © 2016 Kovács Kristóf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Chameleon.h"

@interface UIColor (AIOColors)

@property (nonnull, strong, nonatomic, readonly, class) UIColor *randomColor;
@property (nonnull, strong, nonatomic, readonly, class) UIColor *randomFilteredFlatColor;

@property (assign, nonatomic, readonly) BOOL dark;
@property (nullable, strong, nonatomic, readonly) UIColor *lighter;
@property (nullable, strong, nonatomic, readonly) UIColor *darker;
@property (nullable, strong, nonatomic, readonly) UIColor *contrast;

- (nullable UIColor *)withShade:(CGFloat)shade;

@end
