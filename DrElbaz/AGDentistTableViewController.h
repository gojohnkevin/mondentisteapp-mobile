//
//  AGDentistTableViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 8/6/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGDentistTableViewController : UITableViewController <UITextViewDelegate> {
    NSArray *sectionOneItems;
    NSArray *sectionTwoItems;
    NSArray *sectionThreeItems;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) AGGlobalVars *globals;

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *websiteField;
@property (strong, nonatomic) IBOutlet UITextField *facebookField;
@property (strong, nonatomic) IBOutlet UITextField *twitterField;
@property (strong, nonatomic) IBOutlet UITextField *mapsField;
- (IBAction)submitButton:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UITextField *contactNumberField;
@property (strong, nonatomic) IBOutlet UITextView *aboutField;
@property (strong, nonatomic) IBOutlet UITextView *educationField;

@end
