//
//  AGBooksTableViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 9/3/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGBooksTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) AGGlobalVars *globals;
@property (strong, nonatomic) NSArray *bookList;
@end
