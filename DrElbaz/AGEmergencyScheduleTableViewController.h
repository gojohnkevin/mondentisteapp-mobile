//
//  AGEmergencyScheduleTableViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 8/13/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGEmergencyScheduleTableViewController : UITableViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) AGGlobalVars *globals;
@property (strong, nonatomic) NSDictionary *eSchedDetails;
@property (strong, nonatomic) NSArray *scheduleSectionTitles;

@end
