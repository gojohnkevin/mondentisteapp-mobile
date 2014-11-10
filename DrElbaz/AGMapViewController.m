//
//  AGMapViewController.m
//  DrElbaz
//
//  Created by Kevin Go on 7/18/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGMapViewController.h"
#import "AGGlobalVars.h"
#import "AFHTTPRequestOperationManager.h"

@interface AGMapViewController ()

@end

@implementation AGMapViewController

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
    
    _globals = [AGGlobalVars sharedInstance];
    
    self.title = @"Map";
    self.addressLocationMap.mapType = MKMapTypeHybrid;
    
    NSString *userLocationURL = [NSString stringWithFormat:@"%@/api/v1/location/?format=json&username=%@&user__username=%@", _globals.siteURL, _globals.username, _globals.username];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *oauthAccessToken = [NSString stringWithFormat:@"OAuth %@", _globals.accessToken];
    [manager.requestSerializer setValue:oauthAccessToken forHTTPHeaderField:@"Authorization"];
    [manager GET:userLocationURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        NSArray *userLocation = [jsonDict objectForKey:@"objects"];
        
        [userLocation enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop){
            NSString *address = [NSString stringWithFormat:@"%@",[obj objectForKey:@"address"]];
            
            CLLocationCoordinate2D coord;
            coord.latitude = [[obj objectForKey:@"latitude"] doubleValue];
            coord.longitude = [[obj objectForKey:@"longitude"] doubleValue];
            MKCoordinateSpan span = {.latitudeDelta= 0.002, .longitudeDelta= 0.002};
            MKCoordinateRegion region = {coord, span};
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:coord];
            [annotation setTitle:address];
            
            
            [self.addressLocationMap setRegion:region];
            [self.addressLocationMap addAnnotation:annotation];

            
        }];
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    // Do any additional setup after loading the view.
    
    [self styleNavigationBar];
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
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (IBAction)closeModalbtn:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
