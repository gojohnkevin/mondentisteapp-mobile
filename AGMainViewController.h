//
//  AGMainViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 10/9/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGMainViewController : UIViewController
@property (strong, nonatomic) AGGlobalVars *globals;
@property (strong, nonatomic) NSString *accessToken;

@end
