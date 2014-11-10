//
//  AGMainViewController.m
//  DrElbaz
//
//  Created by Kevin Go on 10/9/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGMainViewController.h"
#import "AFOAuth2Client.h"

@interface AGMainViewController ()

@end

@implementation AGMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
@end
