//
//  STAMultiPlayerSelect.h
//  StealthAttack
//
//  Created by Ronald Lee on 8/23/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAStage.h"

@interface STAMultiPlayerSelect : STAStage


@property (nonatomic) SKLabelNode * selectOppTitle;
@property (nonatomic) SKLabelNode * backLabel;

@property (nonatomic) STAButton * backButton;
@property (nonatomic) STAButton * readyButton;

@property (nonatomic) STAButton * enemy1Button;
@property (nonatomic) STAButton * enemy2Button;
@property (nonatomic) STAButton * enemy3Button;
@property (nonatomic) STAButton * enemy4Button;
@property (nonatomic) STAButton * enemy5Button;

@property (nonatomic) STATank * playerTank;


@property (nonatomic) STATank * enemy1;
@property (nonatomic) STATank * enemy2;
@property (nonatomic) STATank * enemy3;
@property (nonatomic) STATank * enemy4;
@property (nonatomic) STATank * enemy5;

//

@property (nonatomic) STAButton * color1Button;
@property (nonatomic) STAButton * color2Button;
@property (nonatomic) STAButton * color3Button;
@property (nonatomic) STAButton * color4Button;
@property (nonatomic) STAButton * color5Button;

-(void)goToBattleStageMyTank:(int)myTankId MyColor:(int)myColorId OppTankId:(int)oppTankId OppColor:(int)oppColorId;

@end
