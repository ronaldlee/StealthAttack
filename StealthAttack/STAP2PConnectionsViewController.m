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
//@property (nonatomic, strong) STASessionController *sessionController;

@property (nonatomic, strong) STAAppDelegate *appDelegate;

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
    
    
    _appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    _sessionController = [[STASessionController alloc] init];
    
    _appDelegate.mcManager.delegate = self;
    
//    self.sessionController.delegate = self;
    
    self.devicesTableView.delegate = self;
    [self.devicesTableView setDataSource:self];
    
    [_appDelegate.mcManager startServices];
    
    [self.deviceName setText: _appDelegate.mcManager.displayName];    
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
    
    [ _appDelegate.mcManager invitePeer:self.selectedPeerID];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"ronn select row");
    
    STADeviceTableCell* cell = (STADeviceTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    self.selectedPeerID = cell.peerID;
    
    self.selectedDeviceLabel.text = cell.peerID.displayName;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [ (NSMutableArray*)_appDelegate.mcManager.discoveredPeers count ];
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STADeviceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STADeviceTableCell"];
    
    MCPeerID * peerID = (MCPeerID*)[_appDelegate.mcManager.discoveredPeers objectAtIndex:indexPath.row];
    
    cell.deviceNameLabel.text = peerID.displayName;
    cell.peerID = peerID;
    
    return cell;
}

@end
