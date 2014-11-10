//
//  AGRegisterTableViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 10/9/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGRegisterTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *contactNumberField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) AGGlobalVars *globals;
@property (strong, nonatomic) NSString *accessToken;
- (IBAction)submitButton:(UIBarButtonItem *)sender;

@end
