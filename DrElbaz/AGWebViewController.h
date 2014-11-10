//
//  AGWebViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 7/31/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGWebViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UIWebView *viewWeb;
@property (strong, nonatomic) AGGlobalVars *globals;

@end
