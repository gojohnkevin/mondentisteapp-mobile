//
//  AGSidebarTableViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 7/11/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "AGGlobalVars.h"

@interface AGSidebarTableViewController : UITableViewController<MWPhotoBrowserDelegate>

@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableArray *thumbs;
@property (strong, nonatomic) AGGlobalVars *globals;

@end
