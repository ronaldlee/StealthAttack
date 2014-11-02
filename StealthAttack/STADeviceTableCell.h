//
//  STADeviceTableCell.h
//  StealthAttack
//
//  Created by Ronald Lee on 11/2/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STADeviceTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *deviceNameLabel;
@property (nonatomic,strong) MCPeerID* peerID;

@end
