//
//  AIOUtils.m
//  AIOFW
//
//  Created by Kovács Kristóf on 20/11/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import "AIOUtils.h"

#import <UIKit/UIKit.h>

@implementation AIOUtils

+ (BOOL)isPhone {
    #if TARGET_IPHONE_SIMULATOR
    return ([UIDevice.currentDevice.model rangeOfString:@"iPhone"].location != NSNotFound);
    #endif
    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone;
//    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

+ (BOOL)isPortraitOrientation {
    return UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation);
}

@end
