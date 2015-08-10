//
//  MBKWebViewController.m
//  Mealbookers
//
//  Created by Ilkka Rautiainen on 10/08/15.
//  Copyright (c) 2015 Datahiiri. All rights reserved.
//

#import "MBKWebViewController.h"
#import "MBKLoginViewController.h"
#import "MBKApiClient.h"

@interface MBKWebViewController () <MBKLoginDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@end

@implementation MBKWebViewController

static NSString *const indexURL = @"http://mealbookers.net/#/menu/today?source=ios";
static NSString *const loginURL = @"http://mealbookers.net/#/menu/today?source=ios&email=%@&password=%@";
static NSString *const logoutURL = @"http://mealbookers.net/#/menu/today?source=ios&logout=1";
static NSString *const loginText = @"Log In";
static NSString *const logoutText = @"Log Out";
static NSString *const loggedInKey = @"logged-in";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUrlWithWebView:indexURL];
    [self setBarButtonText];
    [self checkLoggedInStatus];
}

/// Sets bar button text
- (void)setBarButtonText
{
    // Logged in
    if ([[NSUserDefaults standardUserDefaults] boolForKey:loggedInKey]) {
        [self.barButton setTitle:logoutText];
    }
    // Not
    else {
        [self.barButton setTitle:loginText];
    }
}

/// Prepare for seque
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Bar button click"]) {
        ((MBKLoginViewController *)segue.destinationViewController).delegate = self;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Bar button click"]) {
        // Logged in
        if ([[NSUserDefaults standardUserDefaults] boolForKey:loggedInKey]) {
            [self logout];
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        return YES;
    }
}

/// Makes a new request in webview
- (void)loadUrlWithWebView:(NSString *)url
{
    NSURL *urlObject = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlObject];
    [self.webView stopLoading];
    [self.webView reload];
    [self.webView loadRequest:request];
}

/// Called when user has logged in
- (void)userLoggedIn:(NSString *)username password:(NSString *)password
{
    [self loadUrlWithWebView:[NSString stringWithFormat:loginURL, username, password]];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:loggedInKey];
    [self setBarButtonText];
}

- (void)checkLoggedInStatus
{
    [[MBKApiClient sharedInstance] isLoggedIn:^(BOOL loggedIn) {
        [[NSUserDefaults standardUserDefaults] setBool:loggedIn forKey:loggedInKey];
        [self setBarButtonText];
    } failure:^{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:loggedInKey];
        [self setBarButtonText];
    }];
}

- (void)logout
{
    // Logout background requests
    [[MBKApiClient sharedInstance] logout];
    
    // Logout web view
    [self loadUrlWithWebView:logoutURL];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:loggedInKey];
    [self setBarButtonText];
}

@end
