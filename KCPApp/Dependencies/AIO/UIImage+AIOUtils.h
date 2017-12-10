//
//  UIImage+AIOUtils.h
//  AIOFW
//
//  Created by Kovács Kristóf on 09/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AIOUtils)

@property (nonatomic, assign, readonly) BOOL isPortrait;

- (nonnull UIImage *)coloredImage:(nonnull UIColor *)color;

@end
