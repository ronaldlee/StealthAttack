//
//  STABattleStage.h
//  StealthAttack
//
//  Created by Ronald Lee on 7/12/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAStage.h"
#import <AudioToolbox/AudioToolbox.h>

@interface STABattleStage : STAStage


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
@property (nonatomic) SystemSoundID *shotSound;

- (id)initWithScale:(float)scale Bounds:(CGRect)bounds Scene:(SKScene*)scene EnemyId:(int)enemyId;

-(void) fireBullet:(STATank*)tank;

-(NSMutableArray*)getAllBullets;
-(void)showGameOverPlayerWin:(BOOL)isPlayerWin;

@end
