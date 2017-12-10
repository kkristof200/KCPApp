//
//  UIColor+AIOColors.m
//
//  Created by Kovács Kristóf on 30/09/16.
//  Copyright © 2016 Kovács Kristóf. All rights reserved.
//

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#import <UIKit/UIKit.h>
#import "UIColor+Chameleon.h"

@implementation UIColor (AIOColors)

+ (nonnull UIColor *)randomColor {
    int r = arc4random()%255;
    int g = arc4random()%255;
    int b = arc4random()%255;
    
    return RGBA(r, g, b, 1);
}

- (nullable UIColor *)withShade:(CGFloat)shade {
    CGFloat r, g, b, a;
    
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        return [UIColor colorWithRed:MIN(r + shade, 1.0)
                               green:MIN(g + shade, 1.0)
                                blue:MIN(b + shade, 1.0)
                               alpha:a];
    }
    
    return nil;
}

- (BOOL)dark {
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    
    return ((r * 299) + (g * 587) + (b * 114)) * 255 / 1000 < 125;
}

- (nullable UIColor *)lighter {
    return [self withShade:.25];
}

- (nullable UIColor *)darker {
    return [self withShade:-.25];
}

- (nullable UIColor *)contrast {
    CGFloat r, g, b, a;
    
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        return [UIColor colorWithRed:(1 - r)
                               green:(1 - g)
                                blue:(1 - b)
                               alpha:a];
    }
    
    return nil;
}

@end
