//
//  AGLoginViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 8/1/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGLoginViewController : UIViewController

@property (strong, nonatomic) AGGlobalVars *globals;
@property (strong, nonatomic) NSString *accessToken;

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)loginButton:(UIBarButtonItem *)sender;

@end
