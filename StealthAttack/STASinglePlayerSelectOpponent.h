//
//  STASinglePlayerSelectOpponent.h
//  StealthAttack
//
//  Created by Ronald Lee on 7/12/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STASinglePlayerSelectOpponent : STAStage

@property (nonatomic) SKLabelNode * selectOppTitle;
@property (nonatomic) SKLabelNode * backLabel;
@property (nonatomic) SKLabelNode * startLabel;


@property (nonatomic) STAButton * backButton;
@property (nonatomic) STAButton * startButton;

@property (nonatomic) STATank * playerTank;
@property (nonatomic) STATank * enemyTank1;

@end
