//
//  AGHomeViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 7/18/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGHomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) AGGlobalVars *globals;
@property (strong, nonatomic) NSString *mapUrl;
@property (strong, nonatomic) NSString *websiteUrl;
@property (strong, nonatomic) NSString *contactNumber;

- (IBAction)callUsBtn:(UIButton *)sender;
- (IBAction)findUsBtn:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIImageView *circleImage;
@property (strong, nonatomic) IBOutlet UIView *homeViewController;
@property (strong, nonatomic) IBOutlet UIButton *findUsButton;
@property (strong, nonatomic) IBOutlet UIButton *callUsButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutUsButton;
@property (strong, nonatomic) IBOutlet UIButton *appointmentButton;
@property (strong, nonatomic) IBOutlet UIButton *notificationsButton;

@end
