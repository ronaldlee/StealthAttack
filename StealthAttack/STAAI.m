//
//  STAAI.m
//  StealthAttack
//
//  Created by Ronald Lee on 7/20/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAAI.h"

@interface STAAI() {
    CGFloat enemyTank_lastknown_x;
    CGFloat enemyTank_lastknown_y;
    CGFloat enemyTank_lastknown_rotation;
    CGFloat enemyTank_lastknown_fireCount;
    STATank* host;
    
    NSMutableArray* revealedActionProbArray;
    NSMutableArray* stealthActionProbArrayLong;
    NSMutableArray* stealthActionProbArrayMid;
    NSMutableArray* stealthActionProbArrayShort;
}
@end

@implementation STAAI

@synthesize stage;
@synthesize accuracyInRadian;

@synthesize numShots;
@synthesize betweenShotsDuration;
@synthesize betweenShotsAccuracyInRadian;

@synthesize isAttackCoolDown;
@synthesize attackCoolDownDuration;

@synthesize revealedApproachProbablity;
@synthesize revealedWarningShotProbablity;
@synthesize revealedEvadeProbablity;
@synthesize revealedDontMoveProbablity;
@synthesize revealedStupidProbablity;

@synthesize stealthApproachProbablityLong;
@synthesize stealthWarningShotProbablityLong;
@synthesize stealthEvadeProbablityLong;
@synthesize stealthDontMoveProbablityLong;
@synthesize stealthStupidProbablityLong;

@synthesize stealthApproachProbablityMid;
@synthesize stealthWarningShotProbablityMid;
@synthesize stealthEvadeProbablityMid;
@synthesize stealthDontMoveProbablityMid;
@synthesize stealthStupidProbablityMid;

@synthesize stealthApproachProbablityShort;
@synthesize stealthWarningShotProbablityShort;
@synthesize stealthEvadeProbablityShort;
@synthesize stealthDontMoveProbablityShort;
@synthesize stealthStupidProbablityShort;

@synthesize midRange;
@synthesize shortRange;

@synthesize isApproaching;
@synthesize isRotating;

- (id)initWithStage:(STABattleStage*)b_stage {
    self = [super init];
    if (self) {
        stage = b_stage;
        enemyTank_lastknown_x=-1;
        enemyTank_lastknown_y=-1;
        
        accuracyInRadian = 5;
        
        numShots = 2;
        betweenShotsDuration = 0.5;
        betweenShotsAccuracyInRadian = 25;
        
        isAttackCoolDown = false;
        attackCoolDownDuration = 5;
        
        //===
        revealedApproachProbablity = 5;
        revealedWarningShotProbablity = 5;
        revealedEvadeProbablity = 5;
        revealedDontMoveProbablity = 5;
        revealedStupidProbablity = 5;
        
        revealedActionProbArray = [NSMutableArray array];
        int count = 0;
        int i=0;
        count+=revealedApproachProbablity;
        for (; i < count; i++) {
            [revealedActionProbArray addObject:[NSNumber numberWithInteger:REVEALED_APPROACH_PROB_KEY]];
        }
        count+=revealedWarningShotProbablity;
        for (; i < count; i++) {
            [revealedActionProbArray addObject:[NSNumber numberWithInteger:REVEALED_WARNSHOT_PROB_KEY]];
        }
        count+=revealedEvadeProbablity;
        for (; i < count; i++) {
            [revealedActionProbArray addObject:[NSNumber numberWithInteger:REVEALED_EVADE_PROB_KEY]];
        }
        count+=revealedDontMoveProbablity;
        for (; i < count; i++) {
            [revealedActionProbArray addObject:[NSNumber numberWithInteger:REVEALED_DONTMOVE_PROB_KEY]];
        }
        count+=revealedStupidProbablity;
        for (; i < count; i++) {
            [revealedActionProbArray addObject:[NSNumber numberWithInteger:REVEALED_STUPID_PROB_KEY]];
        }
        
        [self shuffle:revealedActionProbArray];
        
        //==== Long
        stealthApproachProbablityLong = 10;
        stealthWarningShotProbablityLong = 2;
        stealthEvadeProbablityLong = 0;
        stealthDontMoveProbablityLong = 0;
        stealthStupidProbablityLong = 0;
        
        stealthActionProbArrayLong = [NSMutableArray array];
        count = 0;
        i = 0;
        count+=stealthApproachProbablityLong;
        for (; i < count; i++) {
            [stealthActionProbArrayLong addObject:[NSNumber numberWithInteger:REVEALED_APPROACH_PROB_KEY]];
        }
        count+=stealthWarningShotProbablityLong;
        for (; i < count; i++) {
            [stealthActionProbArrayLong addObject:[NSNumber numberWithInteger:REVEALED_WARNSHOT_PROB_KEY]];
        }
        count+=stealthEvadeProbablityLong;
        for (; i < count; i++) {
            [stealthActionProbArrayLong addObject:[NSNumber numberWithInteger:REVEALED_EVADE_PROB_KEY]];
        }
        count+=stealthDontMoveProbablityLong;
        for (; i < count; i++) {
            [stealthActionProbArrayLong addObject:[NSNumber numberWithInteger:REVEALED_DONTMOVE_PROB_KEY]];
        }
        count+=stealthStupidProbablityLong;
        for (; i < count; i++) {
            [stealthActionProbArrayLong addObject:[NSNumber numberWithInteger:REVEALED_STUPID_PROB_KEY]];
        }
        
        [self shuffle:stealthActionProbArrayLong];
        
        //==== Mid
        stealthApproachProbablityMid = 5;
        stealthWarningShotProbablityMid = 5;
        stealthEvadeProbablityMid = 1;
        stealthDontMoveProbablityMid = 0;
        stealthStupidProbablityMid = 0;
        
        stealthActionProbArrayMid = [NSMutableArray array];
        count = 0;
        i = 0;
        count+=stealthApproachProbablityMid;
        for (; i < count; i++) {
            [stealthActionProbArrayMid addObject:[NSNumber numberWithInteger:REVEALED_APPROACH_PROB_KEY]];
        }
        count+=stealthWarningShotProbablityMid;
        for (; i < count; i++) {
            [stealthActionProbArrayMid addObject:[NSNumber numberWithInteger:REVEALED_WARNSHOT_PROB_KEY]];
        }
        count+=stealthEvadeProbablityMid;
        for (; i < count; i++) {
            [stealthActionProbArrayMid addObject:[NSNumber numberWithInteger:REVEALED_EVADE_PROB_KEY]];
        }
        count+=stealthDontMoveProbablityMid;
        for (; i < count; i++) {
            [stealthActionProbArrayMid addObject:[NSNumber numberWithInteger:REVEALED_DONTMOVE_PROB_KEY]];
        }
        count+=stealthStupidProbablityMid;
        for (; i < count; i++) {
            [stealthActionProbArrayMid addObject:[NSNumber numberWithInteger:REVEALED_STUPID_PROB_KEY]];
        }
        
        [self shuffle:stealthActionProbArrayMid];
        
        //==== Short
        stealthApproachProbablityShort = 0;
        stealthWarningShotProbablityShort = 10;
        stealthEvadeProbablityShort = 0;
        stealthDontMoveProbablityShort = 0;
        stealthStupidProbablityShort = 0;
        
        stealthActionProbArrayShort = [NSMutableArray array];
        count = 0;
        i = 0;
        count+=stealthApproachProbablityShort;
        for (; i < count; i++) {
            [stealthActionProbArrayShort addObject:[NSNumber numberWithInteger:REVEALED_APPROACH_PROB_KEY]];
        }
        count+=stealthWarningShotProbablityShort;
        for (; i < count; i++) {
            [stealthActionProbArrayShort addObject:[NSNumber numberWithInteger:REVEALED_WARNSHOT_PROB_KEY]];
        }
        count+=stealthEvadeProbablityShort;
        for (; i < count; i++) {
            [stealthActionProbArrayShort addObject:[NSNumber numberWithInteger:REVEALED_EVADE_PROB_KEY]];
        }
        count+=stealthDontMoveProbablityShort;
        for (; i < count; i++) {
            [stealthActionProbArrayShort addObject:[NSNumber numberWithInteger:REVEALED_DONTMOVE_PROB_KEY]];
        }
        count+=stealthStupidProbablityShort;
        for (; i < count; i++) {
            [stealthActionProbArrayShort addObject:[NSNumber numberWithInteger:REVEALED_STUPID_PROB_KEY]];
        }
        
        [self shuffle:stealthActionProbArrayShort];
        //====
        
        midRange = 40000;
        shortRange = 10000;
        
        //====
    
        isApproaching = false;
        isRotating = false;
    }
    return self;
}

-(void)setHost:(STATank*)t_host {
    host = t_host;
}

-(void)think {
//    NSLog(@"thinking");
    
    STATank* player = [stage player];
    if (player.isExploded) return; //player is dead already. yay!
    
    CGFloat lastX = [player lastX];
    CGFloat lastY = [player lastY];
    CGVector lastDirection = [player lastDirection];
    CGFloat lastRotation = [player lastRotation];
    
    //distance from enemy
    CGFloat distance = [self getDistanceFromEnemy_LastX:lastX LastY:lastY];
    
    NSLog(@"distance sq: %f" , distance);
    
    if (lastX == -1 && lastY == -1) return;
    
    
    //attack
    if (enemyTank_lastknown_fireCount != player.fireCount) {
        enemyTank_lastknown_fireCount = player.fireCount;

        //player just revealed itself:
        //actions:
        //  approach -
        //  fire warning shots -
        //  evade -
        //  frank -
        //  don't move -
        //  stupid - move like a retarded, simulate human mistakes and hestitations.
        
        int rand = (int)arc4random_uniform([revealedActionProbArray count]);
        
        NSNumber *prod_action = [revealedActionProbArray objectAtIndex:rand];
        int prod_act_int = [prod_action intValue];
        
        if (prod_act_int == REVEALED_APPROACH_PROB_KEY) {
            NSLog(@"revealed: approaching");
            [self approach_LastX:lastX LastY:lastY];
        }
        else if (prod_act_int == REVEALED_WARNSHOT_PROB_KEY) {
            NSLog(@"revealed: try warning shot");
            if (!isAttackCoolDown) {
                NSLog(@"revealed: warning shot");
                [host stop];
                [self attack_LastX:lastX LastY:lastY];
            }
        }
        else if (prod_act_int == REVEALED_EVADE_PROB_KEY) {
            NSLog(@"revealed: evade");
            [self evadeFrom_LastX:lastX LastY:lastY LastRotation:lastRotation];
        }
        else if (prod_act_int == REVEALED_DONTMOVE_PROB_KEY) {
            NSLog(@"revealed: stop moving");
            [host stop];
        }
        else if (prod_act_int == REVEALED_STUPID_PROB_KEY) {
            NSLog(@"revealed: stupid");
            [host stop];
            [self stupid];
        }
        
        enemyTank_lastknown_x = lastX;
        enemyTank_lastknown_y = lastY;
        enemyTank_lastknown_rotation = lastRotation;
    }
    else {
        NSLog(@"player go stealth..");
        //if no other actions are in progress
        if (distance < shortRange) {
//            isApproaching = false;
            
            [host stop];
            
            int rand = (int)arc4random_uniform([stealthActionProbArrayShort count]);
            
            NSNumber *prod_action = [stealthActionProbArrayShort objectAtIndex:rand];
            int prod_act_int = [prod_action intValue];
            
            if (prod_act_int == REVEALED_APPROACH_PROB_KEY) {
                NSLog(@"stealth: approaching");
                [self approach_LastX:lastX LastY:lastY];
            }
            else if (prod_act_int == REVEALED_WARNSHOT_PROB_KEY) {
                NSLog(@"stealth: try warning shot");
                if (!isAttackCoolDown) {
                    NSLog(@"stealth: warning shot");
                    [host stop];
                    [self attack_LastX:lastX LastY:lastY];
                }
            }
            else if (prod_act_int == REVEALED_EVADE_PROB_KEY) {
                NSLog(@"stealth: evade");
                [self evadeFrom_LastX:lastX LastY:lastY LastRotation:lastRotation];
            }
            else if (prod_act_int == REVEALED_DONTMOVE_PROB_KEY) {
                NSLog(@"stealth: stop moving");
                [host stop];
            }
            else if (prod_act_int == REVEALED_STUPID_PROB_KEY) {
                NSLog(@"stealth: stupid");
                [host stop];
                [self stupid];
            }

        }
        else if (distance < midRange) {
            NSLog(@"stealh: mid range.. approaching");
            
            int rand = (int)arc4random_uniform([stealthActionProbArrayMid count]);
            
            NSNumber *prod_action = [stealthActionProbArrayMid objectAtIndex:rand];
            int prod_act_int = [prod_action intValue];
            
            if (prod_act_int == REVEALED_APPROACH_PROB_KEY) {
                NSLog(@"stealth: approaching");
                [self approach_LastX:lastX LastY:lastY];
            }
            else if (prod_act_int == REVEALED_WARNSHOT_PROB_KEY) {
                NSLog(@"stealth: try warning shot");
                if (!isAttackCoolDown) {
                    NSLog(@"stealth: warning shot");
                    [host stop];
                    [self attack_LastX:lastX LastY:lastY];
                }
            }
            else if (prod_act_int == REVEALED_EVADE_PROB_KEY) {
                NSLog(@"stealth: evade");
                [self evadeFrom_LastX:lastX LastY:lastY LastRotation:lastRotation];
            }
            else if (prod_act_int == REVEALED_DONTMOVE_PROB_KEY) {
                NSLog(@"stealth: stop moving");
                [host stop];
            }
            else if (prod_act_int == REVEALED_STUPID_PROB_KEY) {
                NSLog(@"stealth: stupid");
                [self stupid];
            }
        }
        else { //long range
            NSLog(@"stealh: long range.. approaching");
            
            int rand = (int)arc4random_uniform([stealthActionProbArrayLong count]);
            
            NSNumber *prod_action = [stealthActionProbArrayLong objectAtIndex:rand];
            int prod_act_int = [prod_action intValue];
            
            if (prod_act_int == REVEALED_APPROACH_PROB_KEY) {
                NSLog(@"stealth: approaching");
                [self approach_LastX:lastX LastY:lastY];
            }
            else if (prod_act_int == REVEALED_WARNSHOT_PROB_KEY) {
                NSLog(@"stealth: try warning shot");
                if (!isAttackCoolDown) {
                    [host stop];
                    NSLog(@"stealth: warning shot");
                    [self attack_LastX:lastX LastY:lastY];
                }
            }
            else if (prod_act_int == REVEALED_EVADE_PROB_KEY) {
                NSLog(@"stealth: evade");
                [self evadeFrom_LastX:lastX LastY:lastY LastRotation:lastRotation];
            }
            else if (prod_act_int == REVEALED_DONTMOVE_PROB_KEY) {
                NSLog(@"stealth: stop moving");
                [host stop];
            }
            else if (prod_act_int == REVEALED_STUPID_PROB_KEY) {
                NSLog(@"stealth: stupid");
                [host stop];
                [self stupid];
            }
        }
    }
    
//    if (distance > 100000) {
//        //approach
//        NSLog(@"approaching");
//        [self approach_LastX:lastX LastY:lastY];
//    }
//    else {
//        NSLog(@"want attack");
//        if (!isAttackCoolDown) {
//            NSLog(@"attacking really");
//            [host stop];
//            [self attack_LastX:lastX LastY:lastY];
//        }
//    }

}

-(CGFloat)getDistanceFromEnemy_LastX:(CGFloat)lastX LastY:(CGFloat)lastY {
    CGFloat xDiff = lastX - host.position.x;
    CGFloat yDiff = lastY - host.position.y;
    
    return xDiff*xDiff + yDiff*yDiff;
}

-(void)faceEnemy_LastX:(CGFloat)lastX LastY:(CGFloat)lastY
              Accuracy:(CGFloat)accuracy
              complete:(void (^)() )block{
    if (isRotating) {
        if (isApproaching) isApproaching = false;
        return;
    }
    
    isRotating = true;
    
    CGFloat faceRotate = [self calculateAngleX1:host.position.x Y1:host.position.y
                                             X2:lastX Y2:lastY];
    
    CGFloat degree1 = (M_PI_2-faceRotate) + M_PI_2;
 
    //accuracyInRadian
    int rand_dir = arc4random_uniform(1);
    if (accuracy > 0 && rand_dir == 1) {
        accuracy *= -1;
    }
    
    CGFloat degree1DiffFromLast = degree1 - host.zRotation + accuracy;
    
    CGFloat degree2 = degree1DiffFromLast-M_PI * 2;
    CGFloat degree_to_use = degree1DiffFromLast;
    
    if (fabs(degree2) < fabs(degree1DiffFromLast)) {
        degree_to_use=degree2;
    }
    
    [host rotateInDegree:degree_to_use complete:^(void) {
        isRotating = false;
        block();
    }];
}

-(void)evadeFrom_LastX:(CGFloat)lastX LastY:(CGFloat)lastY LastRotation:(CGFloat)lastRotation{
    
}

-(void)approach_LastX:(CGFloat)lastX LastY:(CGFloat)lastY {
    if (isApproaching) return;
    
    isApproaching = true;
    //calculate accuracy value
    //accuracyInRadian
    CGFloat rand = (CGFloat)arc4random_uniform(accuracyInRadian);
    CGFloat r = rand / (CGFloat)100.0;
    
    [self faceEnemy_LastX:lastX LastY:lastY Accuracy:r complete:^(void) {
        [host moveForwardToX:lastX Y:lastY complete:^(void) {
            isApproaching=false;
        }];
    }];
}

-(void)attack_LastX:(CGFloat)lastX LastY:(CGFloat)lastY {
    isAttackCoolDown = true;
    
    //calculate accuracy value
    //accuracyInRadian
    CGFloat rand = (CGFloat)arc4random_uniform(accuracyInRadian);
    CGFloat r = rand / (CGFloat)100.0;
    
    [self faceEnemy_LastX:lastX LastY:lastY Accuracy:r complete:^(void) {
        [host fire];
        
        //if numShots > 1
        if (numShots > 1) {
            SKAction * individualShot = [SKAction runBlock:^(void) {
                CGFloat rand = (CGFloat)arc4random_uniform(betweenShotsAccuracyInRadian);
                CGFloat r = rand / (CGFloat)100.0;
                
                [self faceEnemy_LastX:lastX LastY:lastY Accuracy:r complete:^(void) {
                    [host fire];
                }];
            }];
            
            SKAction *wait = [SKAction waitForDuration:betweenShotsDuration];
            [host runAction:[SKAction repeatAction:[SKAction sequence:@[wait,individualShot]] count:numShots]];
        }
    }];
    
    SKAction* attackCooldown = [SKAction waitForDuration:attackCoolDownDuration];
    SKAction* clearAttackCooldown = [SKAction runBlock:^() {
        NSLog(@"!!!!!!!!!! attack cool down over!!! CAN ATTACK AGAIN!!!!!!!!!");
        host.ai.isAttackCoolDown = false;
    }];
    [host.attackCooldownNode runAction:[SKAction sequence:@[attackCooldown,clearAttackCooldown]]];
    
}

-(CGFloat) calculateAngleX1:(CGFloat)x1 Y1:(CGFloat)y1 X2:(CGFloat)x2 Y2:(CGFloat)y2 {
    
    CGFloat x = x2-x1;
    CGFloat y = y2-y1;
    CGFloat baseangle = atan2(-x,-y);
    
    return baseangle;
}


- (void)shuffle:(NSMutableArray*)array
{
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
        [array exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

-(void) stupid {
    
}

-(BOOL) isAvailableForAction {
    return !isApproaching;
}

@end
