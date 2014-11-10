//
//  AGEmergencyScheduleTableViewController.m
//  DrElbaz
//
//  Created by Kevin Go on 8/13/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGEmergencyScheduleTableViewController.h"
#import "SWRevealViewController.h"
#import "AGGlobalVars.h"
#import "AFHTTPRequestOperationManager.h"
#import "AGEmergencyScheduleFormTableViewController.h"
#import "AGUtils.h"

@interface AGEmergencyScheduleTableViewController (){
    bool noResultsToDisplay;
}
@end

@implementation AGEmergencyScheduleTableViewController

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

- (void) getLatestSchedules {
    noResultsToDisplay = NO;
    _globals = [AGGlobalVars sharedInstance];
    _eSchedDetails = [[NSDictionary alloc] init];
    _scheduleSectionTitles = [[NSArray alloc] init];
    
    NSString *eSchedUrl = [NSString stringWithFormat:@"%@/api/v1/emergencyschedule/weekly/?is_booked=false", _globals.siteURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *oauthAccessToken = [NSString stringWithFormat:@"OAuth %@", _globals.accessToken];
    [manager.requestSerializer setValue:oauthAccessToken forHTTPHeaderField:@"Authorization"];
    [manager GET:eSchedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        _eSchedDetails = [jsonDict objectForKey:@"objects"];
        _scheduleSectionTitles = [[_eSchedDetails allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        if ([_eSchedDetails count] == 0) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AGEmergencyScheduleFormTableViewController *formController = [self.storyboard instantiateViewControllerWithIdentifier:@"emergencyScheduleForm"];
    
    NSString *sectionTitle = [_scheduleSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionSchedules = [_eSchedDetails objectForKey:sectionTitle];
    
    NSString *timeString = [NSString stringWithFormat:@"%@", [[sectionSchedules objectAtIndex:indexPath.row] objectForKey:@"time"]];
    NSString *dateString = [NSString stringWithFormat:@"%@", [[sectionSchedules objectAtIndex:indexPath.row] objectForKey:@"date"]];
    id eId = [[sectionSchedules objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    
    [formController setValue:dateString forKey:@"scheduleDate"];
    [formController setValue:timeString forKey:@"scheduleTime"];

    [formController setValue:eId forKey:@"eScheduleId"];
    [[self navigationController] pushViewController:formController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_scheduleSectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = [_scheduleSectionTitles objectAtIndex:section];
    NSArray *sectionSchedules = [_eSchedDetails objectForKey:sectionTitle];
    return [sectionSchedules count];
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *sectionTitle = [_scheduleSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionSchedules = [_eSchedDetails objectForKey:sectionTitle];
    
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
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_scheduleSectionTitles indexOfObject:title];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
