//
//  AGDentistTableViewController.m
//  DrElbaz
//
//  Created by Kevin Go on 8/6/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGDentistTableViewController.h"
#import "SWRevealViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "TSMessage.h"
#import "TSMessageView.h"
#import "AFOAuth2Client.h"
#import "AGGlobalVars.h"
#import "AGUtils.h"

@interface AGDentistTableViewController () {
    NSInteger dentistDetailId;
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation AGDentistTableViewController

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
    
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    UIImage *logo = [AGUtils imageWithImage:logoImage scaledToSize:CGSizeMake(150, 35)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    self.title = @"Dentist Details";
    
    _globals = [AGGlobalVars sharedInstance];
    
    _sidebarButton.tintColor = [UIColor whiteColor];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self styleNavigationBar];
    
    _aboutField.text = @"About Us";
    _aboutField.delegate = self;
    
    _educationField.text = @"Patient Education";
    _aboutField.delegate = self;
    
    sectionOneItems = [NSArray arrayWithObjects:@"contact", @"email", @"website", nil];
    sectionTwoItems = [NSArray arrayWithObjects:@"facebook", @"twitter", nil];
    sectionThreeItems = [NSArray arrayWithObjects:@"maps", @"about", @"education", nil];
    
    
    NSString *userLocationURL = [NSString stringWithFormat:@"%@/api/v1/dentistprofile/?username=%@&dentist__username=%@", _globals.siteURL, _globals.username, _globals.username];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *oauthAccessToken = [NSString stringWithFormat:@"OAuth %@", _globals.accessToken];
    [manager.requestSerializer setValue:oauthAccessToken forHTTPHeaderField:@"Authorization"];
    [manager GET:userLocationURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        NSArray *userDetails = [jsonDict objectForKey:@"objects"];
        
        [userDetails enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop){
            _websiteField.text = [NSString stringWithFormat:@"%@",[obj objectForKey:@"website"]];
            _contactNumberField.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"contact_number"]];
            _emailField.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"email"]];
            
            _facebookField.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"facebook"]];
            _twitterField.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"twitter"]];
            _mapsField.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"map"]];
            _aboutField.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"about"]];
            _educationField.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"patient_education"]];
            
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    if ([_aboutField.text isEqualToString:@"About Us"]) {
        _aboutField.textColor = [UIColor lightGrayColor];
    }
    else {
        _aboutField.textColor = [UIColor blackColor];
    }
    
    if ([_educationField.text isEqualToString:@"Patient Education"]) {
        _educationField.textColor = [UIColor lightGrayColor];
    }
    else {
        _educationField.textColor = [UIColor blackColor];
    }

    
    
    [manager GET:userLocationURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        NSArray *userDetails = [jsonDict objectForKey:@"objects"];
        
        [userDetails enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop){
            dentistDetailId = [[obj objectForKey:@"id"] integerValue];
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"About Us"]) {
        textView.text = @"";
    }
    
    if ([textView.text isEqualToString:@"Patient Education"]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor]; //optional
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"About Us";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    else if ([textView.text isEqualToString:@""]) {
        textView.text = @"Patient Education";
        textView.textColor = [UIColor lightGrayColor];
    }
    else {
        textView.textColor = [UIColor blackColor];
    }
    [textView resignFirstResponder];
}

-(void)dismissKeyboard {
    [_contactNumberField resignFirstResponder];
    [_websiteField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_facebookField resignFirstResponder];
    [_twitterField resignFirstResponder];
    [_mapsField resignFirstResponder];
    [_aboutField resignFirstResponder];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [sectionOneItems count];
    }
    else if (section == 1) {
        return [sectionTwoItems count];
    }
    else {
        return [sectionThreeItems count];
    }
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
    
    NSString *dentistDetailUrl = [NSString stringWithFormat:@"%@/api/v1/dentistprofile/%ld/", _globals.siteURL, (long)dentistDetailId];
    
    NSDictionary *dentistDetailForm = @{@"contact_number" : _contactNumberField.text,
                                      @"email" : _emailField.text,
                                      @"website" : _websiteField.text,
                                      @"facebook": _facebookField.text,
                                      @"twitter": _twitterField.text,
                                      @"map": _mapsField.text,
                                      @"about": _aboutField.text,
                                      @"patient_education": _educationField.text,
                                      @"user": _globals.dentistURL,};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *oauthAccessToken = [NSString stringWithFormat:@"OAuth %@", _globals.accessToken];
    NSLog(@"%@", oauthAccessToken);
    [manager.requestSerializer setValue:oauthAccessToken forHTTPHeaderField:@"Authorization"];
    [manager PATCH:dentistDetailUrl parameters:dentistDetailForm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[self emptyAll];
        
        [TSMessage showNotificationInViewController:self
                                              title:NSLocalizedString(@"Success", nil)
                                           subtitle:NSLocalizedString(@"You have successfully updated your details.", nil)
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
        
        NSLog(@"%@",error);
        
        NSDictionary *errorDict = [jsonObject valueForKey:@"dentistprofile"];
        
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

-(void)emptyAll {
    _contactNumberField.text = @"";
    _emailField.text = @"";
    _websiteField.text = @"";
    _facebookField.text = @"";
    _twitterField.text = @"";
    _mapsField.text = @"";
    _aboutField.text = @"";
}
@end
