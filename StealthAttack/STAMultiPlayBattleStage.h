//
//  STAMultiPlayBattleStage.h
//  StealthAttack
//
//  Created by Ronald Lee on 8/24/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAStage.h"

@interface STAMultiPlayBattleStage : STAStage

@property (nonatomic) STATank * player;
@property (nonatomic) STATank * enemy;

@property (nonatomic) STAButton * fire_button;
@property (nonatomic) STAButton * rotate_c_button;
@property (nonatomic) STAButton * rotate_uc_button;
@property (nonatomic) STAButton * forward_button;
@property (nonatomic) STAButton * backward_button;

@property (nonatomic) STAButton * replay_button;
@property (nonatomic) STAButton * back_button;
@property (nonatomic) STAButton * game_over_label;

@property (nonatomic) SKNode* playerFadeNode;
@property (nonatomic) SKNode* enemyFadeNode;

@property (nonatomic) BOOL isGameStart;
@property (nonatomic) BOOL isGameOver;

- (id)initWithScale:(float)scale Bounds:(CGRect)bounds Scene:(SKScene*)scene
             MyTank:(int)myTankId MyColor:(int)myColorId OppTankId:(int)oppTankId OppColor:(int)oppColorId;

-(void) fireBullet:(STATank*)tank;

-(NSMutableArray*)getAllBullets;
-(void)showGameOverPlayerWin:(BOOL)isPlayerWin;

-(void)startCountDown;

@end
