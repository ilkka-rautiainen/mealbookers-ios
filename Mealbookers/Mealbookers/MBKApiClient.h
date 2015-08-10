//
//  MBKApiClient.h
//  Mealbookers
//
//  Created by Ilkka Rautiainen on 10/08/15.
//  Copyright (c) 2015 Datahiiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBKApiClient : NSObject

/// Shared instance
+ (instancetype)sharedInstance;

/// Sends login request
- (void)login:(NSString *)username password:(NSString *)password success:(void (^)())success failure:(void (^)())failure;

/// Retrieves the user's logged in status
- (void)isLoggedIn:(void (^)(BOOL))success failure:(void (^)())failure;

/// Sends logout request
- (void)logout;

@end
