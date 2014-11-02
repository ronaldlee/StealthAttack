//
//  STAP2PConnectionsViewController.m
//  StealthAttack
//
//  Created by Ronald Lee on 11/1/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAP2PConnectionsViewController.h"
#import "STADeviceTableCell.h"

@interface STAP2PConnectionsViewController ()
@property (nonatomic, strong) STASessionController *sessionController;
@property (nonatomic, strong) MCPeerID * selectedPeerID;
@end

@implementation STAP2PConnectionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _sessionController = [[STASessionController alloc] init];
    self.sessionController.delegate = self;
    
    [self.deviceName setText:self.sessionController.displayName];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)sessionDidChangeState
{
    // Ensure UI updates occur on the main queue.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.devicesTableView reloadData];
    });
}

- (IBAction)connectDevice:(id)sender {
    if (self.selectedPeerID == NULL) {
        return;
    }
    
    [self.sessionController invitePeer:self.selectedPeerID];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"ronn select row");
    
//    SongTableCell* cell = (SongTableCell*)[searchResultTable cellForRowAtIndexPath:indexPath];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ (NSMutableArray*)self.sessionController.discoveredPeers count ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STADeviceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STADeviceTableCell"];
    
    MCPeerID * peerID = (MCPeerID*)[[self.sessionController.discoveredPeers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.deviceNameLabel.text = peerID.displayName;
    
    return cell;
}

@end
