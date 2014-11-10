//
//  AGEmergencyScheduleFormTableViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 8/16/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGEmergencyScheduleFormTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) AGGlobalVars *globals;

@property (strong, nonatomic) IBOutlet UIPickerView *purposeField;
@property (strong, nonatomic) IBOutlet UITextField *messageField;
@property (nonatomic, strong) NSString *scheduleDate;
@property (nonatomic, strong) NSString *scheduleTime;
@property (strong, nonatomic) IBOutlet UILabel *selectedPurpose;

@property (nonatomic, strong) id eScheduleId;
- (IBAction)sendButton:(UIBarButtonItem *)sender;

@end
