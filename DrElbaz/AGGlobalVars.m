//
//  AGGlobalVars.m
//  DrElbaz
//
//  Created by Kevin Go on 7/19/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGGlobalVars.h"

@implementation AGGlobalVars

//global
@synthesize deviceToken = _deviceToken;
@synthesize kOAuthAccessURL = _kOAuthAccessURL;
@synthesize siteURL = _siteURL;
//dentist
@synthesize accessToken = _accessToken;
@synthesize kClientID = _kClientID;
@synthesize kClientSecret = _kClientSecret;
@synthesize username = _username;
@synthesize password = _password;
@synthesize dentistURL = _dentistURL;
//patient
@synthesize patientAccessToken = _patientAccessToken;
@synthesize kPatientClientID = _kPatientClientID;
@synthesize kPatientClientSecret = _kPatientClientSecret;
@synthesize patientUsername = _patientUsername;
@synthesize patientPassword = _patientPassword;
@synthesize patientURL = _patientURL;

+ (AGGlobalVars *)sharedInstance {
    static dispatch_once_t onceToken;
    static AGGlobalVars *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[AGGlobalVars alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        //global
        /*
        _kOAuthAccessURL = @"http://127.0.0.1:8000/oauth2/access_token";
        _siteURL = @"http://127.0.0.1:8000";
         */
        _deviceToken = @"";
        _kOAuthAccessURL = @"http://mondentisteapp.com/oauth2/access_token";
        _siteURL = @"http://mondentisteapp.com";
    
        //dentist
        /*
        _accessToken = nil;
        _kClientID = @"73409839e184adcae86c";
        _kClientSecret = @"d8bdb9c70f7115f36e4ab37d290395de12e39ea3";
        _username = @"kevin";
        _password = @"123";
        _dentistURL = @"/api/v1/user/1/";
         */
        
        _accessToken = nil;
        _kClientID = @"56a47bb6247820d9f216";
        _kClientSecret = @"00750b298a9d93887d745d1765fecebe32a34e8d";
        _username = @"jackelbaz";
        _password = @"123456";
        _dentistURL = @"/api/v1/user/3/";
        
        //patient
        _patientAccessToken = nil;
        _kPatientClientID = nil;
        _kPatientClientSecret = nil;
        _patientUsername = nil;
        _patientPassword = nil;
        _patientURL = nil;
        
        
        /*
        _kClientID = @"88fe87cd2af4eb21497c";
        _kClientSecret = @"2f9e0ed675a3a851d7594300524f24c4e8dca382";
        _kOAuthAccessURL = @"http://mondentisteapp.com/oauth2/access_token";
        _siteURL = @"http://mondentisteapp.com";
        
        _username = @"jackelbaz";
        _password = @"123456";
        _dentistURL = @"/api/v1/user/2/";
        */
    }
    return self;
}

@end