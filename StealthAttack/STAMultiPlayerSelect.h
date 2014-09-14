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
@property (nonatomic) SKLabelNode * selectColorTitle;

@property (nonatomic) SKLabelNode * backLabel;
@property (nonatomic) SKLabelNode * oppReadyLabel;
@property (nonatomic) SKLabelNode * oppLeftLabel;
@property (nonatomic) SKLabelNode * errorLabel;

@property (nonatomic) STAButton * backButton;
@property (nonatomic) STAButton * readyButton;
@property (nonatomic) STAButton * stealthOnOffButton;

@property (nonatomic) STAButton * enemy1Button;
@property (nonatomic) STAButton * enemy2Button;
@property (nonatomic) STAButton * enemy3Button;
@property (nonatomic) STAButton * enemy4Button;
@property (nonatomic) STAButton * enemy5Button;


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

-(void)goToBattleStageMyTank:(int)myTankId MyColor:(int)myColorId MyScale:(CGFloat)myScale
                   OppTankId:(int)oppTankId OppColor:(int)oppColorId OppScale:(CGFloat)oppScale
                 IsStealthOn:(BOOL)isStealthOn;

-(void)showOppIsReady;
-(void)showOppLeft;

-(BOOL)isReadyButtonPressed;

@end
