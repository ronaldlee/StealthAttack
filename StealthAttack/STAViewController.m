//
//  STAViewController.m
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAViewController.h"
#import "STAMyScene.h"

@implementation STAViewController

@synthesize scene;

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Remove Banner Ads and reset delegate
    [FlurryAds removeAdFromSpace:@"StealthAttack Top Banner"];
    [FlurryAds setAdDelegate:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Flurry ad
    /**
     * We will show banner and interstitial integrations here. *
     */
    // Register yourself as a delegate for ad callbacks
    [FlurryAds setAdDelegate:self];
//    [FlurryAds enableTestAds:TRUE];
    // 1. Fetch and display banner ads
    [FlurryAds fetchAndDisplayAdForSpace:@"StealthAttack Top Banner" view:self.view size:BANNER_TOP];
    // 2. Fetch fullscreen ads for later display
//    [FlurryAds fetchAdForSpace:@"INTERSTITIAL_MAIN_VC" frame:self.view.frame size:FULLSCREEN];
    //
    
    STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL isPeersExist = ([[appDelegate.mcManager.session connectedPeers] count] > 0);
    
    if (isPeersExist && scene != NULL) {
        
        STAMyScene* myScene = (STAMyScene*) scene;
        [myScene.currStage cleanup];
        
//        CGFloat left_corner_x = BORDER_SIDE_MARGIN;
//        CGFloat top_corner_y = [[UIScreen mainScreen] bounds].size.height - TOP_HUD_HEIGHT;
//        CGFloat right_corner_x = [[UIScreen mainScreen] bounds].size.width - BORDER_SIDE_MARGIN;
//        CGFloat bottom_corner_y = BOTTOM_HUD_HEIGHT;
        
        CGFloat left_corner_x = ([[UIScreen mainScreen] bounds].size.width-GAME_AREA_WIDTH)/2;
        CGFloat top_corner_y = [[UIScreen mainScreen] bounds].size.height - TOP_HUD_HEIGHT*GAME_AREA_SCALE;
        CGFloat right_corner_x = left_corner_x + GAME_AREA_WIDTH;
        CGFloat bottom_corner_y = top_corner_y - GAME_AREA_HEIGHT;
        
        myScene.currStage = [[STAMultiPlayerSelect alloc ]
                             initWithScale:[UIScreen mainScreen].scale
                             Bounds:CGRectMake(left_corner_x,bottom_corner_y,
                                               right_corner_x-left_corner_x,
                                               top_corner_y-bottom_corner_y)
                             Scene:self.scene];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    scene = [STAMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.viewController = self;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
