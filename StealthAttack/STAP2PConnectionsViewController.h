//
//  STAP2PConnectionsViewController.h
//  StealthAttack
//
//  Created by Ronald Lee on 11/1/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STASessionController.h"

@interface STAP2PConnectionsViewController : UIViewController <STASessionControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *selectedDeviceLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnConnect;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITableView *devicesTableView;
@property (weak, nonatomic) IBOutlet UITextField *deviceName;


- (IBAction)connectDevice:(id)sender;
- (IBAction)back:(id)sender;

@end
