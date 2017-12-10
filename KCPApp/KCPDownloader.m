//
//  KCPDownloader.m
//  AIOFW
//
//  Created by Kovács Kristóf on 07/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import "KCPDownloader.h"

static NSString * kItunesUrlPre = @"https://itunes.apple.com/lookup?id=";

@interface KCPDownloader ()

@end

@implementation KCPDownloader

+ (void)fetchInfoForAppId:(NSInteger)appId
               completion:(void (^_Nonnull)(NSDictionary * _Nullable appInfo))completion {
    NSString *country = [NSLocale.currentLocale objectForKey: NSLocaleCountryCode];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%lu&country=%@", kItunesUrlPre, appId, country ? country: @"us"];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [self dataWithURL:url
           completion:^(NSData * _Nullable data) {
               if (!data) {
                   completion(nil);
                   
                   return;
               }
               
               NSError *error;
               id jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:&error];
               
               if(error
                  || !jsonData) {
                   completion(nil);
                   
                   return;
               }
               
               NSDictionary *appInfo;
               
               NSArray *results = jsonData[@"results"];
               
               if (results.count > 0) {
                   appInfo = jsonData[@"results"][0];
               }
               
               completion(appInfo);
           }];
}

+ (void)imageDataWithURL:(nonnull NSURL *)url
              completion:(void (^_Nonnull)(NSData * _Nullable data))completion {
    if ([url isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    [self dataWithURL:url completion:^(NSData * _Nullable data) {
        completion(data);
    }];
}

#pragma mark - Private method

+ (void)dataWithURL:(nonnull NSURL *)url
         completion:(void (^_Nonnull)(NSData * _Nullable data))completion {
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                     if (error
                                                                         || !data) {
                                                                         completion(nil);
                                                                     } else {
                                                                         completion(data);
                                                                     }
                                                                 }];
    [dataTask resume];
}

@end
