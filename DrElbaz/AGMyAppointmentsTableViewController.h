//
//  AGMyAppointmentsTableViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 8/18/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGMyAppointmentsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) AGGlobalVars *globals;
@property (strong, nonatomic) NSArray *appointmentsList;

@end
