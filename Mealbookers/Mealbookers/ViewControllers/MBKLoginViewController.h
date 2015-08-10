//
//  MBKLoginViewController.h
//  Mealbookers
//
//  Created by Ilkka Rautiainen on 10/08/15.
//  Copyright (c) 2015 Datahiiri. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBKLoginDelegate <NSObject>
@required
- (void)userLoggedIn:(NSString *)username password:(NSString *)password;
@end

@interface MBKLoginViewController : UIViewController
@property (weak, nonatomic) id<MBKLoginDelegate> delegate;
@end
