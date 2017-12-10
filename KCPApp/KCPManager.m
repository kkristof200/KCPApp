//
//  KCPManager.m
//  AIOFW
//
//  Created by Kovács Kristóf on 09/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import "KCPManager.h"
#import "KCPDownloader.h"
#import "KCPCacheManager.h"
#import "KCPParser.h"
#import "KCPViewController.h"

#import "Reachability.h"

static NSString *kHostName = @"https://www.google.com";

@implementation KCPManager

+ (KCPAdResult)showAdOnVc:(nonnull UIViewController *)vc
                    appId:(NSUInteger)appId {
    if ([[Reachability reachabilityWithHostName:kHostName] currentReachabilityStatus] == NotReachable) {
        return KCPAdResultNoInternetConnection;
    }
    
    BOOL isAppCached = [KCPCacheManager isAppCached:appId];
    
    if (!isAppCached) {
        [self getApp:appId
          completion:nil];
        
        return KCPAdResultAppNotCached;
    }
    
    KCPApp *app = [KCPCacheManager cachedApp:appId];
    
    if (app.currentDeviceSupported) {
        
        KCPViewController *kcpVc = [[KCPViewController alloc] initWithApp:app];
        
        [vc presentViewController:kcpVc
                         animated:YES
                       completion:nil];
        
        return KCPAdResultSuccess;
    }
    
    return KCPAdResultCurrentDeviceNotSupported;
}

+ (void)saveApps:(nonnull NSArray <NSNumber *> *)appIds
      completion:(void (^_Nullable)(BOOL success))completion {
    if ([[Reachability reachabilityWithHostName:kHostName] currentReachabilityStatus] == NotReachable) {
        if (completion) {
            completion(NO);
        }
        
        return;
    }
    
    dispatch_queue_t queue = dispatch_queue_create("downLoadApps",
                                                   DISPATCH_QUEUE_SERIAL);
    dispatch_group_t appGroup = dispatch_group_create();
    dispatch_group_async(appGroup, queue, ^{
        for (NSNumber *appIdNum in appIds) {
            NSUInteger appId = appIdNum.unsignedIntegerValue;
            
            dispatch_group_enter(appGroup);
            [self getApp:appId
              completion:^(BOOL success __unused) {
                   dispatch_group_leave(appGroup);
            }];
        }
    });
    
    dispatch_group_notify(appGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if (completion) {
            completion(YES);
        }
    });
}

+ (void)getApp:(NSUInteger)appId
    completion:(void (^_Nullable)(BOOL success))completion {
    if ([[Reachability reachabilityWithHostName:kHostName] currentReachabilityStatus] == NotReachable) {
        if (completion) {
            completion(NO);
        }
        
        return;
    }
    
    if (![KCPCacheManager isAppCached:appId]) {
        [KCPDownloader fetchInfoForAppId:appId
                              completion:^(NSDictionary * _Nullable appInfo) {
                                  __block NSMutableDictionary *parsedAppInfo = [[KCPParser parsedAppInfo:appInfo] mutableCopy];
                                  
                                  dispatch_queue_t queue = dispatch_queue_create("downLoadImages",
                                                                                 DISPATCH_QUEUE_SERIAL);
                                  dispatch_group_t imgGroup = dispatch_group_create();
                                  dispatch_group_async(imgGroup, queue, ^{
                                      
                                      if ([parsedAppInfo[kCurrentDeviceSupported] boolValue]) {
                                          dispatch_group_enter(imgGroup);
                                          [KCPDownloader imageDataWithURL:parsedAppInfo[kIconUrl]
                                                               completion:^(NSData * _Nullable data) {
                                                                   if (data) {
                                                                       parsedAppInfo[kIconImageData] = data;
                                                                   }
                                                                   
                                                                   dispatch_group_leave(imgGroup);
                                                               }];
                                          
                                          NSArray *screenShotUrls = parsedAppInfo[kScreenshotUrls];
                                          
                                          __block NSMutableArray *screenShots = [NSMutableArray new];
                                          
                                          NSLog(@"screenShotUrls.count: %lu", screenShotUrls.count);
                                          
                                          dispatch_group_enter(imgGroup);
                                          [KCPDownloader imageDataWithURL:screenShotUrls[0]
                                                               completion:^(NSData * _Nullable data) {
                                                                   if (data) {
                                                                       screenShots[0] = data;
                                                                       
                                                                       if (screenShotUrls.count > 1) {
                                                                           [KCPDownloader imageDataWithURL:screenShotUrls[1]
                                                                                                completion:^(NSData * _Nullable data) {
                                                                                                    if (data) {
                                                                                                        screenShots[1] = data;
                                                                                                        parsedAppInfo[kScreenShotImageDatas] = screenShots;
                                                                                                    }
                                                                                                    dispatch_group_leave(imgGroup);
                                                                                                }];
                                                                       } else {
                                                                           dispatch_group_leave(imgGroup);
                                                                       }
                                                                   } else {
                                                                       dispatch_group_leave(imgGroup);
                                                                   }
                                                               }];
                                      }
                                  });
                                  
                                  dispatch_group_notify(imgGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                                      [KCPCacheManager cacheAppInfo:[parsedAppInfo copy]];
                                      
                                      if (completion) {
                                          completion(YES);
                                      }
                                  });
                              }];
    } else {
        if (completion) {
            completion(YES);
        }
    }
}

/* DEPRECATED
 */
/*
+ (void)appWithId:(NSUInteger)appId
       completion:(void (^_Nonnull)(KCPApp * _Nullable app))completion {
    [self saveApp:appId
       completion:^(NSDictionary * _Nullable appInfo) {
           if (!appInfo) {
               completion(nil);
               
               return;
           }
           
           completion([KCPParser parsedApp:appInfo]);
       }];
}

+ (void)forcedShowAdOnVc:(nonnull UIViewController *)vc
                   appId:(NSUInteger)appId
              completion:(void (^_Nullable)(KCPAdResult result))completion {
    KCPAdResult result = [self showAdOnVc:vc
                                    appId:appId];
    if (result != KCPAdResultAppNotCached) {
        completion(result);
        
        return;
    }
    
    [self appWithId:appId
         completion:^(KCPApp * _Nullable app) {
             if (!app) {
                 completion(KCPAdResultFetchingFailed);
                 
                 return;
             }
             
             if (app.currentDeviceSupported) {
                 KCPViewController *kcpVc = [[KCPViewController alloc] initWithApp:app];
                 [vc presentViewController:kcpVc
                                  animated:YES
                                completion:nil];
                 completion(KCPAdResultSuccess);
                 
                 return;
             }
             
             completion(KCPAdResultCurrentDeviceNotSupported);
         }];
}
 */

@end
