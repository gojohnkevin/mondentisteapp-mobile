//
//  AGHomeViewController.m
//  DrElbaz
//
//  Created by Kevin Go on 7/18/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGHomeViewController.h"
#import "SWRevealViewController.h"
#import "AGGlobalVars.h"
#import "AFHTTPRequestOperationManager.h"
#import "AGUtils.h"

@interface AGHomeViewController ()

@end

@implementation AGHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor colorWithRed:0.886 green:0.898 blue:0.894 alpha:1]];
    // Do any additional setup after loading the view.
    
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    UIImage *logo = [AGUtils imageWithImage:logoImage scaledToSize:CGSizeMake(150, 35)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    _globals = [AGGlobalVars sharedInstance];
    
    UIImage *backgroundLogoImage = [UIImage imageNamed:@"main-circle.png"];
    _circleImage = [[UIImageView alloc] initWithImage:backgroundLogoImage];
    float viewWidth = self.view.frame.size.width;
    float viewHeight = self.view.frame.size.height;
    
    float imageWH = viewWidth * 0.90f;
    
    float buttonWH = (viewWidth * 0.25f) * 0.9f;
    
    _circleImage.center = self.view.center;
    _circleImage.frame = CGRectMake((viewWidth-imageWH)/2, (viewHeight-imageWH)/2, imageWH, imageWH);
    [self.view addSubview:_circleImage];
    [self.view sendSubviewToBack:_circleImage];
    
    
    UIImage *findUs = [UIImage imageNamed:@"nous_trouver.png"];
    [_findUsButton setBackgroundImage:findUs forState:UIControlStateNormal];
    _findUsButton.center = self.view.center;
    [_findUsButton removeFromSuperview];
    [_findUsButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    //_findUsButton.frame = CGRectMake((viewWidth-buttonWH)/2, (((viewHeight-buttonWH)/2)*0.6), buttonWH, buttonWH);
    _findUsButton.frame = CGRectMake((viewWidth-buttonWH)/2, ((viewHeight/2)- buttonWH)*0.75, buttonWH, buttonWH);
    [self.view addSubview:_findUsButton];
    
    //final
    UIImage *callUs = [UIImage imageNamed:@"contact.png"];
    [_callUsButton setBackgroundImage:callUs forState:UIControlStateNormal];
    _callUsButton.center = self.view.center;
    [_callUsButton removeFromSuperview];
    [_callUsButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    _callUsButton.frame = CGRectMake((viewWidth-(buttonWH * 0.9))/2, (viewHeight-(buttonWH * 0.7))/2, (buttonWH * 0.9), (buttonWH * 0.9));
    [self.view addSubview:_callUsButton];
    
    //final
    UIImage *aboutUs = [UIImage imageNamed:@"le_cabinet.png"];
    [_aboutUsButton setBackgroundImage:aboutUs forState:UIControlStateNormal];
    _aboutUsButton.center = self.view.center;
    [_aboutUsButton removeFromSuperview];
    [_aboutUsButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    _aboutUsButton.frame = CGRectMake((viewWidth-buttonWH)/2*0.3, (viewHeight-buttonWH)/2, buttonWH, buttonWH);
    [self.view addSubview:_aboutUsButton];
    
    //final
    UIImage *appointment = [UIImage imageNamed:@"RDV.png"];
    [_appointmentButton setBackgroundImage:appointment forState:UIControlStateNormal];
    _appointmentButton.center = self.view.center;
    [_appointmentButton removeFromSuperview];
    [_appointmentButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    _appointmentButton.frame = CGRectMake((viewWidth-buttonWH)/2*1.7, (viewHeight-buttonWH)/2, buttonWH, buttonWH);
    [self.view addSubview:_appointmentButton];
    
    
    UIImage *notifications = [UIImage imageNamed:@"notification.png"];
    [_notificationsButton setBackgroundImage:notifications forState:UIControlStateNormal];
    _notificationsButton.center = self.view.center;
    [_notificationsButton removeFromSuperview];
    [_notificationsButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    _notificationsButton.frame =  CGRectMake((viewWidth-buttonWH)/2, ((viewHeight/2)- buttonWH)*1.6, buttonWH, buttonWH);
    [self.view addSubview:_notificationsButton];

    
    
    
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
            _websiteUrl = [NSString stringWithFormat:@"%@",[obj objectForKey:@"website"]];
            _mapUrl = [NSString stringWithFormat:@"%@",[obj objectForKey:@"map"]];
            _contactNumber = [NSString stringWithFormat:@"%@",[obj objectForKey:@"contact_number"]];
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    // Change button color
    _sidebarButton.tintColor = [UIColor whiteColor];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self styleNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    _homeViewController.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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

-(void)styleNavigationBar {
    UIColor* color = [UIColor colorWithRed:0.071 green:0.075 blue:0.078 alpha:1];
    
    self.navigationController.navigationBar.barTintColor = color;
    
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName : [UIColor whiteColor],
      };
    
    self.navigationController.navigationBar.translucent = YES;
}

- (IBAction)callUsBtn:(UIButton *)sender {
    NSString *contactNumber = _contactNumber;
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",contactNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert;
        calert = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"Call not supported on this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [calert show];
    }
    
}

- (IBAction)findUsBtn:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_mapUrl]];
}
@end
