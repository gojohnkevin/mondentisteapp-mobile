//
//  AGLoginViewController.m
//  DrElbaz
//
//  Created by Kevin Go on 8/1/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGLoginViewController.h"
#import "SWRevealViewController.h"
#import "AGGlobalVars.h"
#import "TSMessage.h"
#import "TSMessageView.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFOAuth2Client.h"
#import "AGUtils.h"

@interface AGLoginViewController () {
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation AGLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    // display navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
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
    
    //sets username as first responder
    [_usernameField becomeFirstResponder];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    _globals = [AGGlobalVars sharedInstance];
    
    NSURL *url = [NSURL URLWithString:_globals.siteURL];
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:_globals.kClientID secret:_globals.kClientSecret];
    
    [oauthClient authenticateUsingOAuthWithURLString:_globals.kOAuthAccessURL username:_globals.username password:_globals.password scope:@"write" success:^(AFOAuthCredential *credential) {
        _accessToken = credential.accessToken;
        _globals.accessToken = _accessToken;
        [AFOAuthCredential storeCredential:credential withIdentifier:oauthClient.serviceProviderIdentifier];
    } failure:^(NSError *error) {
        UIAlertView *noConnection = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please check your internet connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noConnection show];
    }];
    
    //self.navigationController.navigationBar.hidden = YES;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

-(void)saveDeviceToken {
    NSString *deviceTokenUrl = [NSString stringWithFormat:@"%@/api/v1/devicetoken/", _globals.siteURL];
    NSLog(@"%@", _globals.deviceToken);
    NSDictionary *deviceTokenForm = @{@"token" : _globals.deviceToken,};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *oauthAccessToken = [NSString stringWithFormat:@"OAuth %@", _globals.accessToken];
    [manager.requestSerializer setValue:oauthAccessToken forHTTPHeaderField:@"Authorization"];
    [manager POST:deviceTokenUrl parameters:deviceTokenForm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success");
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]options:0 error:NULL];
        NSLog(@"%@", jsonObject);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)showIndicator {
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
}

-(void)stopIndicator {
    [activityIndicator stopAnimating];
}

- (IBAction)loginButton:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    [self showIndicator];
    [self saveDeviceToken];
    
    NSString *appointUrl = [NSString stringWithFormat:@"%@/api/v1/user/login/", _globals.siteURL];
    
    NSString *tokenUrl = [NSString stringWithFormat:@"%@/api/v1/devicetoken/", _globals.siteURL];
    
    NSDictionary *loginForm = @{@"username" : _usernameField.text,
                                @"password" : _passwordField.text,};
    NSDictionary *tokenForm = @{@"token": _globals.deviceToken};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:appointUrl parameters:loginForm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        
        [self.view endEditing:YES];
        [self stopIndicator];
        
        if ([[jsonDict objectForKey:@"type"] isEqualToString:@"patient"]) {
            _globals.kPatientClientID = [jsonDict objectForKey:@"client_id"];
            _globals.kPatientClientSecret = [jsonDict objectForKey:@"client_secret"];
            _globals.patientUsername = _usernameField.text;
            _globals.patientPassword = _passwordField.text;
            _globals.patientURL = [jsonDict objectForKey:@"user_url"];
            
            UIStoryboard *storyboard = self.storyboard;
            SWRevealViewController *revealUserView = [storyboard instantiateViewControllerWithIdentifier:@"revealUserView"];
            [self presentViewController:revealUserView animated:YES completion:nil];
        }
        else{
            if (_globals.deviceToken) {
                [manager POST:tokenUrl parameters:tokenForm success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"%@", responseObject);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
        
            UIStoryboard *storyboard = self.storyboard;
            SWRevealViewController *adminLoggedView = [storyboard instantiateViewControllerWithIdentifier:@"adminMainView"];
            [self presentViewController:adminLoggedView animated:YES completion:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]options:0 error:NULL];
        
        NSDictionary *errorReason = [jsonObject valueForKey:@"reason"];
        
        __block NSString *errorMessage;
        
        if ([errorReason isEqual: @"disabled"]) {
            errorMessage = NSLocalizedString(@"Your account has been disabled.", nil);
            [self failedMessages:errorMessage];
        }
        else if ([errorReason isEqual:@"incorrect"]) {
            errorMessage = NSLocalizedString(@"Username and/or password is incorrect.", nil);
            [self failedMessages:errorMessage];
        }
        else {
            UIAlertView *noConnection = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Internet Connection",nil) message:NSLocalizedString(@"Please check your internet connection and try again.",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [noConnection show];
        }
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
