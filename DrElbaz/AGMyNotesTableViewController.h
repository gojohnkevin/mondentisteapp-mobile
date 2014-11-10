//
//  AGMyNotesTableViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 10/29/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGMyNotesTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) AGGlobalVars *globals;

@end
