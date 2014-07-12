//
//  STAStage.h
//  StealthAttack
//
//  Created by Ronald Lee on 7/6/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAStage : NSObject<STAStageObject>

@property (nonatomic) SKScene* scene;
@property (nonatomic) STATank * playerTank;
@property (nonatomic) STATank * enemyTank1;
@property (nonatomic) STATank * enemyTank2;
@property (nonatomic) STATank * enemyTank3;

- (id)initWithScale:(float)scale Bounds:(CGRect)bounds Scene:(SKScene*)scene;

@end
