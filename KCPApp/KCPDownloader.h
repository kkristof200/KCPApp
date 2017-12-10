//
//  KCPDownloader.h
//  AIOFW
//
//  Created by Kovács Kristóf on 07/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCPDownloader : NSObject

+ (void)fetchInfoForAppId:(NSInteger)appId
               completion:(void (^_Nonnull)(NSDictionary * _Nullable appInfo))completion;
+ (void)imageDataWithURL:(nonnull NSURL *)url
              completion:(void (^_Nonnull)(NSData * _Nullable data))completion;

@end
