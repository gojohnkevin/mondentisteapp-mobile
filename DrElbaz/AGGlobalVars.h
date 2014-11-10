//
//  AGGlobalVars.h
//  DrElbaz
//
//  Created by Kevin Go on 7/19/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGGlobalVars : NSObject {
    NSString *_accessToken;
}

+ (AGGlobalVars *)sharedInstance;

//global
@property (strong, nonatomic, readwrite) NSString *deviceToken;
@property (strong, nonatomic, readonly) NSString *kOAuthAccessURL;
@property (strong, nonatomic, readonly) NSString *siteURL;
//dentist
@property (strong, nonatomic, readwrite) NSString *accessToken;
@property (strong, nonatomic,readonly) NSString *kClientID;
@property (strong, nonatomic, readonly) NSString *kClientSecret;
@property (strong, nonatomic, readonly) NSString *username;
@property (strong, nonatomic, readonly) NSString *password;
@property (strong, nonatomic, readonly) NSString *dentistURL;
//patient
@property (strong, nonatomic, readwrite) NSString *patientAccessToken;
@property (strong, nonatomic,readwrite) NSString *kPatientClientID;
@property (strong, nonatomic, readwrite) NSString *kPatientClientSecret;
@property (strong, nonatomic,readwrite) NSString *patientUsername;
@property (strong, nonatomic,readwrite) NSString *patientPassword;
@property (strong, nonatomic,readwrite) NSString *patientURL;
@end
