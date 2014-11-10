//
//  AGSocialViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 8/18/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGSocialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
- (IBAction)facebookBtn:(UIButton *)sender;
- (IBAction)twitterBtn:(UIButton *)sender;

@property (strong, nonatomic) AGGlobalVars *globals;

@property (strong, nonatomic) NSString *facebookUrl;
@property (strong, nonatomic) NSString *twitterUrl;

@end
