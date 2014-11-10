//
//  AGAdminESFormTableViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 9/25/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGAdminESFormTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *selectedTime;
@property (strong, nonatomic) IBOutlet UILabel *selectedDate;
@property (strong, nonatomic) AGGlobalVars *globals;
- (IBAction)submitButton:(UIBarButtonItem *)sender;

@end
