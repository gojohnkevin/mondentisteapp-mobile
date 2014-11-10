//
//  AGAdminESFormTableViewController.m
//  DrElbaz
//
//  Created by Kevin Go on 9/25/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGAdminESFormTableViewController.h"
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

@interface AGAdminESFormTableViewController () {
    NSArray *formItems;
    UIActivityIndicatorView *activityIndicator;
}

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;

@property (assign) BOOL datePickerIsShowing;
@property (assign) BOOL timePickerIsShowing;

@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITableViewCell *timePickerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *datePickerCell;

@property (strong, nonatomic) NSDate *selectedScheduleDate;
@property (strong, nonatomic) NSDate *selectedScheduleTime;

@property (strong, nonatomic) NSString *selectedDateString;
@property (strong, nonatomic) NSString *selectedTimeString;



@end

@implementation AGAdminESFormTableViewController

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
    
    self.navigationController.navigationBar.topItem.title = @"Back";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _globals = [AGGlobalVars sharedInstance];
    
    formItems = [NSArray arrayWithObjects:@"date", @"datePicker", @"time", @"timePicker", nil];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    UIImage *logo = [AGUtils imageWithImage:logoImage scaledToSize:CGSizeMake(150, 35)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
    [self hideDatePickerCell];
    [self hideTimePickerCell];
    
    NSDate *startDate = [NSDate date]; //now
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 7];
    
    self.datePicker.minimumDate = startDate;
    self.datePicker.maximumDate = endDate;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)setupPickers {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [self.timeFormatter setDateFormat:@"hh:mm a"];
    
    
    NSDate *defaultDate = [NSDate date];
    
    //self.selectedDate.text = [self.dateFormatter stringFromDate:defaultDate];
    self.selectedDate.text = @"Date";
    self.selectedDate.textColor = [UIColor lightGrayColor];
    
    self.selectedDateString = @"";
    self.selectedScheduleDate = defaultDate;
    
    self.selectedTimeString = @"";
    
    self.selectedTime.text = @"Heure";
    self.selectedTime.textColor = [UIColor lightGrayColor];
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.row == kDatePickerIndex){
        
        height = self.datePickerIsShowing ? kDatePickerCellHeight : 0.0f;
        
    }
    else if(indexPath.row == kTimePickerIndex){
        height = self.timePickerIsShowing ? kTimePickerCellHeight : 0.0f;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        [self dismissKeyboard];
        
        if (self.datePickerIsShowing){
            [self hideDatePickerCell];
        }else {
            [self showDatePickerCell];
        }
    }
    else if (indexPath.row == 2){
        [self dismissKeyboard];
        if (self.timePickerIsShowing){
            [self hideTimePickerCell];
        }else {
            [self showTimePickerCell];
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

- (IBAction)pickerDateChanged:(UIDatePicker *)sender {
    NSLog(@"%@", [self.dateFormatter stringFromDate:sender.date]);
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
    
}


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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitButton:(UIBarButtonItem *)sender {
    [self hideDatePickerCell];
    [self hideTimePickerCell];
    
    [self showIndicator];
    
    NSString *eSchedUrl = [NSString stringWithFormat:@"%@/api/v1/emergencyschedule/", _globals.siteURL];
    
    NSDictionary *eSchedForm = @{@"date": _selectedDateString,
                                 @"time": _selectedTimeString,
                                 @"dentist": _globals.dentistURL,};
    
    NSLog(@"%@", eSchedForm);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *oauthAccessToken = [NSString stringWithFormat:@"OAuth %@", _globals.accessToken];
    NSLog(@"%@", oauthAccessToken);
    [manager.requestSerializer setValue:oauthAccessToken forHTTPHeaderField:@"Authorization"];
    [manager POST:eSchedUrl parameters:eSchedForm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIAlertView *successNotif = [[UIAlertView alloc] initWithTitle:@"Success" message:@"New Emergency Schedule is added!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [successNotif show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]options:0 error:NULL];
        
        NSDictionary *errorDict = [jsonObject valueForKey:@"emergencyschedule"];
        
        __block NSString *errorMessage;
        
        for (NSString* key in errorDict) {
            id value = [errorDict objectForKey:key];
            errorMessage = [NSString stringWithFormat:@"%@ - %@", key, value[0]];
        }
        
        [TSMessage showNotificationInViewController:self
                                              title:NSLocalizedString(@"Something failed", nil)
                                           subtitle:NSLocalizedString(errorMessage, nil)
                                              image:nil
                                               type:TSMessageNotificationTypeError
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionBottom
                               canBeDismissedByUser:YES];
    }];
    [self stopIndicator];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
