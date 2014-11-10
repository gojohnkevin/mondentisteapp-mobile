//
//  AGPatientEducationViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 9/4/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGPatientEducationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) AGGlobalVars *globals;
@property (strong, nonatomic) IBOutlet UITextView *textContent;

@end
