//
//  STAConnectionsViewController.m
//  StealthAttack
//
//  Created by Ronald Lee on 8/23/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAConnectionsViewController.h"
#import "STAAppDelegate.h"


@interface STAConnectionsViewController ()

@property (nonatomic, strong) STAAppDelegate *appDelegate;

//@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;

@end

@implementation STAConnectionsViewController

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
    
    NSString * playFont = @"Press Start 2P";
    
    _btnBack.titleLabel.font = [UIFont fontWithName:playFont size:8];
    _btnBrowse.titleLabel.font = [UIFont fontWithName:playFont size:10];
    _btnDisconnect.titleLabel.font = [UIFont fontWithName:playFont size:10];
    
    [_txtName setDelegate:self];
    [_txtName setText:[[UIDevice currentDevice] name]];
    

    
    _appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    [_appDelegate.mcManager resetMC];
    
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[_appDelegate mcManager] advertiseSelf:true];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(peerDidChangeStateWithNotification:)
//                                                 name:@"MCDidChangeStateNotification"
//                                               object:nil];
//    
//    _arrConnectedDevices = [[NSMutableArray alloc] init];
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

- (IBAction)browseForDevices:(id)sender {
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    
    [[_appDelegate mcManager] setupMCBrowser];
    
    [[[_appDelegate mcManager] browser] setDelegate:self];
    
    [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
}

- (IBAction)disconnect:(id)sender {
    [_appDelegate.mcManager.session disconnect];
    
    _txtName.enabled = YES;
    
//    [_arrConnectedDevices removeAllObjects];
}

- (IBAction)back:(id)sender {
//    UIStoryboard *storyboard = [STAAppUtil getStoryboard];
//    UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"STAViewController"];
//    
//    [self presentViewController:viewController animated:NO completion:NULL];
    
//    [self dismissModalViewControllerAnimated:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//===== browser delegate
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}
//======

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtName resignFirstResponder];
    
//    _appDelegate.mcManager.peerID = nil;
//    _appDelegate.mcManager.session = nil;
//    _appDelegate.mcManager.browser = nil;
    
    [_appDelegate.mcManager.advertiser stop];
    
//    _appDelegate.mcManager.advertiser = nil;
    
    
    [_appDelegate.mcManager setupPeerAndSessionWithDisplayName:_txtName.text];
    [_appDelegate.mcManager setupMCBrowser];
    [_appDelegate.mcManager advertiseSelf:true];
    
    return YES;
}

//-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
//    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
//    NSString *peerDisplayName = peerID.displayName;
//    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
//    
//    if (state != MCSessionStateConnecting) {
//        if (state == MCSessionStateConnected) {
//            [_arrConnectedDevices addObject:peerDisplayName];
//            
//        }
//        else if (state == MCSessionStateNotConnected){
//            if ([_arrConnectedDevices count] > 0) {
//                int indexOfPeer = [_arrConnectedDevices indexOfObject:peerDisplayName];
//                [_arrConnectedDevices removeObjectAtIndex:indexOfPeer];
//            }
//        }
//        
//        BOOL isPeersExist = ([[_appDelegate.mcManager.session connectedPeers] count] > 0);
//        [_btnDisconnect setEnabled:isPeersExist];
//        [_txtName setEnabled:!isPeersExist];
//    }
//}

//=== Table DataSource delegate functions

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [_arrConnectedDevices count];
//}
//
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
//    }
//    
//    cell.textLabel.text = [_arrConnectedDevices objectAtIndex:indexPath.row];
//    
//    return cell;
//}

//====


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

@end
