//
//  STAMultiPlayerSelect.m
//  StealthAttack
//
//  Created by Ronald Lee on 8/23/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAMultiPlayerSelect.h"

@interface STAMultiPlayerSelect () {
    int myTankId;
    int myColorId;
    
    BOOL isStealthOn;
}
@end

@implementation STAMultiPlayerSelect
@synthesize selectOppTitle;
@synthesize selectColorTitle;
@synthesize backLabel;
@synthesize backButton;
@synthesize readyButton;
//@synthesize stealthOnOffButton;
@synthesize oppReadyLabel;
@synthesize oppLeftLabel;
@synthesize errorLabel;

@synthesize enemy1;
@synthesize enemy2;
@synthesize enemy3;
@synthesize enemy4;
@synthesize enemy5;

@synthesize enemy1Button;
@synthesize enemy2Button;
@synthesize enemy3Button;
@synthesize enemy4Button;
@synthesize enemy5Button;

@synthesize color1Button;
@synthesize color2Button;
@synthesize color3Button;
@synthesize color4Button;
@synthesize color5Button;


- (id)initWithScale:(float)sk_scale Bounds:(CGRect)bounds Scene:(SKScene*)sk_scene {
    self = [super initWithScale:sk_scale Bounds:bounds Scene:sk_scene];
    
    if (self) {
//        STAMyScene* myScene = (STAMyScene*)self.scene;
//        [myScene.currStage cleanup];
        
        isStealthOn = IS_ENABLE_STEALTH;
        
        myTankId = -1;
        myColorId = -1;
        
        CGFloat title_x = ([[UIScreen mainScreen] bounds].size.width)/2;
        
        NSString * font = @"Press Start 2P";
        
        selectOppTitle = [SKLabelNode labelNodeWithFontNamed:font];
        
        NSString *singlePlay = @"Select Your Tank";
        selectOppTitle.text = singlePlay;
        selectOppTitle.fontSize = 8*GAME_AREA_SCALE;
        selectOppTitle.fontColor = [SKColor whiteColor];
        
        CGFloat title_y = bounds.origin.y + bounds.size.height - 100*GAME_AREA_SCALE;
        
        selectOppTitle.position = CGPointMake(title_x,title_y);
        selectOppTitle.alpha = 0;
        
        [self.scene addChild:selectOppTitle];
        
        SKAction * fadein = [SKAction fadeInWithDuration:0.5];
        [selectOppTitle runAction:fadein];
      
        
        //
        backLabel = [SKLabelNode labelNodeWithFontNamed:font];
        
        NSString *back = @"<<";
        backLabel.text = back;
        backLabel.fontSize = 8*GAME_AREA_SCALE;
        backLabel.fontColor = [SKColor whiteColor];
        backLabel.name = @"back_label";
        backLabel.alpha = 0;
        
        title_y = bounds.origin.y + bounds.size.height-20*GAME_AREA_SCALE;
        
        backLabel.position = CGPointMake(bounds.origin.x+15*GAME_AREA_SCALE,title_y);

        [self.scene addChild:backLabel];
        [backLabel runAction:fadein];
        
        CGFloat back_button_orig_x =backLabel.position.x;
        
        SKAction * backLabelMoveRight = [SKAction moveToX:back_button_orig_x+5*GAME_AREA_SCALE duration:0.5];
        SKAction * backLabelMoveLeft = [SKAction moveToX:back_button_orig_x duration:0.2];
        
        [backLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[backLabelMoveRight,backLabelMoveLeft]]]];
        
        //
        CGSize button_size = CGSizeMake(30*GAME_AREA_SCALE,20*GAME_AREA_SCALE);
        
        backButton = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"back_button" Alpha:0 BGAlpha:0.0 ButtonText:NULL
                                     ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false];
        backButton.userInteractionEnabled = NO;
        backButton.position = CGPointMake(back_button_orig_x-10*GAME_AREA_SCALE,backLabel.position.y-5*GAME_AREA_SCALE);
        [self.scene addChild:backButton];
        
        //enemies to choose from
        CGFloat left_corner_x = self.bounds.origin.x;
        CGFloat top_corner_y = self.bounds.origin.y+self.bounds.size.height;
        CGFloat right_corner_x = self.bounds.origin.x+self.bounds.size.width;
        CGFloat bottom_corner_y = self.bounds.origin.y;
        
        CGRect bounds = CGRectMake(left_corner_x, bottom_corner_y,
                                   right_corner_x-left_corner_x,
                                   top_corner_y-bottom_corner_y);
        
        
        //==enemies
        //4 enemies per row, 2 rows (total 8 enemies)
        //locked => question mark?
        enemy1 = [[STATank alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:2
                                           BodyColor:TANK_BODY_WHITE
                                       BodyBaseColor:TANK_BODY_BASE_WHITE
                                                  AI:NULL
                                            Category:ENEMY_CATEGORY
                                              Bounds:bounds
                                     IsEnableStealth:IS_ENABLE_STEALTH];
        
        CGFloat stage_start_y = [[UIScreen mainScreen] bounds].size.height-150*GAME_AREA_SCALE;
        
        
        [self.scene addChild:enemy1];
        [enemy1 dance:REGION_MIDDLE_BOTTOM];
        
        //
        enemy2 = [[STAEnemyTank alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:2
                                           BodyColor:TANK_BODY_WHITE
                                       BodyBaseColor:TANK_BODY_BASE_WHITE
                                                  AI:NULL
                                            Category:ENEMY_CATEGORY
                                              Bounds:bounds
                                     IsEnableStealth:IS_ENABLE_STEALTH];
        
        [self.scene addChild:enemy2];
        [enemy2 dance:REGION_MIDDLE_BOTTOM];
        
        //
        enemy3 = [[STAJeep alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:2
                                      BodyColor:TANK_BODY_WHITE
                                  BodyBaseColor:TANK_BODY_BASE_WHITE
                                             AI:NULL
                                       Category:ENEMY_CATEGORY
                                         Bounds:bounds
                                IsEnableStealth:IS_ENABLE_STEALTH];
        
        [self.scene addChild:enemy3];
        [enemy3 dance:REGION_MIDDLE_BOTTOM];
        
        //
        enemy4 = [[STAShotgunTank alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:2
                                             BodyColor:TANK_BODY_WHITE
                                         BodyBaseColor:TANK_BODY_BASE_WHITE
                                                    AI:NULL
                                              Category:ENEMY_CATEGORY
                                                Bounds:bounds
                                       IsEnableStealth:IS_ENABLE_STEALTH];
        
        [self.scene addChild:enemy4];
        [enemy4 dance:REGION_MIDDLE_BOTTOM];
        
        //
        enemy5 = [[STASniperTank alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:2
                                            BodyColor:TANK_BODY_WHITE
                                        BodyBaseColor:TANK_BODY_BASE_WHITE
                                                   AI:NULL
                                             Category:ENEMY_CATEGORY
                                               Bounds:bounds
                                      IsEnableStealth:IS_ENABLE_STEALTH];
        
        [self.scene addChild:enemy5];
        [enemy5 dance:REGION_MIDDLE_BOTTOM];
        
        //
        int diff_between = 40*GAME_AREA_SCALE;
        CGFloat total_width = enemy1.max_width + enemy2.max_width + enemy3.max_width +
                              enemy4.max_width + enemy5.max_width+diff_between*4-10*GAME_AREA_SCALE;
        
        CGFloat stage_start_x = ([[UIScreen mainScreen] bounds].size.width - total_width)/2;
        
        enemy1.position = CGPointMake(stage_start_x,stage_start_y);
        
        stage_start_x = enemy1.position.x + enemy1.max_width + diff_between;
        
        enemy2.position = CGPointMake(stage_start_x,stage_start_y);
        
        stage_start_x = enemy2.position.x + enemy2.max_width + diff_between;
        
        enemy3.position = CGPointMake(stage_start_x,stage_start_y);
        
        stage_start_x = enemy3.position.x + enemy3.max_width + diff_between;
        
        enemy4.position = CGPointMake(stage_start_x,stage_start_y);
        
        stage_start_x = enemy4.position.x + enemy4.max_width + diff_between;
        
        enemy5.position = CGPointMake(stage_start_x,stage_start_y);
        
        //=== enemy selection button
        
        button_size = CGSizeMake(40*GAME_AREA_SCALE,40*GAME_AREA_SCALE);
        enemy1Button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"enemy1_button" Alpha:1.0 BGAlpha:0.0 ButtonText:NULL
                                       ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false];
        enemy1Button.userInteractionEnabled = NO;
        enemy1Button.position = CGPointMake(enemy1.position.x - (enemy1.max_width/2) - (button_size.width-enemy1.max_width)/2,
                                            enemy1.position.y - (enemy1.max_height/2) - (button_size.height-enemy1.max_height)/2);
        [self.scene addChild:enemy1Button];
        
        enemy2Button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"enemy2_button" Alpha:1.0 BGAlpha:0.0 ButtonText:NULL
                                       ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false];
        enemy2Button.userInteractionEnabled = NO;
        enemy2Button.position = CGPointMake(enemy2.position.x - (enemy2.max_width/2) - (button_size.width-enemy2.max_width)/2,
                                            enemy2.position.y - (enemy2.max_height/2) - (button_size.height-enemy2.max_height)/2);
        [self.scene addChild:enemy2Button];
        
        enemy3Button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"enemy3_button" Alpha:1.0 BGAlpha:0.0 ButtonText:NULL
                                       ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false];
        enemy3Button.userInteractionEnabled = NO;
        enemy3Button.position = CGPointMake(enemy3.position.x - (enemy3.max_width/2) - (button_size.width-enemy3.max_width)/2,
                                            enemy3.position.y - (enemy3.max_height/2) - (button_size.height-enemy3.max_height)/2);
        [self.scene addChild:enemy3Button];
        
        enemy4Button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"enemy4_button" Alpha:1.0 BGAlpha:0.0 ButtonText:NULL
                                       ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false];
        enemy4Button.userInteractionEnabled = NO;
        enemy4Button.position = CGPointMake(enemy4.position.x - (enemy4.max_width/2) - (button_size.width-enemy4.max_width)/2,
                                            enemy4.position.y - (enemy4.max_height/2) - (button_size.height-enemy4.max_height)/2);
        [self.scene addChild:enemy4Button];
        
        enemy5Button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"enemy5_button" Alpha:1.0 BGAlpha:0.0 ButtonText:NULL
                                       ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false];
        enemy5Button.userInteractionEnabled = NO;
        enemy5Button.position = CGPointMake(enemy5.position.x - (enemy5.max_width/2) - (button_size.width-enemy5.max_width)/2,
                                            enemy5.position.y - (enemy5.max_height/2) - (button_size.height-enemy5.max_height)/2);
        [self.scene addChild:enemy5Button];
        //
        
        button_size = CGSizeMake(40*GAME_AREA_SCALE,40*GAME_AREA_SCALE);
        color1Button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"color1_button" Alpha:1.0 BGAlpha:1.0 ButtonText:NULL
                                       ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false BGColor:[UIColor whiteColor]];
        color1Button.userInteractionEnabled = NO;
        [self.scene addChild:color1Button];
        
        color2Button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"color2_button" Alpha:1.0 BGAlpha:1.0 ButtonText:NULL
                                       ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false BGColor:[UIColor blueColor]];
        color2Button.userInteractionEnabled = NO;
        [self.scene addChild:color2Button];
        
        color3Button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"color3_button" Alpha:1.0 BGAlpha:1.0 ButtonText:NULL
                                       ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false BGColor:[UIColor greenColor]];
        color3Button.userInteractionEnabled = NO;
        [self.scene addChild:color3Button];
        
        color4Button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"color4_button" Alpha:1.0 BGAlpha:1.0 ButtonText:NULL
                                       ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false BGColor:[UIColor redColor]];
        color4Button.userInteractionEnabled = NO;
        [self.scene addChild:color4Button];

        color5Button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"color5_button" Alpha:1.0 BGAlpha:1.0 ButtonText:NULL
                                       ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false BGColor:[UIColor yellowColor]];
        color5Button.userInteractionEnabled = NO;
        [self.scene addChild:color5Button];
        
        diff_between=5*GAME_AREA_SCALE;
        total_width = 40*5*GAME_AREA_SCALE+diff_between*4-10*GAME_AREA_SCALE;
        
        stage_start_x = ([[UIScreen mainScreen] bounds].size.width - total_width)/2;
        color1Button.position = CGPointMake(stage_start_x,
                                            enemy1Button.position.y - 200*GAME_AREA_SCALE);
        color2Button.position = CGPointMake(color1Button.position.x+40*GAME_AREA_SCALE+diff_between,
                                            color1Button.position.y);
        color3Button.position = CGPointMake(color2Button.position.x+40*GAME_AREA_SCALE+diff_between,
                                            color1Button.position.y);
        color4Button.position = CGPointMake(color3Button.position.x+40*GAME_AREA_SCALE+diff_between,
                                            color1Button.position.y);
        color5Button.position = CGPointMake(color4Button.position.x+40*GAME_AREA_SCALE+diff_between,
                                            color1Button.position.y);
        
        //
        selectColorTitle = [SKLabelNode labelNodeWithFontNamed:font];
        
        selectColorTitle.text = @"Select Color";
        selectColorTitle.fontSize = 8*GAME_AREA_SCALE;
        selectColorTitle.fontColor = [SKColor whiteColor];
        
        title_y = title_y - 100;
        
        selectColorTitle.position = CGPointMake(title_x,color1Button.position.y +50*GAME_AREA_SCALE);
        selectColorTitle.alpha = 0;
        
        [self.scene addChild:selectColorTitle];
        
        [selectColorTitle runAction:fadein];
        
        //
        button_size = CGSizeMake(150*GAME_AREA_SCALE,30*GAME_AREA_SCALE);
        
        readyButton = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"ready_button"
                                                Alpha:0
                                              BGAlpha:0.0 ButtonText:@"Ready"
                                      ButtonTextColor:[UIColor whiteColor]
                                       ButtonTextFont:@"Press Start 2P"
                                   ButtonTextFontSize:10 isShowBorder:false
                                              BGColor:[UIColor whiteColor]
                                     ButtonTextVAlign:BUTTON_TEXT_MIDDLE];
        readyButton.userInteractionEnabled = NO;
        readyButton.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width - button_size.width)/2,
                                           color1Button.position.y - 80*GAME_AREA_SCALE);
        
        readyButton.alpha = 1.0;
        [self.scene addChild:readyButton];
        
        //
        oppReadyLabel = [SKLabelNode labelNodeWithFontNamed:font];
        NSString *oppReady = @"Your opponent is ready!";
        oppReadyLabel.text = oppReady;
        oppReadyLabel.fontSize = 8*GAME_AREA_SCALE;
        oppReadyLabel.fontColor = [SKColor grayColor];
        oppReadyLabel.name = @"oppready_label";
        oppReadyLabel.alpha = 0.0;
        
        oppReadyLabel.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width)/2,
                                             readyButton.position.y + oppReadyLabel.frame.size.height + 40*GAME_AREA_SCALE);
        
        [self.scene addChild:oppReadyLabel];
        
        //
        oppLeftLabel = [SKLabelNode labelNodeWithFontNamed:font];
        NSString *oppLeft = @"Your opponent has left!";
        oppLeftLabel.text = oppLeft;
        oppLeftLabel.fontSize = 8*GAME_AREA_SCALE;
        oppLeftLabel.fontColor = [SKColor grayColor];
        oppLeftLabel.name = @"oppready_label";
        oppLeftLabel.alpha = 0.0;
        
        oppLeftLabel.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width)/2,
                                             readyButton.position.y + oppLeftLabel.frame.size.height + 40*GAME_AREA_SCALE);
        
        [self.scene addChild:oppLeftLabel];
    
//        oppLeftLabel.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width)/2,
//                                            readyButton.position.y);
        
        //
        
        errorLabel = [SKLabelNode labelNodeWithFontNamed:font];
        NSString *errorTxt = @"You need to select a tank and a color!";
        errorLabel.text = errorTxt;
        errorLabel.fontSize = 8*GAME_AREA_SCALE;
        errorLabel.fontColor = [SKColor grayColor];
        errorLabel.name = @"error_label";
        errorLabel.alpha = 0.0;
        
        errorLabel.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width)/2,
                                             selectOppTitle.position.y + errorLabel.frame.size.height +
                                          30*GAME_AREA_SCALE);
        [self.scene addChild:errorLabel];
        
        //
        button_size = CGSizeMake(30*GAME_AREA_SCALE,20*GAME_AREA_SCALE);
        
//        stealthOnOffButton = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"stealth_button" Alpha:0 BGAlpha:0.0 ButtonText:@"Stealth"
//                                      ButtonTextColor:[UIColor whiteColor] ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:8 isShowBorder:true];
//        stealthOnOffButton.userInteractionEnabled = NO;
//        stealthOnOffButton.position = CGPointMake(readyButton.position.x +
//                                                  readyButton.size.width+30*GAME_AREA_SCALE,
//                                                  readyButton.position.y);
//        [self.scene addChild:stealthOnOffButton];
        
        //
        STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];        
        [appDelegate.mcManager setStage:MULTIPLAY_STAGE_CHOOSE_TANK];
        [appDelegate.mcManager setStageObj:self];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"single opponent screen touched");
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self.scene];
        SKNode *node = [self.scene nodeAtPoint:location];
        
        if ([node.name isEqualToString:@"back_button"]) {
            STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.mcManager sendMultiPlaySelectBack];
            
            [appDelegate.mcManager reset];
            
            //======
            STAMyScene* myScene = (STAMyScene*)self.scene;
            
            [myScene.currStage cleanup];
            
            myScene.currStage = [[STAMainMenu alloc ]
                                 initWithScale:self.scale Bounds:self.bounds Scene:self.scene];
        }
        else if ([node.name isEqualToString:@"enemy1_button"]) {
//            NSLog(@"enemy1_button");
            
            [enemy1Button showBorder:true];
            [enemy2Button showBorder:false];
            [enemy3Button showBorder:false];
            [enemy4Button showBorder:false];
            [enemy5Button showBorder:false];
            
            if (myColorId == 2) {
                [enemy1 setBodyColor:TANK_BODY_BLUE BaseColor:TANK_BODY_BASE_BLUE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myColorId == 3) {
                [enemy1 setBodyColor:TANK_BODY_GREEN BaseColor:TANK_BODY_BASE_GREEN];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myColorId == 4) {
                [enemy1 setBodyColor:TANK_BODY_RED BaseColor:TANK_BODY_BASE_RED];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myColorId == 5) {
                [enemy1 setBodyColor:TANK_BODY_YELLOW BaseColor:TANK_BODY_BASE_YELLOW];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            
            myTankId = 1;
        }
        else if ([node.name isEqualToString:@"enemy2_button"]) {
//            NSLog(@"enemy2_button");
            
            [enemy1Button showBorder:false];
            [enemy2Button showBorder:true];
            [enemy3Button showBorder:false];
            [enemy4Button showBorder:false];
            [enemy5Button showBorder:false];
            
            if (myColorId == 2) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_BLUE BaseColor:TANK_BODY_BASE_BLUE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myColorId == 3) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_GREEN BaseColor:TANK_BODY_BASE_GREEN];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myColorId == 4) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_RED BaseColor:TANK_BODY_BASE_RED];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myColorId == 5) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_YELLOW BaseColor:TANK_BODY_BASE_YELLOW];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            
            myTankId = 2;
        }
        else if ([node.name isEqualToString:@"enemy3_button"]) {
//            NSLog(@"enemy3_button");
            
            [enemy1Button showBorder:false];
            [enemy2Button showBorder:false];
            [enemy3Button showBorder:true];
            [enemy4Button showBorder:false];
            [enemy5Button showBorder:false];
            
            if (myColorId == 2) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_BLUE BaseColor:TANK_BODY_BASE_BLUE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myColorId == 3) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_GREEN BaseColor:TANK_BODY_BASE_GREEN];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myColorId == 4) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_RED BaseColor:TANK_BODY_BASE_RED];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myColorId == 5) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_YELLOW BaseColor:TANK_BODY_BASE_YELLOW];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            
            myTankId = 3;
        }
        else if ([node.name isEqualToString:@"enemy4_button"]) {
//            NSLog(@"enemy4_button");
            
            [enemy1Button showBorder:false];
            [enemy2Button showBorder:false];
            [enemy3Button showBorder:false];
            [enemy4Button showBorder:true];
            [enemy5Button showBorder:false];
            
            if (myColorId == 2) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_BLUE BaseColor:TANK_BODY_BASE_BLUE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myColorId == 3) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_GREEN BaseColor:TANK_BODY_BASE_GREEN];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myColorId == 4) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_RED BaseColor:TANK_BODY_BASE_RED];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myColorId == 5) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_YELLOW BaseColor:TANK_BODY_BASE_YELLOW];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            
            myTankId = 4;
        }
        else if ([node.name isEqualToString:@"enemy5_button"]) {
//            NSLog(@"enemy5_button");
            
            [enemy1Button showBorder:false];
            [enemy2Button showBorder:false];
            [enemy3Button showBorder:false];
            [enemy4Button showBorder:false];
            [enemy5Button showBorder:true];
            
            if (myColorId == 2) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_BLUE BaseColor:TANK_BODY_BASE_BLUE];
            }
            else if (myColorId == 3) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_GREEN BaseColor:TANK_BODY_BASE_GREEN];
            }
            else if (myColorId == 4) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_RED BaseColor:TANK_BODY_BASE_RED];
            }
            else if (myColorId == 5) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_YELLOW BaseColor:TANK_BODY_BASE_YELLOW];
            }
            else {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            
            myTankId = 5;
        }
        else if ([node.name isEqualToString:@"color1_button"]) {
            myColorId = 1;
            [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
        }
        else if ([node.name isEqualToString:@"color2_button"]) {
            myColorId = 2;
            
            if (myTankId == 2) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_BLUE BaseColor:TANK_BODY_BASE_BLUE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myTankId == 3) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_BLUE BaseColor:TANK_BODY_BASE_BLUE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myTankId == 4) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_BLUE BaseColor:TANK_BODY_BASE_BLUE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myTankId == 5) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_BLUE BaseColor:TANK_BODY_BASE_BLUE];
            }
            else {
                [enemy1 setBodyColor:TANK_BODY_BLUE BaseColor:TANK_BODY_BASE_BLUE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
           
        }
        else if ([node.name isEqualToString:@"color3_button"]) {
            myColorId = 3;
            
            if (myTankId == 2) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_GREEN BaseColor:TANK_BODY_BASE_GREEN];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myTankId == 3) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_GREEN BaseColor:TANK_BODY_BASE_GREEN];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myTankId == 4) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_GREEN BaseColor:TANK_BODY_BASE_GREEN];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myTankId == 5) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_GREEN BaseColor:TANK_BODY_BASE_GREEN];
            }
            else {
                [enemy1 setBodyColor:TANK_BODY_GREEN BaseColor:TANK_BODY_BASE_GREEN];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
        }
        else if ([node.name isEqualToString:@"color4_button"]) {
            myColorId = 4;
            
            if (myTankId == 2) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_RED BaseColor:TANK_BODY_BASE_RED];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myTankId == 3) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_RED BaseColor:TANK_BODY_BASE_RED];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myTankId == 4) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_RED BaseColor:TANK_BODY_BASE_RED];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myTankId == 5) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_RED BaseColor:TANK_BODY_BASE_RED];
            }
            else {
                [enemy1 setBodyColor:TANK_BODY_RED BaseColor:TANK_BODY_BASE_RED];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
        }
        else if ([node.name isEqualToString:@"color5_button"]) {
            myColorId = 5;
            
            if (myTankId == 2) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_YELLOW BaseColor:TANK_BODY_BASE_YELLOW];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myTankId == 3) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_YELLOW BaseColor:TANK_BODY_BASE_YELLOW];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myTankId == 4) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_YELLOW BaseColor:TANK_BODY_BASE_YELLOW];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
            else if (myTankId == 5) {
                [enemy1 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_YELLOW BaseColor:TANK_BODY_BASE_YELLOW];
            }
            else {
                [enemy1 setBodyColor:TANK_BODY_YELLOW BaseColor:TANK_BODY_BASE_YELLOW];
                [enemy2 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy3 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy4 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
                [enemy5 setBodyColor:TANK_BODY_WHITE BaseColor:TANK_BODY_BASE_WHITE];
            }
        }
        else if ([node.name isEqualToString:@"ready_button"] && [readyButton isEnabled]) {
//            NSLog(@"Hit ready!: my tankId: %d, myColorId: %d",myTankId,myColorId);
            
            if (myTankId != -1 && myColorId != -1) {
                [readyButton setEnabled:false];
                [readyButton setFontColor:[UIColor blackColor]];
                [readyButton setButtonColor:[UIColor whiteColor]];
                
                STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.mcManager submitPlayerChoiceTank:myTankId Color:myColorId Scale:GAME_AREA_SCALE
                                                  IsStealthOn:isStealthOn];
            }
            else {
                SKAction * fadein = [SKAction fadeInWithDuration:0.5];
                SKAction * fadeout = [SKAction fadeOutWithDuration:0.5];
                SKAction *wait = [SKAction waitForDuration:3];
                
                [errorLabel runAction:[SKAction sequence:@[fadein, wait, fadeout]]];
            }
        }
//        else if ([node.name isEqualToString:@"stealth_button"]) {
//            
//            STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
//            
//            if (isStealthOn) {
//                [stealthOnOffButton setFontColor:[UIColor blackColor]];
//            }
//            else {
//                [stealthOnOffButton setFontColor:[UIColor whiteColor]];
//            }
//            
//            isStealthOn = !isStealthOn;
//        }
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)cleanup {
    
    [selectOppTitle removeAllActions];
    [selectColorTitle removeAllActions];
    [backLabel removeAllActions];
    //    [startLabel removeAllActions];
    [backButton removeAllActions];
    //    [startButton removeAllActions];
    [enemy1Button removeAllActions];
    [enemy1 stop];
    [enemy2Button removeAllActions];
    [enemy2 stop];
    [enemy3Button removeAllActions];
    [enemy3 stop];
    [enemy4Button removeAllActions];
    [enemy4 stop];
    [enemy5Button removeAllActions];
    [enemy5 stop];
    
    [color1Button removeAllActions];
    [color2Button removeAllActions];
    [color3Button removeAllActions];
    [color4Button removeAllActions];
    [color5Button removeAllActions];
    
    [readyButton removeAllActions];
//    [stealthOnOffButton removeAllActions];
    [oppReadyLabel removeAllActions];
    [errorLabel removeAllActions];
    [oppLeftLabel removeAllActions];
    
    
    NSArray* objs = [NSArray arrayWithObjects:selectOppTitle,selectColorTitle,
                     backLabel,backButton,
                     enemy1Button,enemy1,enemy2Button,enemy2,
                     enemy3Button,enemy3,enemy4Button,enemy4,
                     enemy5Button,enemy5,
                     color1Button,color2Button,color3Button,color4Button,color5Button,
                     readyButton/*,stealthOnOffButton*/,oppReadyLabel,errorLabel,oppLeftLabel,nil];
    
    [self.scene removeChildrenInArray:objs];
    
}

-(void)goToBattleStageMyTank:(int)myTankId MyColor:(int)myColorId MyScale:(CGFloat)myScale
                   OppTankId:(int)oppTankId OppColor:(int)oppColorId OppScale:(CGFloat)oppScale
                 IsStealthOn:(BOOL)isStealthOn {
    STAMyScene* myScene = (STAMyScene*)self.scene;
    
    [myScene.currStage cleanup];
    
    myScene.currStage = [[STAMultiPlayBattleStage alloc ]
                         initWithScale:self.scale Bounds:self.bounds Scene:self.scene
                         MyTank:myTankId MyColor:myColorId MyScale:myScale
                         OppTankId:oppTankId OppColor:oppColorId OppScale:oppScale
                         isStealthOn:isStealthOn];
}

-(void)showOppIsReady {
    oppReadyLabel.alpha = 1.0;
    oppLeftLabel.alpha = 0.0;
}

-(void)showOppLeft {
//    NSArray* objs = [NSArray arrayWithObjects:oppReadyLabel,nil];
//    
//    [self.scene removeChildrenInArray:objs];
    
    //remove the Ready button, so you can only go back too!
    oppReadyLabel.alpha = 0.0;
    oppLeftLabel.alpha = 1.0;
    
    NSArray* objs = [NSArray arrayWithObjects:readyButton,nil];
    
    [self.scene removeChildrenInArray:objs];
}

-(BOOL)isReadyButtonPressed{
    return ![readyButton isEnabled];
}

@end
