//
//  MBKLoginViewController.m
//  Mealbookers
//
//  Created by Ilkka Rautiainen on 10/08/15.
//  Copyright (c) 2015 Datahiiri. All rights reserved.
//

#import "MBKLoginViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import "MBKApiClient.h"

@interface MBKLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) MBProgressHUD *hud;
@end

@implementation MBKLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/// Login button touched
- (IBAction)loginTouch:(id)sender
{
    [self.hud hide:NO];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Logging in";
    [self.hud show:YES];
    [self sendLoginRequest];
}

- (void)sendLoginRequest
{
    [[MBKApiClient sharedInstance] login:self.usernameField.text password:self.passwordField.text success:^{
        [self.delegate userLoggedIn:self.usernameField.text password:self.passwordField.text];
        [self.hud hide:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^{
        NSLog(@"eee");
    }];
}

@end
