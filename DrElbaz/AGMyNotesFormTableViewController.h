//
//  AGMyNotesFormTableViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 10/29/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGGlobalVars.h"

@interface AGMyNotesFormTableViewController : UITableViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate>
- (IBAction)addPhoto:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) AGGlobalVars *globals;

- (IBAction)saveButton:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UITextField *commentField;

@end
