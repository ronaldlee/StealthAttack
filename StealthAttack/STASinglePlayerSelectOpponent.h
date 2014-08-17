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
//@property (nonatomic) SKLabelNode * startLabel;


@property (nonatomic) STAButton * backButton;
//@property (nonatomic) STAButton * startButton;

@property (nonatomic) STAButton * enemy1Button;
@property (nonatomic) STAButton * enemy2Button;
@property (nonatomic) STAButton * enemy3Button;
@property (nonatomic) STAButton * enemy4Button;


@property (nonatomic) STATank * playerTank;


@property (nonatomic) STATank * enemy1;
@property (nonatomic) STATank * enemy2;
@property (nonatomic) STATank * enemy3;
@property (nonatomic) STATank * enemy4;
@property (nonatomic) STATank * enemy5;
@property (nonatomic) STATank * enemy6;

@property (nonatomic) STATank * enemy7; //green battery bar, unlocked when get all 3 stars


@end
