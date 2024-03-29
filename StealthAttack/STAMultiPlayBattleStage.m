//
//  STAMultiPlayBattleStage.m
//  StealthAttack
//
//  Created by Ronald Lee on 8/24/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAMultiPlayBattleStage.h"
#import <AudioToolbox/AudioToolbox.h>

@interface STAMultiPlayBattleStage () {
    
    SKLabelNode* countdownLabelNode;
    CGFloat myScale;
    CGFloat oppScale;
    CGFloat ratio;
    
    int myTankId;
    int myColorId;
    int oppTankId;
    int oppColorId;
    BOOL isStealthOn;
    
    BOOL isPlayerSkipStop;
}
@end

@implementation STAMultiPlayBattleStage

@synthesize fire_button;
@synthesize rotate_c_button;
@synthesize rotate_uc_button;
@synthesize forward_button;
@synthesize backward_button;

@synthesize replay_button;
@synthesize back_button;
@synthesize game_over_label;

@synthesize playerFadeNode;
@synthesize enemyFadeNode;
@synthesize playerAdjNode;

@synthesize isGameOver;
@synthesize isGameStart;
@synthesize oppRematchLabel;
@synthesize shotSound;

- (id)initWithScale:(float)sk_scale Bounds:(CGRect)bounds Scene:(SKScene*)sk_scene
             MyTank:(int)p_myTankId MyColor:(int)p_myColorId MyScale:(CGFloat)p_myScale
          OppTankId:(int)p_oppTankId OppColor:(int)p_oppColorId OppScale:(CGFloat)p_oppScale
        isStealthOn:(BOOL)p_isStealthOn{
    
    self = [super initWithScale:sk_scale Bounds:bounds Scene:sk_scene];
    
    if (self) {
        NSString *shotSoundPath = [[NSBundle mainBundle]
                                   pathForResource:@"shot" ofType:@"aiff"];
        NSURL *shotSoundURL = [NSURL fileURLWithPath:shotSoundPath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)shotSoundURL, &shotSound);
        
        myTankId = p_myTankId;
        myColorId = p_myColorId;
        myScale = p_myScale;
        oppTankId = p_oppTankId;
        oppColorId = p_oppColorId;
        oppScale = p_oppScale;
        isStealthOn = p_isStealthOn;
        
        ratio = myScale/oppScale;
        
        isGameStart= false;
        isGameOver = false;
        playerFadeNode = [[SKNode alloc] init];
        [self.scene addChild:playerFadeNode];
        enemyFadeNode = [[SKNode alloc] init];
        [self.scene addChild:enemyFadeNode];
        
        playerAdjNode = [[SKNode alloc] init];
        [self.scene addChild:playerAdjNode];
        
        //==
        
        CGSize button_size = CGSizeMake(50*GAME_AREA_SCALE,50*GAME_AREA_SCALE);
        
        CGFloat left_corner_x = self.bounds.origin.x;
        CGFloat top_corner_y = self.bounds.origin.y+self.bounds.size.height;
        CGFloat right_corner_x = self.bounds.origin.x+self.bounds.size.width;
        CGFloat bottom_corner_y = self.bounds.origin.y;
        
        fire_button = [[STAButton alloc] initWithSize:button_size
                                                Scale:GAME_AREA_SCALE
                                                 Name:@"fire_button" Alpha:1 BGAlpha:1.0 ButtonText:@"FIRE" ButtonTextColor:[SKColor blackColor] ButtonTextFont:@"GridExerciseGaps" ButtonTextFontSize:10 isShowBorder:true];
        fire_button.userInteractionEnabled = NO;
        fire_button.position = CGPointMake(left_corner_x, (BOTTOM_HUD_HEIGHT - 10)*GAME_AREA_SCALE - button_size.height);
        [self.scene addChild:fire_button];
        
        button_size = CGSizeMake(50*GAME_AREA_SCALE,50*GAME_AREA_SCALE);
        rotate_uc_button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"rotate_uc_button" Alpha:1 BGAlpha:0.0 ButtonText:@"L" ButtonTextColor:[SKColor whiteColor] ButtonTextFont:@"GridExerciseGaps" ButtonTextFontSize:10 isShowBorder:true];
        rotate_uc_button.userInteractionEnabled = NO;
        rotate_uc_button.position = CGPointMake(right_corner_x-button_size.width*4, (BOTTOM_HUD_HEIGHT - 10)*GAME_AREA_SCALE - button_size.height);
        [self.scene addChild:rotate_uc_button];
        
        rotate_c_button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"rotate_c_button" Alpha:1 BGAlpha:0.0 ButtonText:@"R"ButtonTextColor:[SKColor whiteColor] ButtonTextFont:@"GridExerciseGaps" ButtonTextFontSize:10 isShowBorder:true];
        rotate_c_button.userInteractionEnabled = NO;
        rotate_c_button.position = CGPointMake(right_corner_x-button_size.width*3, (BOTTOM_HUD_HEIGHT - 10)*GAME_AREA_SCALE - button_size.height);
        [self.scene addChild:rotate_c_button];
        
        forward_button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"forward_button" Alpha:1 BGAlpha:0.0 ButtonText:@"F"ButtonTextColor:[SKColor whiteColor] ButtonTextFont:@"GridExerciseGaps" ButtonTextFontSize:10 isShowBorder:true];
        forward_button.userInteractionEnabled = NO;
        forward_button.position = CGPointMake(right_corner_x-button_size.width*2, (BOTTOM_HUD_HEIGHT - 10)*GAME_AREA_SCALE - button_size.height);
        [self.scene addChild:forward_button];
        
        backward_button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"backward_button" Alpha:1 BGAlpha:0.0 ButtonText:@"B"ButtonTextColor:[SKColor whiteColor] ButtonTextFont:@"GridExerciseGaps" ButtonTextFontSize:10 isShowBorder:true];
        backward_button.userInteractionEnabled = NO;
        backward_button.position = CGPointMake(right_corner_x-button_size.width, (BOTTOM_HUD_HEIGHT - 10)*GAME_AREA_SCALE - button_size.height);
        [self.scene addChild:backward_button];
        
        //
        
        button_size = CGSizeMake(50*GAME_AREA_SCALE,10*GAME_AREA_SCALE);
        NSString* game_over_font = @"GridExerciseGaps";
        game_over_label = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"game_over_label" Alpha:1 BGAlpha:0.0 ButtonText:@"GAME OVER" ButtonTextColor:[SKColor whiteColor] ButtonTextFont:game_over_font ButtonTextFontSize:30 isShowBorder:false];
        game_over_label.userInteractionEnabled = NO;
        game_over_label.position = CGPointMake((([[UIScreen mainScreen] bounds].size.width-50*GAME_AREA_SCALE))/2,
                                               ([[UIScreen mainScreen] bounds].size.height/2) +30*GAME_AREA_SCALE);
        
        button_size = CGSizeMake(150*GAME_AREA_SCALE,30*GAME_AREA_SCALE);
        replay_button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"replay_button" Alpha:1 BGAlpha:0.0 ButtonText:@"REMATCH" ButtonTextColor:[SKColor whiteColor] ButtonTextFont:game_over_font ButtonTextFontSize:15 isShowBorder:false BGColor:[UIColor whiteColor] ButtonTextVAlign:BUTTON_TEXT_MIDDLE];
        replay_button.userInteractionEnabled = NO;
        replay_button.position = CGPointMake((([[UIScreen mainScreen] bounds].size.width-button_size.width))/2,
                                             game_over_label.position.y - 100*GAME_AREA_SCALE);
        
        back_button = [[STAButton alloc] initWithSize:button_size Scale:GAME_AREA_SCALE Name:@"back_button" Alpha:1 BGAlpha:0.0 ButtonText:@"BACK" ButtonTextColor:[SKColor whiteColor] ButtonTextFont:game_over_font ButtonTextFontSize:15 isShowBorder:false BGColor:[UIColor whiteColor] ButtonTextVAlign:BUTTON_TEXT_MIDDLE];
        back_button.userInteractionEnabled = NO;
        back_button.position = CGPointMake((([[UIScreen mainScreen] bounds].size.width-button_size.width))/2,
                                           replay_button.position.y - 80*GAME_AREA_SCALE);
        //
        NSString * font = @"Press Start 2P";
        oppRematchLabel = [SKLabelNode labelNodeWithFontNamed:font];
        
        NSString *singlePlay = @"Your opponent wants to rematch";
        oppRematchLabel.text = singlePlay;
        oppRematchLabel.fontSize = 8*GAME_AREA_SCALE;
        oppRematchLabel.fontColor = [SKColor grayColor];
        
        oppRematchLabel.position = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,
                                               replay_button.position.y + 40*GAME_AREA_SCALE);
        
        oppRematchLabel.alpha = 0;
        [self.scene addChild:oppRematchLabel];
        
        //
        UIColor* tank_color = TANK_BODY_WHITE;
        UIColor* tank_base_color = TANK_BODY_BASE_WHITE;
        
        if (myColorId == 2) {
            tank_color = TANK_BODY_BLUE;
            tank_base_color = TANK_BODY_BASE_BLUE;
        }
        else if (myColorId == 3) {
            tank_color = TANK_BODY_GREEN;
            tank_base_color = TANK_BODY_BASE_GREEN;
        }
        else if (myColorId == 4) {
            tank_color = TANK_BODY_RED;
            tank_base_color = TANK_BODY_BASE_RED;
        }
        else if (myColorId == 5) {
            tank_color = TANK_BODY_YELLOW;
            tank_base_color = TANK_BODY_BASE_YELLOW;
        }
        
        
        if (myTankId == 2) {
            self.player = [[STAEnemyTank alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:1
                                               BodyColor:tank_color
                                           BodyBaseColor:tank_base_color
                                                      AI:NULL
                                                Category:PLAYER_CATEGORY
                                                  Bounds:bounds
                                         IsEnableStealth:isStealthOn];
        }
        else if (myTankId == 3) {
            self.player = [[STAJeep alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:1
                                               BodyColor:tank_color
                                           BodyBaseColor:tank_base_color
                                                      AI:NULL
                                                Category:PLAYER_CATEGORY
                                                  Bounds:bounds
                                         IsEnableStealth:isStealthOn];
        }
        else if (myTankId == 4) {
            self.player = [[STAShotgunTank alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:1
                                               BodyColor:tank_color
                                           BodyBaseColor:tank_base_color
                                                      AI:NULL
                                                Category:PLAYER_CATEGORY
                                                  Bounds:bounds
                                         IsEnableStealth:isStealthOn];
        }
        else if (myTankId == 5) {
            self.player = [[STASniperTank alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:1
                                               BodyColor:tank_color
                                           BodyBaseColor:tank_base_color
                                                      AI:NULL
                                                Category:PLAYER_CATEGORY
                                                  Bounds:bounds
                                         IsEnableStealth:isStealthOn];
        }
        else {
            
            self.player = [[STATank alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:1
                                               BodyColor:tank_color
                                           BodyBaseColor:tank_base_color
                                                      AI:NULL
                                                Category:PLAYER_CATEGORY
                                                  Bounds:bounds
                                         IsEnableStealth:isStealthOn];
        }
        
        [self.player setBattleStage:self];
        
        CGFloat player_bottom_border_y = bottom_corner_y + [self.player getAnchorOffsetY]+(PIXEL_WIDTHHEIGHT+1)*GAME_AREA_SCALE;//+PIXEL_WIDTHHEIGHT+1;
        CGFloat player_top_border_y = top_corner_y-PIXEL_WIDTHHEIGHT*2*self.scale*GAME_AREA_SCALE-3*GAME_AREA_SCALE;
        CGFloat player_left_border_x = left_corner_x+3*GAME_AREA_SCALE;
        CGFloat player_right_border_x = right_corner_x-11*GAME_AREA_SCALE;
        
        CGRect player_bounds = CGRectMake(player_left_border_x, player_bottom_border_y,
                                   player_right_border_x-player_left_border_x,
                                   player_top_border_y-player_bottom_border_y);
        [self.player setBorderBounds:player_bounds];
        
        
        //        CGFloat stage_start_x = ([[UIScreen mainScreen] bounds].size.width-PLAYER_WIDTH)/2 + [self.player getAnchorOffsetX];
        //        CGFloat stage_start_y = player_bottom_border_y+20;
        CGFloat stage_start_x = player_right_border_x - 20*GAME_AREA_SCALE;
        CGFloat stage_start_y = player_bottom_border_y+20*GAME_AREA_SCALE;
        
        self.player.position = CGPointMake(stage_start_x,stage_start_y);
        //        [self.player updateLastPositionData];
        
        [self.scene addChild:self.player];
        
        //==enemy
        tank_color = TANK_BODY_WHITE;
        tank_base_color = TANK_BODY_BASE_WHITE;
        
        if (oppColorId == 2) {
            tank_color = TANK_BODY_BLUE;
            tank_base_color = TANK_BODY_BASE_BLUE;
        }
        else if (oppColorId == 3) {
            tank_color = TANK_BODY_GREEN;
            tank_base_color = TANK_BODY_BASE_GREEN;
        }
        else if (oppColorId == 4) {
            tank_color = TANK_BODY_RED;
            tank_base_color = TANK_BODY_BASE_RED;
        }
        else if (oppColorId == 5) {
            tank_color = TANK_BODY_YELLOW;
            tank_base_color = TANK_BODY_BASE_YELLOW;
        }
        
        //
        
        if (oppTankId == 2) {
            self.enemy = [[STAEnemyTank alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:2
                                                   BodyColor:tank_color
                                               BodyBaseColor:tank_base_color
                                                          AI:NULL
                                                    Category:ENEMY_CATEGORY
                                                      Bounds:bounds
                                             IsEnableStealth:isStealthOn];
        }
        else if (oppTankId == 3) {
            self.enemy = [[STAJeep alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:2
                                              BodyColor:tank_color
                                          BodyBaseColor:tank_base_color
                                                     AI:NULL
                                               Category:ENEMY_CATEGORY
                                                 Bounds:bounds
                                        IsEnableStealth:isStealthOn];
        }
        else if (oppTankId == 4) {
            self.enemy = [[STAShotgunTank alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:2
                                                     BodyColor:tank_color
                                                 BodyBaseColor:tank_base_color
                                                            AI:NULL
                                                      Category:ENEMY_CATEGORY
                                                        Bounds:bounds
                                               IsEnableStealth:isStealthOn];
        }
        else if (oppTankId == 5) {
            self.enemy = [[STASniperTank alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:2
                                                    BodyColor:tank_color
                                                BodyBaseColor:tank_base_color
                                                           AI:NULL
                                                     Category:ENEMY_CATEGORY
                                                       Bounds:bounds
                                              IsEnableStealth:isStealthOn];
        }
        else {
            self.enemy = [[STATank alloc] initWithScale:self.scale*GAME_AREA_SCALE Id:2
                                              BodyColor:tank_color
                                          BodyBaseColor:tank_base_color
                                                     AI:NULL
                                               Category:ENEMY_CATEGORY
                                                 Bounds:bounds
                                        IsEnableStealth:isStealthOn];
        }
        
        self.enemy.isRemote = TRUE;
        self.enemy.moveSpeed *= ratio;
        
        [self.enemy setBattleStage:self];
        CGFloat enemy_bottom_border_y = bottom_corner_y + [self.enemy getAnchorOffsetY]+(PIXEL_WIDTHHEIGHT+1)*GAME_AREA_SCALE;//+PIXEL_WIDTHHEIGHT+1;
        CGFloat enemy_top_border_y = top_corner_y-PIXEL_WIDTHHEIGHT*2*self.scale*GAME_AREA_SCALE-3*GAME_AREA_SCALE;
        CGFloat enemy_left_border_x = left_corner_x+3*GAME_AREA_SCALE;
        CGFloat enemy_right_border_x = right_corner_x-11*GAME_AREA_SCALE;
        
        CGRect enemy_bounds = CGRectMake(enemy_left_border_x, enemy_bottom_border_y,
                                          enemy_right_border_x-enemy_left_border_x,
                                          enemy_top_border_y-enemy_bottom_border_y);
        [self.enemy setBorderBounds:enemy_bounds];
        
        
        stage_start_x = enemy_left_border_x + 20*GAME_AREA_SCALE;
        stage_start_y = enemy_top_border_y-20*GAME_AREA_SCALE;
        
        self.enemy.position = CGPointMake(stage_start_x,stage_start_y);
        
        self.enemy.zRotation = M_PI;
        
        [self.scene addChild:self.enemy];
        
        //tell opp battle stage UI is ready
        
        STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.mcManager setStageObj:self];
        [appDelegate.mcManager sendBattleStageUIReady];
    }
    
    return self;
}

-(void)startCountDown {
    //=== count down and fading out tanks
    NSString * font = @"GridExerciseGaps";
    countdownLabelNode = [SKLabelNode labelNodeWithFontNamed:font];
    
    NSString *cdStr = @"3";
    countdownLabelNode.text = cdStr;
    countdownLabelNode.fontSize = 38*GAME_AREA_SCALE;
    countdownLabelNode.fontColor = [SKColor whiteColor];
    
    CGFloat countdown_x = ([[UIScreen mainScreen] bounds].size.width)/2;
    CGFloat countdown_y = [[UIScreen mainScreen] bounds].size.height - 200*GAME_AREA_SCALE;
    
    countdownLabelNode.position = CGPointMake(countdown_x,countdown_y);
    
    int between_countdown_wait = 1;
    SKAction* displayCountdown3Action = [SKAction runBlock:^() {
        [self.scene addChild:countdownLabelNode];
    }];
    SKAction* displayCountdown2Action = [SKAction runBlock:^() {
        countdownLabelNode.text = @"2";
    }];
    SKAction* displayCountdown1Action = [SKAction runBlock:^() {
        countdownLabelNode.text = @"1";
    }];
    SKAction* fadeoutTanksAction = [SKAction runBlock:^() {
        [countdownLabelNode removeFromParent];
        
        SKAction * playerFadeOutAction = [SKAction runBlock:^(){
            self.player.isBrakingOn = false;
            [self.player fadeOut];
        }];
        
        //a timer to fade out both tanks!
        SKAction * enemyFadeOutAction = [SKAction runBlock:^() {
            self.enemy.isBrakingOn = false;
            [self.enemy fadeOut];
        }];
        
        SKAction * playerAdjAction = [SKAction runBlock:^() {
            STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.mcManager sendAdjX:self.player.position.x-self.player.getBorderBounds.origin.x
                                          Y:self.player.position.y-self.player.getBorderBounds.origin.y
                                          R:self.player.zRotation];
        }];
        
        [self.playerFadeNode runAction:playerFadeOutAction];
        [self.enemyFadeNode runAction:enemyFadeOutAction];
        
        SKAction* adjPeriod = [SKAction waitForDuration:0.1];
        [self.playerAdjNode runAction:[SKAction repeatActionForever:[SKAction sequence:@[adjPeriod,playerAdjAction]]]];
        
        isGameStart = true;
    }];
    
    SKAction* countdownActions=[SKAction sequence:@[[SKAction waitForDuration:between_countdown_wait],displayCountdown3Action,
                                                    [SKAction waitForDuration:between_countdown_wait],displayCountdown2Action,
                                                    [SKAction waitForDuration:between_countdown_wait],displayCountdown1Action,
                                                    [SKAction waitForDuration:between_countdown_wait],fadeoutTanksAction]];
    [self.scene runAction:countdownActions];
}

-(void) fadeInOutEnemy {
    SKAction * tankFadeAction = [SKAction runBlock:^(){
        [self.enemy fadeInThenOut];
    }];
    
    [self.enemyFadeNode runAction:tankFadeAction];
}

-(void) fadeInOutPlayer {
    SKAction * tankFadeAction = [SKAction runBlock:^(){
        [self.player fadeInThenOut];
    }];
    
    [self.playerFadeNode runAction:tankFadeAction];
}

-(void) fireBullet:(STATank*)tank {
//    NSLog(@"fire bullet");
    [tank updateLastPositionData];
    SKAction* shootBulletAction = [SKAction runBlock:^{
//        CGPoint location = [tank position];
        STABullet *bullet = [[STABullet alloc]initWithScale:GAME_AREA_SCALE];
        
        //need to position at the tip of the tank's turret..
        
        //bullet.position = location;
        bullet.zPosition = 1;
        
        //bullet.scale = 0.8;
        
        CGFloat velocity_x = cos([tank getAdjRotation])*tank.bulletSpeed*GAME_AREA_SCALE;
        CGFloat velocity_y = sin([tank getAdjRotation])*tank.bulletSpeed*GAME_AREA_SCALE;
        
        CGFloat radius = PLAYER_WIDTH;
        CGFloat x = cos([tank getAdjRotation])*radius + tank.position.x;
        CGFloat y = sin([tank getAdjRotation])*radius + tank.position.y;
        
        bullet.position = CGPointMake(x,y);
        
        bullet.zRotation = [tank getAdjRotation];
        
        bullet.physicsBody.velocity = CGVectorMake(velocity_x, velocity_y);
        
        bullet.ownerId = tank.playerId;
        
        [self.scene addChild:bullet];
        
        AudioServicesPlaySystemSound(shotSound);
        
        tank.fireCount++;
        
    }];// queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    [self.scene runAction:shootBulletAction];
    
    if (tank == self.player) {
        [self fadeInOutPlayer];
    }
    else if (tank == self.enemy) {
        [self fadeInOutEnemy];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isGameOver) {
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self.scene];
            SKNode *node = [self.scene nodeAtPoint:location];
            
            if ([node.name isEqualToString:@"replay_button"] && [replay_button isEnabled]) {
                //this needs to be confirmed from ALL players..
                //needs to boardcast a msg saying player requested replay
                
                [replay_button setEnabled:false];
                [replay_button setFontColor:[UIColor blackColor]];
                [replay_button setButtonColor:[UIColor whiteColor]];
                
                STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.mcManager sendReplay];
                return;
            }
            else if ([node.name isEqualToString:@"back_button"]) {
                //needs to wait all other players to go back and select
                //needs to boardcast a msg saying the player has exited to multi select screen.
                
                STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.mcManager sendBack];
                
                STAMyScene* myScene = (STAMyScene*)self.scene;
                
                [myScene.currStage cleanup];
                
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
                
//                myScene.currStage = [[STAMultiPlayerSelect alloc] initWithScale:self.scale Bounds:self.bounds Scene:self.scene];
                return;
            }
        }
    }
    else {
        NSLog(@"touch battle stage");
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self.scene];
            SKNode *node = [self.scene nodeAtPoint:location];
            
            if ([node.name isEqualToString:@"fire_button"]) {
                NSLog(@"fire!!");
                
                if (fire_button.isDoneRecharge) {
                    STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
                    
                    if (self.player.numShots == 1) {
                        [appDelegate.mcManager sendFire];
                    }
                    else if (self.player.numShots > 1) {
                        isPlayerSkipStop = TRUE;
                        CGFloat rand = (CGFloat)arc4random_uniform(self.player.attackAccuracyInRadian);
                        CGFloat adj_radian = rand / (CGFloat)100.0 + 0.05;
                        
                        NSLog(@"rrrradian: %f", adj_radian);
                        
                        __block int localNumShots = self.player.numShots;
                        
                        [self.player rotateInDegree:adj_radian complete:^(void) {
                            NSLog(@"ronn fire first time");
                            [appDelegate.mcManager sendFire];
                            
                            localNumShots--;
                            
                            if (localNumShots > 1) {
                                
                                __block int localNumShots = self.player.numShots;
                                
                                SKAction * individualShot = [SKAction runBlock:^(void) {
                                    CGFloat rand = (CGFloat)arc4random_uniform(self.player.betweenShotsAccuracyInRadian);
                                    CGFloat adj_radian = rand / (CGFloat)100.0 + 0.05;
                                    
                                    [self.player rotateInDegree:adj_radian complete:^(void) {
                                        STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
                                        
                                        NSLog(@"ronn fire other time");
                                        [appDelegate.mcManager sendFire];
                                        
                                        localNumShots--;
                                        
                                        if (localNumShots == 0) {
                                            [self.player stop];
                                        }
                                    }];
                                }];
                                
                                SKAction *wait = [SKAction waitForDuration:self.player.betweenShotsDuration];
                                [self.player.attackNode runAction:[SKAction repeatAction:[SKAction sequence:@[wait,individualShot]]
                                                                                   count:self.player.numShots-1]];
                            }
                        }];
                    }
                    
                    [fire_button recharge];
                }
                return;
            }
            else if ([node.name isEqualToString:@"rotate_c_button"]) {
                
                [rotate_c_button flashText];
                STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.mcManager sendRotateC];
                return;
            }
            else if ([node.name isEqualToString:@"rotate_uc_button"]) {
                
                [rotate_uc_button flashText];
                STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.mcManager sendRotateUC];
                return;
            }
            else if ([node.name isEqualToString:@"forward_button"]) {
                
                [forward_button flashText];
                STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.mcManager sendForward];
                return;
            }
            else if ([node.name isEqualToString:@"backward_button"]) {
                
                [backward_button flashText];
                STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.mcManager sendBackward];
                return;
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.player stop];
    STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.mcManager sendStop];//    :self.player.position.x Y:self.player.position.y R:self.player.zRotation];
    
    [rotate_c_button stopFlashText];
    [rotate_uc_button stopFlashText];
    [forward_button stopFlashText];
    [backward_button stopFlashText];
}

-(void)cleanup {
    [self.player removeAllActions];
    [self.enemy removeAllActions];
    
    [fire_button removeAllActions];
    [rotate_c_button removeAllActions];
    [rotate_uc_button removeAllActions];
    [forward_button removeAllActions];
    [backward_button removeAllActions];
    [replay_button removeAllActions];
    [back_button removeAllActions];
    [playerFadeNode removeAllActions];
    [enemyFadeNode removeAllActions];
    [countdownLabelNode removeAllActions];
    [game_over_label removeAllActions];
    [playerAdjNode removeAllActions];
    [oppRematchLabel removeAllActions];
    
    NSArray* objs = [NSArray arrayWithObjects:self.player,self.enemy,fire_button,
                     rotate_c_button,rotate_uc_button,forward_button,backward_button,
                     replay_button, back_button, playerFadeNode, enemyFadeNode, countdownLabelNode,
                     game_over_label,playerAdjNode,oppRematchLabel, nil];
    
    [self.scene removeChildrenInArray:objs];
}

-(NSMutableArray*)getAllBullets {
    NSArray * children = [self.scene children];
    NSMutableArray* bullets = [NSMutableArray array];
    NSUInteger numChild = [children count];
    for (int i=0; i < numChild; i++) {
        SKNode* child = [children objectAtIndex:i];
        if ([child class] == [STABullet class]) {
            [bullets addObject:child];
        }
    }
    
    return bullets;
}

-(void)showGameOverPlayerWin:(BOOL)isPlayerWin {
    isGameOver = true;
    
    int isPlayerWinInt = [[NSNumber numberWithBool:isPlayerWin]intValue];
    
    STAAppDelegate* appDelegate = (STAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.mcManager setIsPlayerWonLocal:isPlayerWinInt];
}

-(void)enemyRotateC {
    [self.enemy rotateClockwise];
}
-(void)enemyRotateUC {
    [self.enemy rotateCounterClockwise];
}
-(void)enemyForward {
    [self.enemy moveForward];
}
-(void)enemyBackward {
    [self.enemy moveBackward];
}
-(void)enemyStop {
    [self.enemy stop];
}
-(void)enemyFire {
    [self.enemy fire];
}
-(void)adjEnemyX:(CGFloat)x Y:(CGFloat)y R:(CGFloat)r {
    //need to reverse the x/y and also the r
    CGRect bounds = self.enemy.getBorderBounds;
//    CGFloat ratio = myScale/oppScale;
    
    CGFloat invX = bounds.origin.x+bounds.size.width - x*ratio;
    CGFloat invY = bounds.origin.y+bounds.size.height - y*ratio;
    
    self.enemy.position = CGPointMake(invX, invY);
    self.enemy.zRotation = (M_PI-r) * -1;
}

//
-(void)playerRotateC {
    [self.player rotateClockwise];
}
-(void)playerRotateUC {
    [self.player rotateCounterClockwise];
}
-(void)playerForward {
    [self.player moveForward];
}
-(void)playerBackward {
    [self.player moveBackward];
}
-(void)playerStop {
    if (!isPlayerSkipStop) {
        [self.player stop];
    }
    else {
        isPlayerSkipStop = false;
    }
}
-(void)playerFire {
    [self.player fire];
}

-(void)showGameOver:(int)isPlayerWin {
    isGameOver = true;
    
    if (isPlayerWin == 1) {
//        [game_over_label setText:@"Got you!"];
        [game_over_label setText:@"GOT YOU!"];
        [self.enemy explode];
        [self.player fadeInNow];
    }
    else if (isPlayerWin == 0) {
        [game_over_label setText:@"GAME OVER"];

        [self.player explode];
        [self.enemy fadeInNow];
    }
    else if (isPlayerWin == 3) {
        [game_over_label setText:@"DRAW"];
        
        [self.player explode];
        [self.enemy explode];
    }
    
    [self.scene addChild:game_over_label];
    [self.scene addChild:replay_button];
    [self.scene addChild:back_button];
}

-(void)reset {
    STAMyScene* myScene = (STAMyScene*)self.scene;
    
    [myScene.currStage cleanup];
    
    myScene.currStage = [[STAMultiPlayBattleStage alloc ]
                         initWithScale:self.scale Bounds:self.bounds Scene:self.scene
                         MyTank:myTankId MyColor:myColorId MyScale:myScale
                         OppTankId:oppTankId OppColor:oppColorId OppScale:oppScale
                         isStealthOn:isStealthOn];
}

-(void)showOppRematch {
    SKAction * fadein = [SKAction fadeInWithDuration:0.5];
    oppRematchLabel.text = @"Your opponent wants to rematch";
    [oppRematchLabel runAction:fadein];
}

-(void)showOppBack{
    [self.replay_button setEnabled:false];
    self.replay_button.alpha = 0.0;
    
    SKAction * fadein = [SKAction fadeInWithDuration:0.5];
    oppRematchLabel.text = @"Opponent has hit 'Back' button";
    [oppRematchLabel runAction:fadein];
}

@end
