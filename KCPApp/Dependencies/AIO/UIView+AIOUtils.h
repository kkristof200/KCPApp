//
//  UIView+AIOUtils.h
//  AIOFW
//
//  Created by Kovács Kristóf on 01/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, AIOAnimationType) {
    AIOAnimationTypeFlashDarkLight = 0,
    AIOAnimationTypeFlashVisibleHidden
};

@interface UIView (AIOUtils)

@property (nullable, nonatomic, strong, readonly) UIImage *snapshot;

- (void)startWithAnimationType:(AIOAnimationType)animationType
                     frequency:(NSTimeInterval)frequency;

@end
