//
//  UIView+AIOUtils.m
//  AIOFW
//
//  Created by Kovács Kristóf on 01/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import "UIView+AIOUtils.h"
#import "UIColor+AIOColors.h"

@implementation UIView (AIOUtils)

#pragma park - Public Methods

- (nullable UIImage *)snapshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}

- (void)startWithAnimationType:(AIOAnimationType)animationType
                     frequency:(NSTimeInterval)frequency {
    switch (animationType) {
        case AIOAnimationTypeFlashDarkLight:
            [self startFlashDarkLightWithFrequency:frequency];
            break;
            
        default:
            break;
    }
}

#pragma park - Private Methods

- (void)startFlashDarkLightWithFrequency:(NSTimeInterval)frequency {
    UIColor *newColor = self.backgroundColor.darker;
    
    if (self.backgroundColor.dark) {
        newColor = self.backgroundColor.lighter;
    }
    
    [UIView animateWithDuration:frequency delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.backgroundColor = newColor;
    } completion:nil];
}

- (void)startFlashVisibleHiddenWithFrequency:(NSTimeInterval)frequency {
    
}

@end
