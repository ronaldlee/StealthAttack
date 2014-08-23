//
//  STAConnectionsViewController.h
//  StealthAttack
//
//  Created by Ronald Lee on 8/23/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STAConnectionsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UISwitch *swVisible;
@property (weak, nonatomic) IBOutlet UITableView *tblConnectedDevices;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;


- (IBAction)browseForDevices:(id)sender;
- (IBAction)toggleVisibility:(id)sender;
- (IBAction)disconnect:(id)sender;

@end
