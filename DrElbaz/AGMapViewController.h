//
//  AGMapViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 7/18/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AGMapViewController.h"
#import "AGGlobalVars.h"

@interface AGMapViewController : UIViewController
- (IBAction)closeModalbtn:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet MKMapView *addressLocationMap;
@property (strong, nonatomic) AGGlobalVars *globals;

@end
