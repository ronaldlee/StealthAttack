//
//  STAMultiPlayerSelect.h
//  StealthAttack
//
//  Created by Ronald Lee on 8/23/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAStage.h"

@interface STAMultiPlayerSelect : STAStage


@property (nonatomic,strong) SKLabelNode * selectOppTitle;
@property (nonatomic,strong) SKLabelNode * backLabel;

@property (nonatomic,strong) STAButton * backButton;
@property (nonatomic,strong) STAButton * readyButton;

@property (nonatomic,strong) STAButton * enemy1Button;
@property (nonatomic,strong) STAButton * enemy2Button;
@property (nonatomic,strong) STAButton * enemy3Button;
@property (nonatomic,strong) STAButton * enemy4Button;
@property (nonatomic,strong) STAButton * enemy5Button;


@property (nonatomic) STATank * enemy1;
@property (nonatomic) STATank * enemy2;
@property (nonatomic) STATank * enemy3;
@property (nonatomic) STATank * enemy4;
@property (nonatomic) STATank * enemy5;

//

@property (nonatomic,strong) STAButton * color1Button;
@property (nonatomic,strong) STAButton * color2Button;
@property (nonatomic,strong) STAButton * color3Button;
@property (nonatomic,strong) STAButton * color4Button;
@property (nonatomic,strong) STAButton * color5Button;

-(void)goToBattleStageMyTank:(int)myTankId MyColor:(int)myColorId OppTankId:(int)oppTankId OppColor:(int)oppColorId;

@end
