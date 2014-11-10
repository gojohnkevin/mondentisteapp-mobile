//
//  AGAboutViewController.h
//  Dr Elbaz
//
//  Created by Kevin Go on 7/11/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGAboutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) AGGlobalVars *globals;
@property (strong, nonatomic) IBOutlet UITextView *aboutContent;

@end
