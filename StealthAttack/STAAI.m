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
    
    int enemyTank_lastknown_distance;
    
    STATank* host;
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

@synthesize midRange;
@synthesize shortRange;

@synthesize isApproaching;
@synthesize isRotating;

@synthesize revealedActionProbArrayLong;
@synthesize revealedActionProbArrayMid;
@synthesize revealedActionProbArrayShort;

@synthesize stealthActionProbArrayLong;
@synthesize stealthActionProbArrayMid;
@synthesize stealthActionProbArrayShort;

@synthesize chancesStopActionDistanceChangeProbArray;

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
        
        //=== When player revealed its position
        
        revealedActionProbArrayLong  = [self getProbArrayForApproach:10 WarningShot:1 Evade:5 DontMove:5 Stupid:5];
        revealedActionProbArrayMid   = [self getProbArrayForApproach:5 WarningShot:4 Evade:0 DontMove:0 Stupid:0];
        revealedActionProbArrayShort = [self getProbArrayForApproach:0 WarningShot:5 Evade:0 DontMove:0 Stupid:0];
        
        stealthActionProbArrayLong  = [self getProbArrayForApproach:10 WarningShot:2 Evade:0 DontMove:0 Stupid:0];
        stealthActionProbArrayMid   = [self getProbArrayForApproach:5 WarningShot:5 Evade:1 DontMove:0 Stupid:0];
        stealthActionProbArrayShort = [self getProbArrayForApproach:0 WarningShot:10 Evade:0 DontMove:0 Stupid:0];
        
        //====
        
        midRange = 40000;
        shortRange = 10000;
        
        //====
        
        chancesStopActionDistanceChangeProbArray = [self getProbArrayForYes:5 No:5];
        
        //====
    
        isApproaching = false;
        isRotating = false;
    }
    return self;
}

-(NSMutableArray*)getProbArrayForYes:(int)yes
                                  No:(int)no {
    
    NSMutableArray* probArrayShort = [NSMutableArray array];
    int count = 0;
    int i = 0;
    count+=yes;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:YES]];
    }
    count+=no;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:NO]];
    }
    
    return probArrayShort;
}

-(NSMutableArray*)getProbArrayForApproach:(int)approachProb
                              WarningShot:(int)warningShot
                                    Evade:(int)evadeShot
                                 DontMove:(int)dontMove
                                   Stupid:(int)stupid {
    
    NSMutableArray* probArrayShort = [NSMutableArray array];
    int count = 0;
    int i = 0;
    count+=approachProb;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:APPROACH_PROB_KEY]];
    }
    count+=warningShot;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:WARNSHOT_PROB_KEY]];
    }
    count+=evadeShot;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:EVADE_PROB_KEY]];
    }
    count+=dontMove;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:DONTMOVE_PROB_KEY]];
    }
    count+=stupid;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:STUPID_PROB_KEY]];
    }
    
    [self shuffle:probArrayShort];
    
    return probArrayShort;
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
    
    if (![self isAvailableForAction]) {
        //depending on certain conditions, stop the current action.
        int curDistance = 0;
        if (distance < shortRange) {
            curDistance = DISTANCE_SHORT;
        }
        else if (distance < midRange) {
            curDistance = DISTANCE_MID;
        }
        else {
            curDistance = DISTANCE_LONG;
        }
        
        if (enemyTank_lastknown_distance != curDistance) {
            //chances to stop the current action and rethink
            int rand = (int)arc4random_uniform([chancesStopActionDistanceChangeProbArray count]);
            
            NSNumber *prod_action = [chancesStopActionDistanceChangeProbArray objectAtIndex:rand];
            int prod_act_int = [prod_action intValue];
            
            if (prod_act_int == YES) {
                [host stop];
            }
        }
    }
    
    //currently an action is on going
    if (![self isAvailableForAction]) return;
    
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
        
        if (distance < shortRange) {
            enemyTank_lastknown_distance = DISTANCE_SHORT;
            
            int rand = (int)arc4random_uniform([revealedActionProbArrayShort count]);
            
            NSNumber *prod_action = [revealedActionProbArrayShort objectAtIndex:rand];
            int prod_act_int = [prod_action intValue];
            
            if (prod_act_int == APPROACH_PROB_KEY) {
                NSLog(@"revealed: approaching");
                [self approach_LastX:lastX LastY:lastY];
            }
            else if (prod_act_int == WARNSHOT_PROB_KEY) {
                NSLog(@"revealed: try warning shot");
                if (!isAttackCoolDown) {
                    NSLog(@"revealed: warning shot");
                    [host stop];
                    [self attack_LastX:lastX LastY:lastY];
                }
            }
            else if (prod_act_int == EVADE_PROB_KEY) {
                NSLog(@"revealed: evade");
                [self evadeFrom_LastX:lastX LastY:lastY LastRotation:lastRotation];
            }
            else if (prod_act_int == DONTMOVE_PROB_KEY) {
                NSLog(@"revealed: stop moving");
                [host stop];
            }
            else if (prod_act_int == STUPID_PROB_KEY) {
                NSLog(@"revealed: stupid");
                [host stop];
                [self stupid];
            }
        }
        else if (distance < midRange) {
            enemyTank_lastknown_distance = DISTANCE_MID;
            
            int rand = (int)arc4random_uniform([revealedActionProbArrayMid count]);
            
            NSNumber *prod_action = [revealedActionProbArrayMid objectAtIndex:rand];
            int prod_act_int = [prod_action intValue];
            
            if (prod_act_int == APPROACH_PROB_KEY) {
                NSLog(@"revealed: approaching");
                [self approach_LastX:lastX LastY:lastY];
            }
            else if (prod_act_int == WARNSHOT_PROB_KEY) {
                NSLog(@"revealed: try warning shot");
                if (!isAttackCoolDown) {
                    NSLog(@"revealed: warning shot");
                    [host stop];
                    [self attack_LastX:lastX LastY:lastY];
                }
            }
            else if (prod_act_int == EVADE_PROB_KEY) {
                NSLog(@"revealed: evade");
                [self evadeFrom_LastX:lastX LastY:lastY LastRotation:lastRotation];
            }
            else if (prod_act_int == DONTMOVE_PROB_KEY) {
                NSLog(@"revealed: stop moving");
                [host stop];
            }
            else if (prod_act_int == STUPID_PROB_KEY) {
                NSLog(@"revealed: stupid");
                [host stop];
                [self stupid];
            }
        }
        else {
            enemyTank_lastknown_distance = DISTANCE_LONG;
            
            int rand = (int)arc4random_uniform([revealedActionProbArrayLong count]);
            
            NSNumber *prod_action = [revealedActionProbArrayLong objectAtIndex:rand];
            int prod_act_int = [prod_action intValue];
            
            if (prod_act_int == APPROACH_PROB_KEY) {
                NSLog(@"revealed: approaching");
                [self approach_LastX:lastX LastY:lastY];
            }
            else if (prod_act_int == WARNSHOT_PROB_KEY) {
                NSLog(@"revealed: try warning shot");
                if (!isAttackCoolDown) {
                    NSLog(@"revealed: warning shot");
                    [host stop];
                    [self attack_LastX:lastX LastY:lastY];
                }
            }
            else if (prod_act_int == EVADE_PROB_KEY) {
                NSLog(@"revealed: evade");
                [self evadeFrom_LastX:lastX LastY:lastY LastRotation:lastRotation];
            }
            else if (prod_act_int == DONTMOVE_PROB_KEY) {
                NSLog(@"revealed: stop moving");
                [host stop];
            }
            else if (prod_act_int == STUPID_PROB_KEY) {
                NSLog(@"revealed: stupid");
                [host stop];
                [self stupid];
            }
        }
        
        enemyTank_lastknown_x = lastX;
        enemyTank_lastknown_y = lastY;
        enemyTank_lastknown_rotation = lastRotation;
    }
    else {
        NSLog(@"player go stealth..");
        //if no other actions are in progress
        if (distance < shortRange) {
            enemyTank_lastknown_distance = DISTANCE_SHORT;
            
            [host stop];
            
            int rand = (int)arc4random_uniform([stealthActionProbArrayShort count]);
            
            NSNumber *prod_action = [stealthActionProbArrayShort objectAtIndex:rand];
            int prod_act_int = [prod_action intValue];
            
            if (prod_act_int == APPROACH_PROB_KEY) {
                NSLog(@"stealth: approaching");
                [self approach_LastX:lastX LastY:lastY];
            }
            else if (prod_act_int == WARNSHOT_PROB_KEY) {
                NSLog(@"stealth: try warning shot");
                if (!isAttackCoolDown) {
                    NSLog(@"stealth: warning shot");
                    [host stop];
                    [self attack_LastX:lastX LastY:lastY];
                }
            }
            else if (prod_act_int == EVADE_PROB_KEY) {
                NSLog(@"stealth: evade");
                [self evadeFrom_LastX:lastX LastY:lastY LastRotation:lastRotation];
            }
            else if (prod_act_int == DONTMOVE_PROB_KEY) {
                NSLog(@"stealth: stop moving");
                [host stop];
            }
            else if (prod_act_int == STUPID_PROB_KEY) {
                NSLog(@"stealth: stupid");
                [host stop];
                [self stupid];
            }

        }
        else if (distance < midRange) {
            enemyTank_lastknown_distance = DISTANCE_MID;
            NSLog(@"stealh: mid range.. approaching");
            
            int rand = (int)arc4random_uniform([stealthActionProbArrayMid count]);
            
            NSNumber *prod_action = [stealthActionProbArrayMid objectAtIndex:rand];
            int prod_act_int = [prod_action intValue];
            
            if (prod_act_int == APPROACH_PROB_KEY) {
                NSLog(@"stealth: approaching");
                [self approach_LastX:lastX LastY:lastY];
            }
            else if (prod_act_int == WARNSHOT_PROB_KEY) {
                NSLog(@"stealth: try warning shot");
                if (!isAttackCoolDown) {
                    NSLog(@"stealth: warning shot");
                    [host stop];
                    [self attack_LastX:lastX LastY:lastY];
                }
            }
            else if (prod_act_int == EVADE_PROB_KEY) {
                NSLog(@"stealth: evade");
                [self evadeFrom_LastX:lastX LastY:lastY LastRotation:lastRotation];
            }
            else if (prod_act_int == DONTMOVE_PROB_KEY) {
                NSLog(@"stealth: stop moving");
                [host stop];
            }
            else if (prod_act_int == STUPID_PROB_KEY) {
                NSLog(@"stealth: stupid");
                [self stupid];
            }
        }
        else { //long range
            enemyTank_lastknown_distance = DISTANCE_LONG;
            NSLog(@"stealh: long range.. approaching");
            
            int rand = (int)arc4random_uniform([stealthActionProbArrayLong count]);
            
            NSNumber *prod_action = [stealthActionProbArrayLong objectAtIndex:rand];
            int prod_act_int = [prod_action intValue];
            
            if (prod_act_int == APPROACH_PROB_KEY) {
                NSLog(@"stealth: approaching");
                [self approach_LastX:lastX LastY:lastY];
            }
            else if (prod_act_int == WARNSHOT_PROB_KEY) {
                NSLog(@"stealth: try warning shot");
                if (!isAttackCoolDown) {
                    [host stop];
                    NSLog(@"stealth: warning shot");
                    [self attack_LastX:lastX LastY:lastY];
                }
            }
            else if (prod_act_int == EVADE_PROB_KEY) {
                NSLog(@"stealth: evade");
                [self evadeFrom_LastX:lastX LastY:lastY LastRotation:lastRotation];
            }
            else if (prod_act_int == DONTMOVE_PROB_KEY) {
                NSLog(@"stealth: stop moving");
                [host stop];
            }
            else if (prod_act_int == STUPID_PROB_KEY) {
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
