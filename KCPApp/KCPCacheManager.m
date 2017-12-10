//
//  KCPCacheManager.m
//  AIOFW
//
//  Created by Kovács Kristóf on 07/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import "KCPCacheManager.h"
#import "KCPApp.h"
#import "EGOCache.h"

#import "KCPParser.h"

@implementation KCPCacheManager

+ (void)cacheAppInfo:(nonnull NSDictionary *)appInfo {
    [EGOCache globalCache].defaultTimeoutInterval = 7 * 86400;
    
    NSUInteger id = [appInfo[kTrackId] unsignedIntegerValue];
    NSString *idStr = [NSString stringWithFormat:@"%lu", id];
    
    NSData *appData = [NSKeyedArchiver archivedDataWithRootObject:appInfo];
    [[EGOCache globalCache] setData:appData
                             forKey:idStr];
}

+ (nullable NSDictionary *)cachedAppInfo:(NSUInteger)id {
    if (![self isAppCached:id]) {
        return nil;
    }
    
    NSString *appIdStr = [NSString stringWithFormat:@"%lu", id];
    NSData *appInfoData = [[EGOCache globalCache] dataForKey:appIdStr];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:appInfoData];
}

+ (nullable KCPApp *)cachedApp:(NSUInteger)id {
    if (![self isAppCached:id]) {
        return nil;
    }
    
    NSString *appIdStr = [NSString stringWithFormat:@"%lu", id];
    NSData *appInfoData = [[EGOCache globalCache] dataForKey:appIdStr];
    NSDictionary *appInfo = [NSKeyedUnarchiver unarchiveObjectWithData:appInfoData];
    
    return [KCPParser parsedApp:appInfo];
}

+ (BOOL)isAppCached:(NSUInteger)id {
    NSString *appIdStr = [NSString stringWithFormat:@"%lu", id];
    return [[EGOCache globalCache] hasCacheForKey:appIdStr];
}

@end
