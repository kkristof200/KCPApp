//
//  KCPParser.m
//  AIOFW
//
//  Created by Kovács Kristóf on 08/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import "KCPParser.h"

#import "KCPApp+Private.h"

#import <UIKit/UIKit.h>

static NSString *kIpadScreenshotUrls = @"ipadScreenshotUrls";
static NSString *kSupportedDevices   = @"supportedDevices";
static NSString *kMinimumOsVersion   = @"minimumOsVersion";

@implementation KCPParser

#pragma mark - public methods

+ (nonnull NSDictionary *)parsedAppInfo:(nonnull NSDictionary *)appInfo {
    NSUInteger id = [appInfo[kTrackId] unsignedIntegerValue];
    BOOL currentDeviceSupported = [self isCurrentDeviceSupported:appInfo[kSupportedDevices]
                                                minimumOsVersion:appInfo[kMinimumOsVersion]];
    
    if (currentDeviceSupported) {
        NSArray *urlStrs;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            urlStrs = appInfo[kScreenshotUrls];
            
            if (!urlStrs) {
                urlStrs = appInfo[kIpadScreenshotUrls];
            }
        } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            urlStrs = appInfo[kIpadScreenshotUrls];
            
            if (!urlStrs) {
                urlStrs = appInfo[kScreenshotUrls];
            }
        }
        
        if (urlStrs
            && urlStrs.count > 0) {
            NSMutableArray *mutableUrlStrs = [NSMutableArray new];
            
            for (NSUInteger i = 0; i < 2; i++) {
                if (urlStrs[i]) {
                    [mutableUrlStrs addObject:[NSURL URLWithString:urlStrs[i]]];
                }
            }
            
            NSArray *urls = [mutableUrlStrs copy];
            
            return @{kTrackId:@(id),
                     kVersion:appInfo[kVersion],
                     
                     kTrackName:appInfo[kTrackName],
                     kDescription:appInfo[kDescription],
                     
                     kPrice:appInfo[kPrice],
                     kFormattedPrice:appInfo[kFormattedPrice],
                     
                     kIconUrl:appInfo[@"artworkUrl512"],
                     kScreenshotUrls:urls,
                     
                     kUserRatingCount:@([appInfo[kUserRatingCount] unsignedIntegerValue]),
                     kAverageUserRating:@([appInfo[kAverageUserRating] unsignedIntegerValue]),
                     kUserRatingCountForCurrentVersion:@([appInfo[kUserRatingCountForCurrentVersion] unsignedIntegerValue]),
                     kAverageUserRatingForCurrentVersion:@([appInfo[kAverageUserRatingForCurrentVersion] floatValue]),
                     
                     kCurrentDeviceSupported:@(YES),
                     };
        }
    }
    
    return @{kTrackId:@(id),
             kCurrentDeviceSupported:@(NO)
             };
}

+ (nonnull KCPApp *)parsedApp:(nonnull NSDictionary *)appInfo {
    KCPApp *app = [KCPApp new];
    
    app.id = [appInfo[kTrackId] unsignedIntegerValue];
    BOOL currentDeviceSupported = [appInfo[kCurrentDeviceSupported] boolValue];
    app.currentDeviceSupported = currentDeviceSupported;
    
    if (app.currentDeviceSupported) {
        app.name = appInfo[kTrackName];
        app.price = [appInfo[kPrice] floatValue];
        app.formattedPrice = appInfo[kFormattedPrice];
        app.screenShotUrls = appInfo[kScreenshotUrls];
        app.iconUrl = appInfo[kIconUrl];
        
        app.userRatingCount = [appInfo[kUserRatingCount] unsignedIntValue];
        app.averageUserRating = [appInfo[kAverageUserRating] floatValue];
        app.userRatingCountForCurrentVersion = [appInfo[kUserRatingCountForCurrentVersion] unsignedIntValue];
        app.averageUserRatingForCurrentVersion = [appInfo[kAverageUserRatingForCurrentVersion] floatValue];
        
        NSMutableArray *screenShots = [NSMutableArray new];
        
        for (NSData *imgData in appInfo[kScreenShotImageDatas]) {
            [screenShots addObject:[UIImage imageWithData:imgData]];
        }
        
        app.screenShots = [screenShots copy];
        app.iconImage = [UIImage imageWithData:appInfo[kIconImageData]];
    }
    
    return app;
}

#pragma mark - private methods

+ (BOOL)isCurrentDeviceSupported:(nonnull NSArray <NSString *> *)supportedDevices
                minimumOsVersion:(nonnull NSString *)version {
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    if ([systemVersion compare:version
                       options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    }
    
    UIUserInterfaceIdiom currentDevice = UI_USER_INTERFACE_IDIOM();
    NSString *currentDeviceStr;
    
    if (currentDevice == UIUserInterfaceIdiomPhone) {
        currentDeviceStr = @"iPhone";
    } else {
        currentDeviceStr = @"iPad";
    }
    
    for (NSString *deviceStr in supportedDevices) {
        if ([deviceStr containsString:currentDeviceStr]) {
            return YES;
        }
    }
    
    return NO;
}

@end
