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
//should be a value between +/- 0 to 10 divided by 100 (max 0.5)
//otherwise it is going to be really inaccurate.
@property (nonatomic) CGFloat accuracyInRadian;

- (id)initWithStage:(STABattleStage*)stage;

-(void)think;

-(void)setHost:(STATank*)host;

@end
