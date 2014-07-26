//
//  STABattleStage.h
//  StealthAttack
//
//  Created by Ronald Lee on 7/12/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAStage.h"

@interface STABattleStage : STAStage


@property (nonatomic) STATank * player;
@property (nonatomic) STATank * enemy;

@property (nonatomic) STAButton * fire_button;
@property (nonatomic) STAButton * rotate_c_button;
@property (nonatomic) STAButton * rotate_uc_button;
@property (nonatomic) STAButton * forward_button;
@property (nonatomic) STAButton * backward_button;

-(void) fireBullet:(STATank*)tank;

@end
