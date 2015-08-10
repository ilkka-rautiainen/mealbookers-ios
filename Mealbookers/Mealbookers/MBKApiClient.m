//
//  MBKApiClient.m
//  Mealbookers
//
//  Created by Ilkka Rautiainen on 10/08/15.
//  Copyright (c) 2015 Datahiiri. All rights reserved.
//

#import "MBKApiClient.h"
#import <AFNetworking/AFNetworking.h>

@interface MBKApiClient()
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@end

@implementation MBKApiClient

static NSString *const baseURLString = @"http://mealbookers.net/mealbookers/api/1.0/";
static NSString *const loginActionString = @"user/login";
static NSString *const logoutActionString = @"user/logout";
static NSString *const userActionString = @"user";

+ (instancetype)sharedInstance
{
    static MBKApiClient *client;
    if (!client) {
        client = [[MBKApiClient alloc] init];
    }
    return client;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSURL *baseURL = [NSURL URLWithString:baseURLString];
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        self.manager.requestSerializer = [self requestSerializer];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }
    return self;
}

- (AFJSONRequestSerializer *)requestSerializer
{
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return serializer;
}

#pragma mark - Requests

- (void)login:(NSString *)username password:(NSString *)password success:(void (^)())success failure:(void (^)())failure
{
    NSDictionary *parameters = @{
                                 @"email": username,
                                 @"password": password,
                                 @"remember": @YES,
                                 };
    
    [self.manager POST:loginActionString parameters:parameters success:success failure:failure];
}

- (void)isLoggedIn:(void (^)(BOOL))success failure:(void (^)())failure
{
    [self.manager GET:userActionString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *role = [((NSDictionary *) responseObject) valueForKeyPath:@"user.role"];
        if ([role isEqualToString:@"guest"]) {
            success(false);
        }
        else {
            success(true);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"eeeei");
    }];
}

- (void)logout
{
    [self.manager POST:logoutActionString parameters:nil success:nil failure:nil];
}

@end
