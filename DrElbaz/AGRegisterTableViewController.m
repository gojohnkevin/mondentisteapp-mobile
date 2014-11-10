//
//  AGRegisterTableViewController.m
//  DrElbaz
//
//  Created by Kevin Go on 10/9/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGRegisterTableViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SWRevealViewController.h"
#import "AGGlobalVars.h"
#import "TSMessage.h"
#import "TSMessageView.h"
#import "AGUtils.h"
#import "AFOAuth2Client.h"

@interface AGRegisterTableViewController (){
    NSDictionary *fields;
    NSArray *fieldSectionTitles;
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation AGRegisterTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // display navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //set name as first responder
    [_nameField becomeFirstResponder];
    
    _globals = [AGGlobalVars sharedInstance];
    
    // customize back button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"back-25.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    UIImage *logo = [AGUtils imageWithImage:logoImage scaledToSize:CGSizeMake(150, 35)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    fields = @{@"General" : @[@"name", @"username", @"contact"],
                @"Private Information" : @[@"email", @"password"]};
    
    fieldSectionTitles = [[fields allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    /*UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                  action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];*/
}

-(void)dismissKeyboard {
    [_nameField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_contactNumberField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_usernameField resignFirstResponder];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [fieldSectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *fieldTitle = [fieldSectionTitles objectAtIndex:section];
    NSArray *sectionFields = [fields objectForKey:fieldTitle];
    return [sectionFields count];
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


- (IBAction)submitButton:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    [self showIndicator];
    
    NSString *createUserUrl = [NSString stringWithFormat:@"%@/api/v1/create_user/", _globals.siteURL];
    
    NSDictionary *createUserForm = @{@"user": @{@"username": _usernameField.text,
                                                @"email": _emailField.text,
                                                @"raw_password": _passwordField.text},
                                     @"dentist": _globals.dentistURL,
                                     @"device_token": @[@{@"token":_globals.deviceToken}],
                                     @"name": _nameField.text,
                                     @"contact_number": _contactNumberField.text,};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:createUserUrl parameters:createUserForm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *loginUrl = [NSString stringWithFormat:@"%@/api/v1/user/login/", _globals.siteURL];
        NSDictionary *loginForm = @{@"username" : _usernameField.text,
                                    @"password" : _passwordField.text,};
        
        [manager POST:loginUrl parameters:loginForm success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *jsonDict = (NSDictionary *) responseObject;

            _globals.kPatientClientID = [jsonDict objectForKey:@"client_id"];
            _globals.kPatientClientSecret = [jsonDict objectForKey:@"client_secret"];
            _globals.patientUsername = _usernameField.text;
            _globals.patientPassword = _passwordField.text;
            _globals.patientURL = [jsonDict objectForKey:@"user_url"];
            
            NSURL *url = [NSURL URLWithString:_globals.siteURL];
            AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:_globals.kPatientClientID secret:_globals.kPatientClientSecret];
            
            [oauthClient authenticateUsingOAuthWithURLString:_globals.kOAuthAccessURL username:_globals.patientUsername password:_globals.patientPassword scope:@"write" success:^(AFOAuthCredential *credential) {
                _accessToken = credential.accessToken;
                _globals.patientAccessToken = _accessToken;
                [AFOAuthCredential storeCredential:credential withIdentifier:oauthClient.serviceProviderIdentifier];
            } failure:^(NSError *error) {
                UIAlertView *noConnection = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please check your internet connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [noConnection show];
            }];
            
            
            UIStoryboard *storyboard = self.storyboard;
            SWRevealViewController *revealUserView = [storyboard instantiateViewControllerWithIdentifier:@"revealUserView"];
            [self presentViewController:revealUserView animated:YES completion:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]options:0 error:NULL];
        NSLog(@"%@", jsonObject);
        NSLog(@"%@", error);
        
        NSDictionary *errorDict = [jsonObject valueForKey:@"error"];
        
        __block NSString *errorMessage;
        
        NSLog(@"%@", errorDict);
        
        errorMessage = [errorDict valueForKey:@"message"];
        [self failedMessages:errorMessage];
        [self stopIndicator];
    }];
}

-(void)failedMessages:(NSString *)errorMessage {
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
}
@end
