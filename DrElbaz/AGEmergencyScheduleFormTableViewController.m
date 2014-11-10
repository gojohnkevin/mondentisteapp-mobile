//
//  AGEmergencyScheduleFormTableViewController.m
//  DrElbaz
//
//  Created by Kevin Go on 8/16/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGEmergencyScheduleFormTableViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AGGlobalVars.h"
#import "TSMessage.h"
#import "TSMessageView.h"
#import "SWRevealViewController.h"
#import "AGUtils.h"

#define kPurposePickerIndex 1
#define kPurposePickerCellHeight 180

@interface AGEmergencyScheduleFormTableViewController () {
    NSArray *formItems;
    UIActivityIndicatorView *activityIndicator;
    NSArray *_pickerData;
}


@property (assign) BOOL purposePickerIsShowing;
@property (strong, nonatomic) IBOutlet UITableViewCell *purposePickerCell;
@property (strong, nonatomic) IBOutlet UIPickerView *purposePicker;
@property (strong, nonatomic) NSString *selectedPurposeReason;

@property (strong, nonatomic) NSString *selectedDateString;
@property (strong, nonatomic) NSString *selectedTimeString;

@property (strong, nonatomic) UITextField *activeTextField;

@end

@implementation AGEmergencyScheduleFormTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.navigationBar.topItem.title = @"Back";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _globals = [AGGlobalVars sharedInstance];
    
    formItems = [NSArray arrayWithObjects:@"purpose", @"purposePicker", @"message", nil];
    _pickerData = @[@"Abcès", @"Fracture Dentaire", @"Fracture osseuse", @"Urgence Esthétique", @"Accident de dents de Sagesse", @"Autres"];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    UIImage *logo = [AGUtils imageWithImage:logoImage scaledToSize:CGSizeMake(150, 35)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.purposePicker.dataSource = self;
    self.purposePicker.delegate = self;
    
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
    //                               initWithTarget:self
     //                              action:@selector(dismissKeyboard)];
    
    //[self.view addGestureRecognizer:tap];
    
    [self hidePurposePickerCell];
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

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

- (void)setupPickers {
    self.selectedPurpose.text = @"Motif";
    self.selectedPurpose.textColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [_messageField resignFirstResponder];
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardWillShow {
    if (self.purposePickerIsShowing){
        [self hidePurposePickerCell];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    if(indexPath.row == kPurposePickerIndex){
        height = self.purposePickerIsShowing ? kPurposePickerCellHeight: 0.0f;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0){
        [self dismissKeyboard];
        if (self.purposePickerIsShowing){
            [self hidePurposePickerCell];
        }else {
            [self.activeTextField resignFirstResponder];
            [self showPurposePickerCell];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.activeTextField = textField;
    
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedPurpose.text = _pickerData[row];
    self.selectedPurpose.textColor = [UIColor blackColor];
    self.selectedPurposeReason = _pickerData[row];
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

- (IBAction)sendButton:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    [self showIndicator];
    
    NSString *appointUrl = [NSString stringWithFormat:@"%@/api/v1/appointment/", _globals.siteURL];
    NSString *eSchedUrl = [NSString stringWithFormat:@"%@/api/v1/emergencyschedule/%@/", _globals.siteURL, _eScheduleId];
    NSString *emergencyUrl = [NSString stringWithFormat:@"/api/v1/emergencyschedule/%@/", _eScheduleId];
    
    NSDictionary *appointmentForm = @{@"comment": _messageField.text,
                                      @"dentist": _globals.dentistURL,
                                      @"status": @"accepted",
                                      @"device_token": _globals.deviceToken,
                                      @"date": _scheduleDate,
                                      @"time": _scheduleTime,
                                      @"purpose": _selectedPurposeReason,
                                      @"patient": _globals.patientURL,
                                      @"emergency": emergencyUrl,};
    NSLog(@"%@", appointmentForm);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *oauthAccessToken = [NSString stringWithFormat:@"OAuth %@", _globals.accessToken];
    [manager.requestSerializer setValue:oauthAccessToken forHTTPHeaderField:@"Authorization"];
    [manager POST:appointUrl parameters:appointmentForm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSDictionary *eScheduleForm = @{@"is_booked":@"True",};
        
        [manager PATCH:eSchedUrl parameters:eScheduleForm success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _messageField.text = @"";
            
            UIAlertView *successNotif = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your request has been sent!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [successNotif show];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
        
        [self.view endEditing:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]options:0 error:NULL];
        
        NSLog(@"%@", error);
        NSLog(@"%@", jsonObject);
        
        NSDictionary *errorDict = [jsonObject valueForKey:@"appointment"];
        
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
                                         atPosition:TSMessageNotificationPositionTop
                               canBeDismissedByUser:YES];
    }];
    [self stopIndicator];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIStoryboard *storyboard = self.storyboard;
    SWRevealViewController *revealUserView = [storyboard instantiateViewControllerWithIdentifier:@"revealUserView"];
    [self presentViewController:revealUserView animated:YES completion:nil];
}
@end
