//
//  STAMainMenu.m
//  StealthAttack
//
//  Created by Ronald Lee on 7/12/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAMainMenu.h"
//@interface STAMainMenu () {
//    
//}
//@end

@implementation STAMainMenu

@synthesize title1;
@synthesize title2;

@synthesize singlePlayerButton;
@synthesize multiPlayerButton;

- (id)initWithScale:(float)sk_scale Bounds:(CGRect)bounds Scene:(SKScene*)sk_scene {
    self = [super initWithScale:sk_scale Bounds:bounds Scene:sk_scene];
    
    if (self) {
        
        //init colors:
        TANK_BODY_WHITE = [UIColor whiteColor];
        TANK_BODY_BASE_WHITE = [UIColor whiteColor];
        
        TANK_BODY_GREEN = [UIColor greenColor];
        TANK_BODY_BASE_GREEN = [UIColor colorWithRed:(70.0f/255.0f) green:(130.0f/255.0f) blue:(17.0f/255.0f) alpha:1.0];
        
        TANK_BODY_RED = [UIColor redColor];
        TANK_BODY_BASE_RED = [UIColor colorWithRed:(157.0f/255.0f) green:(28.0f/255.0f) blue:(28.0f/255.0f) alpha:1.0];
        
        TANK_BODY_YELLOW = [UIColor yellowColor];
        TANK_BODY_BASE_YELLOW = [UIColor colorWithRed:(186.0f/255.0f) green:(184.0f/255.0f) blue:(4.0f/255.0f) alpha:1.0];
        
        TANK_BODY_BLUE = [UIColor blueColor];
        TANK_BODY_BASE_BLUE = [UIColor colorWithRed:(4.0f/255.0f) green:(45.0f/255.0f) blue:(144.0f/255.0f) alpha:1.0];
        
        //
        
        NSString * titleFont = @"GridExerciseGaps";
        //NSString * titleFont = @"Phaser Bank";
//        NSString * titleFont = @"TRON";
        
        
        //title1 = [SKLabelNode labelNodeWithFontNamed:@"Press Start 2P"];
        //title1 = [SKLabelNode labelNodeWithFontNamed:@"Librium"];
        title1 = [SKLabelNode labelNodeWithFontNamed:titleFont];
        
        NSString *title1Str = @"STEALTH";
        title1.text = title1Str;
        title1.fontSize = 28*GAME_AREA_SCALE;
        title1.fontColor = [SKColor whiteColor];
        title1.alpha = 0;
        
        CGFloat title_x = ([[UIScreen mainScreen] bounds].size.width)/2;
        CGFloat title_y = bounds.origin.y + bounds.size.height - 100*GAME_AREA_SCALE;   //[[UIScreen mainScreen] bounds].size.height - 100;
        
        title1.position = CGPointMake(title_x,title_y);
        
        [self.scene addChild:title1];
        
        SKAction * fadein = [SKAction fadeInWithDuration:0.5];
        [title1 runAction:fadein];
        
        //
        title2 = [SKLabelNode labelNodeWithFontNamed:titleFont];
        
        NSString *title2Str = @"ATTACK";
        title2.text = title2Str;
        title2.fontSize = 28*GAME_AREA_SCALE;
        title2.fontColor = [SKColor whiteColor];
        title2.alpha = 0;
        
        title_y = title_y - 50*GAME_AREA_SCALE;
        
        title2.position = CGPointMake(title_x,title_y);
        
        [self.scene addChild:title2];
        
        [title2 runAction:fadein];
        
        //
        CGSize button_size = CGSizeMake(150*GAME_AREA_SCALE,30*GAME_AREA_SCALE);
//        NSString* playFont = @"GridExerciseGaps";
        NSString * playFont = @"Press Start 2P";
        int font_size = 8*GAME_AREA_SCALE;
        
        singlePlayerButton = [[STAButton alloc] initWithSize:button_size
                                                 Scale:GAME_AREA_SCALE
                                                  Name:@"singleplay_button" Alpha:0.0 BGAlpha:0.0
                                                  ButtonText:@"single player"
                                       ButtonTextColor:[SKColor whiteColor] ButtonTextFont:playFont
                                          ButtonTextFontSize:font_size isShowBorder:true];
        singlePlayerButton.userInteractionEnabled = NO;
//        singlePlayerButton.position = CGPointMake(singlePlayer.position.x - (singlePlayer.frame.size.width/2) -
//                                                  (button_size.width-singlePlayer.frame.size.width)/2,
//                                                  
//                                                  singlePlayer.position.y - (singlePlayer.frame.size.height/2) -
//                                                  (button_size.height-singlePlayer.frame.size.height)/2);
        title_y = (BOTTOM_HUD_HEIGHT + 150)*GAME_AREA_SCALE;
        singlePlayerButton.position = CGPointMake(title_x-button_size.width/2,title_y);
        
        [self.scene addChild:singlePlayerButton];
        
        //
        
        //button_size = CGSizeMake(multiPlayer.frame.size.width*2,multiPlayer.frame.size.height*3);
        
        multiPlayerButton = [[STAButton alloc] initWithSize:button_size
                                                       Scale:GAME_AREA_SCALE
                                                        Name:@"multiplay_button" Alpha:0.0 BGAlpha:0.0
                                                 ButtonText:@"multi player"
                                             ButtonTextColor:[SKColor whiteColor] ButtonTextFont:playFont ButtonTextFontSize:font_size isShowBorder:true];
        multiPlayerButton.userInteractionEnabled = NO;
        title_y = (BOTTOM_HUD_HEIGHT + 80)*GAME_AREA_SCALE;
        multiPlayerButton.position = CGPointMake(title_x-button_size.width/2,title_y);
        
        [self.scene addChild:multiPlayerButton];
        
//        SKAction * hideSinglePlayer = [SKAction runBlock:^(void) {
//            singlePlayer.alpha = 0;
//        }];
//        SKAction * showSinglePlayer = [SKAction runBlock:^(void) {
//            singlePlayer.alpha = 1;
//        }];
//        
//        SKAction *wait = [SKAction waitForDuration:0.7];
//        SKAction *wait_longer = [SKAction waitForDuration:5];
//        [singlePlayer runAction:[SKAction sequence:@[wait_longer,[SKAction repeatActionForever:[SKAction sequence:@[wait,hideSinglePlayer,wait,showSinglePlayer]]]]]];

    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self.scene];
        SKNode *node = [self.scene nodeAtPoint:location];
        
        if ([node.name isEqualToString:@"singleplay_button"]) {
            NSLog(@"single player!!");
            //go to single player menu: select opponents:
            //beat the first 3 and unlock more
            
            STAMyScene* myScene = (STAMyScene*)self.scene;
            
            [myScene.currStage cleanup];
            
            myScene.currStage = [[STASinglePlayerSelectOpponent alloc ]
                                 initWithScale:self.scale Bounds:self.bounds Scene:self.scene];
        }
        else if ([node.name isEqualToString:@"multiplay_button"]) {
            
            STAMyScene* myScene = (STAMyScene*)self.scene;
            
            //UIStoryboard *storyboard = [STAAppUtil getStoryboard];
            //UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"STAConnectionsViewController"];
            
            // Present Log In View Controller
            //[myScene.viewController presentViewController:viewController animated:NO completion:NULL];
            
            [myScene.viewController performSegueWithIdentifier:@"MultiPlayerModal" sender:self];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)cleanup {
    
    NSArray* objs = [NSArray arrayWithObjects:title1,title2,singlePlayerButton,multiPlayerButton,nil];
    
    [self.scene removeChildrenInArray:objs];
}

@end
