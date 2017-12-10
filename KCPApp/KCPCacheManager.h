//
//  KCPCacheManager.h
//  AIOFW
//
//  Created by Kovács Kristóf on 07/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCPApp.h"

@interface KCPCacheManager : NSObject

+ (void)cacheAppInfo:(nonnull NSDictionary *)appInfo;
+ (nullable NSDictionary *)cachedAppInfo:(NSUInteger)id;
+ (nullable KCPApp *)cachedApp:(NSUInteger)id;
+ (BOOL)isAppCached:(NSUInteger)id;

@end
