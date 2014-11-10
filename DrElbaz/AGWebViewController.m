//
//  AGWebViewController.m
//  DrElbaz
//
//  Created by Kevin Go on 7/31/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGWebViewController.h"
#import "AGGlobalVars.h"
#import "SWRevealViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AGUtils.h"

@interface AGWebViewController () {
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation AGWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _viewWeb.delegate = self;
    [self showIndicator];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    UIImage *logo = [AGUtils imageWithImage:logoImage scaledToSize:CGSizeMake(150, 35)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];

    
    _sidebarButton.tintColor = [UIColor whiteColor];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    _globals = [AGGlobalVars sharedInstance];
    
    // Do any additional setup after loading the view.
    
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
            NSString *fullURL = [NSString stringWithFormat:@"%@",[obj objectForKey:@"website"]];
            NSURL *url = [NSURL URLWithString:fullURL];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            [_viewWeb loadRequest:requestObj];
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    //[self stopIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //[self.view viewWithTag:100].hidden = YES;
    [self stopIndicator];
}

- (void)viewDidLayoutSubviews {
    _viewWeb.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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

@end
