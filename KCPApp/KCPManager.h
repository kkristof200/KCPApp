//
//  KCPManager.h
//  AIOFW
//
//  Created by Kovács Kristóf on 09/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/* Enum representing the result of the requested ad ViewCntroller
 */
typedef NS_ENUM (NSUInteger, KCPAdResult) {
    KCPAdResultSuccess = 0,
    KCPAdResultAppNotCached,
    KCPAdResultFetchingFailed,
    KCPAdResultCurrentDeviceNotSupported,
    KCPAdResultNoInternetConnection
};

@interface KCPManager : NSObject

/*  Shows an Ad ViewController with the provided App Id
    App needs to be cached first.
    If it isn't cached, it caches it automatically.
 */
+ (KCPAdResult)showAdOnVc:(nonnull UIViewController *)vc
                    appId:(NSUInteger)appId;

/* Downloads and caches the requested apps (If aren't cached already)
 */
+ (void)saveApps:(nonnull NSArray <NSNumber *> *)appIds
      completion:(void (^_Nullable)(BOOL success))completion;

/* Downloads and caches an app (If isn't cached already)
 */
+ (void)getApp:(NSUInteger)appId
    completion:(void (^_Nullable)(BOOL success))completion;

/*  DEPRECATED
 */
/*
+ (void)appWithId:(NSUInteger)appId
       completion:(void (^_Nonnull)(KCPApp * _Nullable app))completion;
+ (void)forcedShowAdOnVc:(nonnull UIViewController *)vc
                   appId:(NSUInteger)appId
              completion:(void (^_Nullable)(KCPAdResult result))completion;
 */

@end
