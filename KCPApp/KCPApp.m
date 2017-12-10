//
//  KCPApp.m
//  AIOFW
//
//  Created by Kovács Kristóf on 07/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import "KCPApp.h"
#import "KCPApp+Private.h"

@implementation KCPApp

static BOOL currentDeviceSupported;

- (BOOL)currentDeviceSupported {
    return currentDeviceSupported;
}
- (void)setCurrentDeviceSupported:(BOOL)supported {
    currentDeviceSupported = supported;
}

@end
