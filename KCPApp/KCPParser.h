//
//  KCPParser.h
//  AIOFW
//
//  Created by Kovács Kristóf on 08/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCPApp.h"

// APP DIC KEYS

static NSString *kTrackId = @"trackId";
static NSString *kVersion = @"version";

static NSString *kTrackName   = @"trackName";
static NSString *kDescription = @"description";

static NSString *kPrice          = @"price";
static NSString *kFormattedPrice = @"formattedPrice";

static NSString *kIconUrl        = @"artworkUrl512";
static NSString *kScreenshotUrls = @"screenshotUrls";

static NSString *kScreenShotImageDatas = @"screenShotImageDatas";
static NSString *kIconImageData        = @"iconImageData";

static NSString *kUserRatingCount                    = @"userRatingCount";
static NSString *kAverageUserRating                  = @"averageUserRating";
static NSString *kUserRatingCountForCurrentVersion   = @"userRatingCountForCurrentVersion";
static NSString *kAverageUserRatingForCurrentVersion = @"averageUserRatingForCurrentVersion";

static NSString *kCurrentDeviceSupported  = @"currentDeviceSupported";

@interface KCPParser : NSObject

+ (nonnull NSDictionary *)parsedAppInfo:(nonnull NSDictionary *)itunesAppInfo;

+ (nonnull KCPApp *)parsedApp:(nonnull NSDictionary *)appInfo;

@end
