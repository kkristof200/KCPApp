//
//  KCPApp.h
//  AIOFW
//
//  Created by Kovács Kristóf on 07/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KCPApp : NSObject

@property (nonatomic, assign) NSInteger id; // App id from app store

// fetched from iTunes API
@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, assign) float price;
@property (nonatomic, strong, nonnull) NSString *formattedPrice;
@property (nonatomic, strong, nonnull) NSArray <NSURL *> *screenShotUrls;
@property (nonatomic, strong, nonnull) NSURL *iconUrl;
@property (nonatomic, assign, readonly) BOOL currentDeviceSupported;

@property (nonatomic, assign) unsigned int userRatingCount;
@property (nonatomic, assign) float averageUserRating;
@property (nonatomic, assign) unsigned int userRatingCountForCurrentVersion;
@property (nonatomic, assign) float averageUserRatingForCurrentVersion;

//fetched images from URLs
@property (nonatomic, strong, nonnull) NSArray <UIImage *> *screenShots;
@property (nonatomic, strong, nonnull) UIImage *iconImage;

@end
