//
//  AGBookWebViewController.h
//  DrElbaz
//
//  Created by Kevin Go on 9/3/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGBookWebViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *bookWebView;
@property (strong, nonatomic) NSString *webViewUrl;

@end
