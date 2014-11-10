//
//  AGAboutViewController.m
//  Dr Elbaz
//
//  Created by Kevin Go on 7/11/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGAboutViewController.h"
#import "SWRevealViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AGUtils.h"

@interface AGAboutViewController ()

@end

@implementation AGAboutViewController

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
    // Do any additional setup after loading the view.
    
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    UIImage *logo = [AGUtils imageWithImage:logoImage scaledToSize:CGSizeMake(150, 35)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    _globals = [AGGlobalVars sharedInstance];
    
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
            _aboutContent.text = [NSString stringWithFormat:@"%@",[obj objectForKey:@"about"]];
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

- (void)viewDidLayoutSubviews {
    _aboutContent.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
