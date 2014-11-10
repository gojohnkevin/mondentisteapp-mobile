//
//  AGAdminESTableViewController.m
//  DrElbaz
//
//  Created by Kevin Go on 9/23/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGAdminESTableViewController.h"
#import "SWRevealViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AGUtils.h"

@interface AGAdminESTableViewController (){
    bool noResultsToDisplay;
}

@end

@implementation AGAdminESTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRefreshControl];
    [self getLatestSchedules];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    UIImage *logo = [AGUtils imageWithImage:logoImage scaledToSize:CGSizeMake(150, 35)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    _sidebarButton.tintColor = [UIColor whiteColor];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self styleNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestSchedules)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)reloadData {
    [self.tableView reloadData];
    
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
    
}

- (void)getLatestSchedules {
    noResultsToDisplay = NO;
    _globals = [AGGlobalVars sharedInstance];
    _schedule = [[NSDictionary alloc] init];
    _scheduleSectionTitles = [[NSArray alloc] init];
    
    NSString *scheduleListUrl = [NSString stringWithFormat:@"%@/api/v1/emergencyschedule/weekly/", _globals.siteURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *oauthAccessToken = [NSString stringWithFormat:@"OAuth %@", _globals.accessToken];
    [manager.requestSerializer setValue:oauthAccessToken forHTTPHeaderField:@"Authorization"];
    [manager GET:scheduleListUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        _schedule = [jsonDict objectForKey:@"objects"];
        _scheduleSectionTitles = [[_schedule allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        if ([_schedule count] == 0) {
            noResultsToDisplay = YES;
        }
        
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!noResultsToDisplay) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = [UIView new];
        self.tableView.tableFooterView = [[UIView alloc] init];
        return [_scheduleSectionTitles count];
        
    }
    else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = [_scheduleSectionTitles objectAtIndex:section];
    NSArray *sectionSchedules = [_schedule objectForKey:sectionTitle];
    return [sectionSchedules count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_scheduleSectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *sectionTitle = [_scheduleSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionSchedules = [_schedule objectForKey:sectionTitle];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *timeString = [NSString stringWithFormat:@"%@", [[sectionSchedules objectAtIndex:indexPath.row] objectForKey:@"time"]];
    
    [formatter setDateFormat:@"HH':'mm':'ss"];
    NSDate *time = [formatter dateFromString:timeString];
    [formatter setDateFormat:@"HH:mm"];
    NSString *newTime = [formatter stringFromDate:time];
    
    cell.textLabel.text = newTime;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSString *isbooked = [[NSString alloc] init];
    NSString *booked = [NSString stringWithFormat:@"%@", [[sectionSchedules objectAtIndex:indexPath.row] objectForKey:@"is_booked"]];
    
    if ([booked isEqual: @"0"]) {
        isbooked = @"Available";
    }
    else {
        isbooked = @"Not Available";
    }
    
    cell.detailTextLabel.text = isbooked;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:11.0];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_scheduleSectionTitles indexOfObject:title];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(void)styleNavigationBar {
    UIColor* color = [UIColor colorWithRed:0.071 green:0.075 blue:0.078 alpha:1];
    
    self.navigationController.navigationBar.barTintColor = color;
    
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName : [UIColor whiteColor],
      };
    
    self.navigationController.navigationBar.translucent = YES;
}

@end
