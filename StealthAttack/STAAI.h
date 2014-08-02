//
//  STAAI.h
//  StealthAttack
//
//  Created by Ronald Lee on 7/20/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STATank;
@class STABattleStage;

@interface STAAI : NSObject

@property (nonatomic) STABattleStage* stage;

//this is how accuray a tank can aim
//should be a value between +/- 0 to 10 divided by 100 (max 0.1 radian)
//otherwise it is going to be really inaccurate.
@property (nonatomic) CGFloat accuracyInRadian;

//each time when it decides to shoot, how many of them
@property (nonatomic) int numShots;
//when shooting multiple, duration between them
@property (nonatomic) CGFloat betweenShotsDuration;
//when shooting multiple, accuracy between them
//should be a value between +/- 0 to 50 divided by 100 (max 0.5 radian)
@property (nonatomic) CGFloat betweenShotsAccuracyInRadian;

//once attacked and should cool down before next attack
@property (nonatomic) BOOL isAttackCoolDown;
@property (nonatomic) CGFloat attackCoolDownDuration;

//player reveal actions probability
//  approach : 1
//  fire warning shots : 2
//  evade : 3
//  don't move : 4
//  stupid: 5

//ranges
@property (nonatomic) int shortRange;
@property (nonatomic) int midRange;


@property (nonatomic) BOOL isApproaching;
@property (nonatomic) BOOL isRotating;

//@property (nonatomic) int

@property (nonatomic) NSMutableArray* revealedActionProbArrayLong;
@property (nonatomic) NSMutableArray* revealedActionProbArrayMid;
@property (nonatomic) NSMutableArray* revealedActionProbArrayShort;

@property (nonatomic) NSMutableArray* stealthActionProbArrayLong;
@property (nonatomic) NSMutableArray* stealthActionProbArrayMid;
@property (nonatomic) NSMutableArray* stealthActionProbArrayShort;

@property (nonatomic) NSMutableArray* chancesStopActionDistanceChangeProbArray;


-(id)initWithStage:(STABattleStage*)stage;

-(void)think;

-(void)setHost:(STATank*)host;

@end
