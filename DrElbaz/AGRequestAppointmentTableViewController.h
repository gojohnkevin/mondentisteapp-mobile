//
//  AGRequestAppointmentTableViewController.h
//  MWPhotoBrowser
//
//  Created by Kevin Go on 7/21/14.
//
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGRequestAppointmentTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
- (IBAction)submitButton:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIDatePicker *timeField;
@property (strong, nonatomic) IBOutlet UIPickerView *purposeField;
@property (strong, nonatomic) IBOutlet UITextField *messageField;
@property (strong, nonatomic) IBOutlet UILabel *selectedDate;
@property (strong, nonatomic) IBOutlet UILabel *selectedTime;
@property (strong, nonatomic) IBOutlet UILabel *selectedPurpose;

- (IBAction)pickerDateChanged:(UIDatePicker *)sender;
- (IBAction)pickerTimeChanged:(UIDatePicker *)sender;


@property (strong, nonatomic) AGGlobalVars *globals;
@end
