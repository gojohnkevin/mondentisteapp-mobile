//
//  AGRequestAppointmentTableViewController.m
//  MWPhotoBrowser
//
//  Created by Kevin Go on 7/21/14.
//
//

#import "AGRequestAppointmentTableViewController.h"
#import "SWRevealViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AGGlobalVars.h"
#import "TSMessage.h"
#import "TSMessageView.h"
#import "AGUtils.h"

#define kDatePickerIndex 1
#define kDatePickerCellHeight 180
#define kTimePickerIndex 3
#define kTimePickerCellHeight 180
#define kPurposePickerIndex 5
#define kPurposePickerCellHeight 180

@interface AGRequestAppointmentTableViewController (){
    NSArray *formItems;
    UIActivityIndicatorView *activityIndicator;
    NSArray *_pickerData;
}

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;

@property (assign) BOOL datePickerIsShowing;
@property (assign) BOOL timePickerIsShowing;
@property (assign) BOOL purposePickerIsShowing;

@property (strong, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITableViewCell *timePickerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *purposePickerCell;
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *purposePicker;

@property (strong, nonatomic) NSDate *selectedScheduleDate;
@property (strong, nonatomic) NSDate *selectedScheduleTime;

@property (strong, nonatomic) NSString *selectedPurposeReason;
@property (strong, nonatomic) NSString *selectedDateString;
@property (strong, nonatomic) NSString *selectedTimeString;

@property (strong, nonatomic) UITextField *activeTextField;

@end

@implementation AGRequestAppointmentTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPickers];
    [self signUpForKeyboardNotifications];
    
    _selectedPurposeReason = @"";
    
    _globals = [AGGlobalVars sharedInstance];
    
    formItems = [NSArray arrayWithObjects:@"date", @"datePicker", @"time", @"timePicker", @"purpose", @"purposePicker", @"message", nil];
    _pickerData = @[@"Consultation dentaire", @"Bilan complet", @"Détartrage", @"Urgence dentaire", @"Blanchiment", @"Devis prothèse", @"Devis implants", @"Autres"];
        
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    UIImage *logo = [AGUtils imageWithImage:logoImage scaledToSize:CGSizeMake(150, 35)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    _sidebarButton.tintColor = [UIColor whiteColor];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self styleNavigationBar];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      //                             initWithTarget:self
       //                            action:@selector(dismissKeyboard)];
    
    //[self.view addGestureRecognizer:tap];
    
    [self hideDatePickerCell];
    [self hideTimePickerCell];
    [self hidePurposePickerCell];
    
    NSDate *startDate = [NSDate date]; //now
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 7];
    
    self.datePicker.minimumDate = startDate;
    self.datePicker.maximumDate = endDate;
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

- (void)setupPickers {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
    //[self.timeFormatter setDateFormat:@"hh:mm a"];
    [self.timeFormatter setDateFormat:@"HH:mm"];
    
    
    NSDate *defaultDate = [NSDate date];
    
    //self.selectedDate.text = [self.dateFormatter stringFromDate:defaultDate];
    self.selectedDate.text = @"Date";
    self.selectedDate.textColor = [UIColor lightGrayColor];
    
    self.selectedDateString = @"";
    self.selectedScheduleDate = defaultDate;
    
    self.selectedTimeString = @"";
    
    self.selectedTime.text = @"Heure";
    self.selectedTime.textColor = [UIColor lightGrayColor];
    
    self.selectedScheduleTime = defaultDate;
    
    self.selectedPurpose.text = @"Motif";
    self.selectedPurpose.textColor = [UIColor lightGrayColor];
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardWillShow {
    
    if (self.datePickerIsShowing){
        
        [self hideDatePickerCell];
    }
    else if (self.timePickerIsShowing){
        [self hideTimePickerCell];
    }
    else if (self.purposePickerIsShowing){
        [self hidePurposePickerCell];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.row == kDatePickerIndex){
        
        height = self.datePickerIsShowing ? kDatePickerCellHeight : 0.0f;
        
    }
    else if(indexPath.row == kTimePickerIndex){
        height = self.timePickerIsShowing ? kTimePickerCellHeight : 0.0f;
    }
    else if(indexPath.row == kPurposePickerIndex){
        height = self.purposePickerIsShowing ? kPurposePickerCellHeight: 0.0f;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        [self dismissKeyboard];
        
        if (self.datePickerIsShowing){
            [self hideDatePickerCell];
        }else {
            [self.activeTextField resignFirstResponder];
            [self showDatePickerCell];
            [self hideTimePickerCell];
            [self hidePurposePickerCell];
        }
    }
    else if (indexPath.row == 2){
        [self dismissKeyboard];
        if (self.timePickerIsShowing){
            [self hideTimePickerCell];
        }else {
            [self.activeTextField resignFirstResponder];
            [self showTimePickerCell];
            [self hideDatePickerCell];
            [self hidePurposePickerCell];
        }
    }
    else if (indexPath.row == 4){
        [self dismissKeyboard];
        if (self.purposePickerIsShowing){
            [self hidePurposePickerCell];
        }else {
            [self.activeTextField resignFirstResponder];
            [self showPurposePickerCell];
            [self hideDatePickerCell];
            [self hideTimePickerCell];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showDatePickerCell {
    
    self.datePickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    self.datePicker.hidden = NO;
    self.datePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.datePicker.alpha = 1.0f;
    }];
}

- (void)showTimePickerCell {
    self.timePickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    self.timePicker.hidden = NO;
    self.timePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.timePicker.alpha = 1.0f;
    }];
}

- (void)showPurposePickerCell {
    self.purposePickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    self.purposePicker.hidden = NO;
    self.purposePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.purposePicker.alpha = 1.0f;
    }];
}

- (void)hideDatePickerCell {
    
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.datePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.datePicker.hidden = YES;
                     }];
}

-(void)hideTimePickerCell {
    self.timePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.timePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.timePicker.hidden = YES;
                     }];
}

-(void)hidePurposePickerCell {
    self.purposePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.purposePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.purposePicker.hidden = YES;
                     }];
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.activeTextField = textField;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedPurpose.text = _pickerData[row];
    self.selectedPurpose.textColor = [UIColor blackColor];
    self.selectedPurposeReason = _pickerData[row];
}

#pragma mark - Action methods

- (IBAction)pickerDateChanged:(UIDatePicker *)sender {
    
    self.selectedDate.text =  [self.dateFormatter stringFromDate:sender.date];
    self.selectedDate.textColor = [UIColor blackColor];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    self.selectedScheduleDate = sender.date;
    self.selectedDateString = [dateFormat stringFromDate:self.selectedScheduleDate];
}

- (IBAction)pickerTimeChanged:(UIDatePicker *)sender {
    
    self.selectedTime.text =  [self.timeFormatter stringFromDate:sender.date];
    self.selectedTime.textColor = [UIColor blackColor];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    
    self.selectedScheduleTime = sender.date;
    self.selectedTimeString = [timeFormat stringFromDate:self.selectedScheduleTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [_messageField resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [formItems count];
}

-(void)showIndicator {
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
}

-(void)stopIndicator {
    [activityIndicator stopAnimating];
}

-(void)styleNavigationBar {
    UIColor* color = [UIColor colorWithRed:0.071 green:0.075 blue:0.078 alpha:1];
    
    self.navigationController.navigationBar.barTintColor = color;
    
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName : [UIColor whiteColor],
      };
    
    self.navigationController.navigationBar.translucent = YES;
}

- (IBAction)submitButton:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    [self showIndicator];
    
    NSString *appointUrl = [NSString stringWithFormat:@"%@/api/v1/appointment/", _globals.siteURL];
    
    NSLog(@"%@", _globals.patientURL);
    NSLog(@"%@", _globals.dentistURL);
    
    NSDictionary *appointmentForm = @{@"date": _selectedDateString,
                                      @"time": _selectedTimeString,
                                      @"purpose": _selectedPurposeReason,
                                      @"comment": _messageField.text,
                                      @"dentist": _globals.dentistURL,
                                      @"patient": _globals.patientURL,
                                      @"status": @"pending"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *oauthAccessToken = [NSString stringWithFormat:@"OAuth %@", _globals.accessToken];
    NSLog(@"%@", oauthAccessToken);
    [manager.requestSerializer setValue:oauthAccessToken forHTTPHeaderField:@"Authorization"];
    [manager POST:appointUrl parameters:appointmentForm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self emptyAll];
        
        [TSMessage showNotificationInViewController:self
                                              title:NSLocalizedString(@"Success", nil)
                                           subtitle:NSLocalizedString(@"Your request has been sent!", nil)
                                              image:nil
                                               type:TSMessageNotificationTypeSuccess
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionTop
                               canBeDismissedByUser:YES];
    
        [self.view endEditing:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]options:0 error:NULL];
        
        NSDictionary *errorDict = [jsonObject valueForKey:@"appointment"];
        
        __block NSString *errorMessage;
        
        for (NSString* key in errorDict) {
            id value = [errorDict objectForKey:key];
            errorMessage = [NSString stringWithFormat:@"%@ - %@", key, value[0]];
        }
        
        [TSMessage showNotificationInViewController:self
                                              title:NSLocalizedString(@"Error", nil)
                                           subtitle:NSLocalizedString(errorMessage, nil)
                                              image:nil
                                               type:TSMessageNotificationTypeError
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionTop
                               canBeDismissedByUser:YES];
    }];
    [self stopIndicator];

}

-(void)emptyAll {
    _messageField.text = @"";
    _selectedDateString = @"";
    _selectedTimeString = @"";
    _selectedTime.text = @"Heure";
    _selectedTime.textColor = [UIColor lightGrayColor];
    _selectedDate.text = @"Date";
    _selectedDate.textColor = [UIColor lightGrayColor];
    _selectedPurpose.text = @"Motif";
    _selectedPurpose.textColor = [UIColor lightGrayColor];
    _selectedPurposeReason = @"";
    _selectedScheduleDate = [NSDate date];
    _selectedScheduleTime = [NSDate date];
}
@end
