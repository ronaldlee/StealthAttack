//
//  STAConnectionsViewController.h
//  StealthAttack
//
//  Created by Ronald Lee on 8/23/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface STAConnectionsViewController : UIViewController </*MCBrowserViewControllerDelegate, */UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnBrowse;


- (IBAction)browseForDevices:(id)sender;
- (IBAction)disconnect:(id)sender;
- (IBAction)back:(id)sender;

@end
