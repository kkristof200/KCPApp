//
//  UIImage+AIOUtils.m
//  AIOFW
//
//  Created by Kovács Kristóf on 09/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import "UIImage+AIOUtils.h"

@implementation UIImage (AIOUtils)

- (BOOL)isPortrait {
    return self.size.height > self.size.width;
}

- (nonnull UIImage *)coloredImage:(nonnull UIColor *)color {
    UIImage *newImage = [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [color set];
    [newImage drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
