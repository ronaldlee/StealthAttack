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
    CGVector enemyTank_lastknown_direction;
    CGFloat enemyTank_lastknown_rotation;
    CGFloat enemyTank_lastknown_fireCount;
    
    int enemyTank_lastknown_distance;
    
    STATank* host;
    
    int ticksBeforeAdjustLastXY;
    CGRect bounds;
    
    int evadingTicks;
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

@synthesize numberOfThinkTicksBeforeAdjustLastXY;

@synthesize region1ProbArray;
@synthesize region2ProbArray;
@synthesize region3ProbArray;
@synthesize region4ProbArray;
@synthesize region5ProbArray;
@synthesize region6ProbArray;
@synthesize region7ProbArray;
@synthesize region8ProbArray;
@synthesize region9ProbArray;
//
//@synthesize evadeBulletProbArrayLong;
//@synthesize evadeBulletProbArrayMid;
//@synthesize evadeBulletProbArrayShort;

@synthesize evadeDegreeMarginShort;
@synthesize evadeDegreeMarginMid;
@synthesize evadeDegreeMarginLong;

@synthesize evadeDirectionProbArray;

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
        
        evadingTicks = 0;
        
        isAttackCoolDown = false;
        attackCoolDownDuration = 5;
        
        //=== When player revealed its position
        
//        revealedActionProbArrayLong  = [self getProbArrayForApproach:10 WarningShot:1 Evade:5 DontMove:5 Stupid:5];
//        revealedActionProbArrayMid   = [self getProbArrayForApproach:5 WarningShot:4 Evade:0 DontMove:0 Stupid:0];
//        revealedActionProbArrayShort = [self getProbArrayForApproach:0 WarningShot:5 Evade:0 DontMove:0 Stupid:0];
//        
//        stealthActionProbArrayLong  = [self getProbArrayForApproach:10 WarningShot:2 Evade:0 DontMove:0 Stupid:0];
//        stealthActionProbArrayMid   = [self getProbArrayForApproach:5 WarningShot:5 Evade:1 DontMove:0 Stupid:0];
//        stealthActionProbArrayShort = [self getProbArrayForApproach:0 WarningShot:10 Evade:0 DontMove:0 Stupid:0];
        
        revealedActionProbArrayLong  = [self getProbArrayForApproach:0 WarningShot:0 Evade:0 DontMove:1 Stupid:0];
        revealedActionProbArrayMid   = [self getProbArrayForApproach:0 WarningShot:0 Evade:0 DontMove:1 Stupid:0];
        revealedActionProbArrayShort = [self getProbArrayForApproach:0 WarningShot:0 Evade:0 DontMove:1 Stupid:0];
        
        stealthActionProbArrayLong  = [self getProbArrayForApproach:0 WarningShot:0 Evade:0 DontMove:1 Stupid:0];
        stealthActionProbArrayMid   = [self getProbArrayForApproach:0 WarningShot:0 Evade:0 DontMove:1 Stupid:0];
        stealthActionProbArrayShort = [self getProbArrayForApproach:0 WarningShot:0 Evade:0 DontMove:1 Stupid:0];
        
//        evadeBulletProbArrayLong  = [self getProbArrayForYes:1 No:0];
//        evadeBulletProbArrayMid   = [self getProbArrayForYes:1 No:0];
//        evadeBulletProbArrayShort = [self getProbArrayForYes:1 No:0];
        
        evadeDirectionProbArray = [self getProbArrayForYes:1 No:0];
        
        //====
        
        midRange = 40000;
        shortRange = 10000;
        
        //====
        
        chancesStopActionDistanceChangeProbArray = [self getProbArrayForYes:5 No:5];
        
        //====
    
        isApproaching = false;
        isRotating = false;
        
        //====
        
        numberOfThinkTicksBeforeAdjustLastXY = 15;
        
        //====
        //3 6 9
        //2 5 8
        //1 4 7
//        region1ProbArray = [self getProbArrayForR1:5 R2:5 R3:0 R4:5 R5:0 R6:0 R7:0 R8:0 R9:0];
//        region2ProbArray = [self getProbArrayForR1:5 R2:5 R3:5 R4:0 R5:0 R6:0 R7:0 R8:0 R9:0];
//        region3ProbArray = [self getProbArrayForR1:0 R2:5 R3:5 R4:0 R5:0 R6:5 R7:0 R8:0 R9:0];
//        
//        region4ProbArray = [self getProbArrayForR1:5 R2:0 R3:0 R4:5 R5:5 R6:0 R7:0 R8:0 R9:0];
//        region5ProbArray = [self getProbArrayForR1:0 R2:5 R3:0 R4:5 R5:5 R6:5 R7:0 R8:5 R9:0];
//        region6ProbArray = [self getProbArrayForR1:0 R2:0 R3:5 R4:0 R5:5 R6:5 R7:0 R8:0 R9:5];
//        
//        region7ProbArray = [self getProbArrayForR1:0 R2:0 R3:0 R4:5 R5:0 R6:0 R7:5 R8:5 R9:0];
//        region8ProbArray = [self getProbArrayForR1:0 R2:0 R3:0 R4:0 R5:5 R6:0 R7:5 R8:5 R9:5];
//        region9ProbArray = [self getProbArrayForR1:0 R2:0 R3:0 R4:0 R5:0 R6:5 R7:0 R8:5 R9:5];
        
        region1ProbArray = [self getProbArrayForR1:0 R2:0 R3:0 R4:0 R5:0 R6:0 R7:0 R8:0 R9:0];
        region2ProbArray = [self getProbArrayForR1:0 R2:0 R3:0 R4:0 R5:0 R6:0 R7:0 R8:0 R9:0];
        region3ProbArray = [self getProbArrayForR1:0 R2:0 R3:0 R4:0 R5:0 R6:0 R7:0 R8:0 R9:0];
        
        region4ProbArray = [self getProbArrayForR1:0 R2:0 R3:0 R4:0 R5:0 R6:0 R7:0 R8:0 R9:0];
        region5ProbArray = [self getProbArrayForR1:0 R2:0 R3:0 R4:0 R5:0 R6:0 R7:0 R8:0 R9:0];
        region6ProbArray = [self getProbArrayForR1:0 R2:0 R3:0 R4:0 R5:0 R6:0 R7:0 R8:0 R9:0];
        
        region7ProbArray = [self getProbArrayForR1:0 R2:0 R3:0 R4:0 R5:0 R6:0 R7:0 R8:0 R9:0];
        region8ProbArray = [self getProbArrayForR1:0 R2:0 R3:0 R4:0 R5:0 R6:0 R7:0 R8:0 R9:0];
        region9ProbArray = [self getProbArrayForR1:0 R2:0 R3:0 R4:0 R5:0 R6:0 R7:0 R8:0 R9:0];
        
        //=====
        
        evadeDegreeMarginShort = 10;
        evadeDegreeMarginMid = 5;
        evadeDegreeMarginLong = 0.01;
        
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

-(NSMutableArray*)getProbArrayForR1:(int)r1 R2:(int)r2 R3:(int)r3 R4:(int)r4
                                 R5:(int)r5 R6:(int)r6 R7:(int)r7 R8:(int)r8 R9:(int)r9 {
    NSMutableArray* probArrayShort = [NSMutableArray array];
    int count = 0;
    int i = 0;
    int region = 1;
    count+=r1;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:region]];
    }
    region++;
    count+=r2;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:region]];
    }
    region++;
    count+=r3;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:region]];
    }
    region++;
    count+=r4;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:region]];
    }
    region++;
    count+=r5;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:region]];
    }
    region++;
    count+=r6;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:region]];
    }
    region++;
    count+=r7;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:region]];
    }
    region++;
    count+=r8;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:region]];
    }
    region++;
    count+=r9;
    for (; i < count; i++) {
        [probArrayShort addObject:[NSNumber numberWithInteger:region]];
    }
    region++;
    
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

-(int)getRegionForX:(CGFloat)px Y:(CGFloat)py {
    bounds = [host getBorderBounds];
    CGFloat block_width = bounds.size.width/3;
    CGFloat block_height = bounds.size.height/3;
    CGFloat right_x = bounds.origin.x+bounds.size.width;
    CGFloat top_y = bounds.origin.y+bounds.size.height;
    
    int region_id=1;
    BOOL isFound = false;
    for (CGFloat x = bounds.origin.x; x < right_x && !isFound; x+=block_width) {
        for (CGFloat y = bounds.origin.y; y < top_y && !isFound; y+=block_height) {
            if (px >= x && px <= x+block_width) {
                if (py >= y && py <= y+block_height) {
                    isFound = true;
                    break;
                }
            }
            region_id++;
        }
    }
    
    if (!isFound) return -1;
    
    return region_id;
}

-(void)think {
//    NSLog(@"thinking: %d",ticksBeforeAdjustLastXY);
    STATank* player = [stage player];
    if (player.isExploded) {
        [host stop];
        [host stopFadeOut];
        [host fadeInNow];
        [host dance];
        return; //player is dead already. yay!
    }
    if (host.isExploded) return; //host is dead already. BOOO!
    
    if (evadingTicks > 0) {
        evadingTicks--;
        return;
    }
    
    CGFloat lastX = [player lastX];
    CGFloat lastY = [player lastY];
    CGVector lastDirection = [player lastDirection];
    CGFloat lastRotation = [player lastRotation];
    
    if (lastX != -1 && lastY != -1) {
        enemyTank_lastknown_x = lastX;
        enemyTank_lastknown_y = lastY;
        enemyTank_lastknown_direction = lastDirection;
        enemyTank_lastknown_rotation = lastRotation;
    }
    [player clearLastPositionData];
    
    ticksBeforeAdjustLastXY++;
    if (ticksBeforeAdjustLastXY > numberOfThinkTicksBeforeAdjustLastXY) {
//        NSLog(@"OOO player x: %f, y: %f", player.position.x, player.position.y);
        
        //time to estimate where player might go now..
        //Just divide the map into 9 blocks
        CGFloat block_width = bounds.size.width/3;
        CGFloat block_height = bounds.size.height/3;
        CGFloat right_x = bounds.origin.x+bounds.size.width;
        CGFloat top_y = bounds.origin.y+bounds.size.height;
        
        int region_id=1;
        BOOL isFound = false;
        for (CGFloat x = bounds.origin.x; x < right_x && !isFound; x+=block_width) {
            for (CGFloat y = bounds.origin.y; y < top_y && !isFound; y+=block_height) {
                if (enemyTank_lastknown_x >= x && enemyTank_lastknown_x <= x+block_width) {
                    if (enemyTank_lastknown_y >= y && enemyTank_lastknown_y <= y+block_height) {
//                        NSLog(@"+++++++++++++++++++++++++++++");
//                        NSLog(@"++++++++ player in region: %@. last x: %f, y: %f", [self getRegionStr: region_id],
//                                                                enemyTank_lastknown_x,enemyTank_lastknown_y );
//                        NSLog(@"+++++++++++++++++++++++++++++");
                        isFound = true;
                        break;
                    }
                }
                region_id++;
            }
        }
        
        if (isFound) {
            
            //based on player's last region and direction and move speed, predict/guess which region player might be
            int guess_region_id = -1;
            if (region_id == REGION_LEFT_BOTTOM && [region1ProbArray count] > 0) {
                int rand = (int)arc4random_uniform((unsigned int)[region1ProbArray count]);
                
                NSNumber *prod_action = [region1ProbArray objectAtIndex:rand];
                guess_region_id = [prod_action intValue];
            }
            else if (region_id == REGION_LEFT_MIDDLE && [region2ProbArray count] > 0) {
                int rand = (int)arc4random_uniform((unsigned int)[region2ProbArray count]);
                
                NSNumber *prod_action = [region2ProbArray objectAtIndex:rand];
                guess_region_id = [prod_action intValue];
            }
            else if (region_id == REGION_LEFT_TOP && [region3ProbArray count] > 0) {
                int rand = (int)arc4random_uniform((unsigned int)[region3ProbArray count]);
                
                NSNumber *prod_action = [region3ProbArray objectAtIndex:rand];
                guess_region_id = [prod_action intValue];
            }
            else if (region_id == REGION_MIDDLE_BOTTOM && [region4ProbArray count] > 0) {
                int rand = (int)arc4random_uniform((unsigned int)[region4ProbArray count]);
                
                NSNumber *prod_action = [region4ProbArray objectAtIndex:rand];
                guess_region_id = [prod_action intValue];
            }
            else if (region_id == REGION_MIDDLE_MIDDLE && [region5ProbArray count] > 0) {
                int rand = (int)arc4random_uniform((unsigned int)[region5ProbArray count]);
                
                NSNumber *prod_action = [region5ProbArray objectAtIndex:rand];
                guess_region_id = [prod_action intValue];
            }
            else if (region_id == REGION_MIDDLE_TOP && [region6ProbArray count] > 0) {
                int rand = (int)arc4random_uniform((unsigned int)[region6ProbArray count]);
                
                NSNumber *prod_action = [region6ProbArray objectAtIndex:rand];
                guess_region_id = [prod_action intValue];
            }
            else if (region_id == REGION_RIGHT_BOTTOM && [region7ProbArray count] > 0) {
                int rand = (int)arc4random_uniform((unsigned int)[region7ProbArray count]);
                
                NSNumber *prod_action = [region7ProbArray objectAtIndex:rand];
                guess_region_id = [prod_action intValue];
            }
            else if (region_id == REGION_RIGHT_MIDDLE && [region8ProbArray count] > 0) {
                int rand = (int)arc4random_uniform((unsigned int)[region8ProbArray count]);
                
                NSNumber *prod_action = [region8ProbArray objectAtIndex:rand];
                guess_region_id = [prod_action intValue];
            }
            else if (region_id == REGION_RIGHT_TOP && [region9ProbArray count] > 0) {
                int rand = (int)arc4random_uniform((unsigned int)[region9ProbArray count]);
                
                NSNumber *prod_action = [region9ProbArray objectAtIndex:rand];
                guess_region_id = [prod_action intValue];
            }
            
            NSLog(@"+++++++++++++++++++++++++++++");
            NSLog(@"++++++++ GUESSING player in region: %@", [self getRegionStr: guess_region_id]);
            NSLog(@"+++++++++++++++++++++++++++++");
            
            //based on this new estimated region, modify the enemyTank_lastknown_x and _y
            
            CGPoint guess_xy = [self getXYByRegionId:guess_region_id Bounds:bounds];
            
            if (guess_xy.x != -1 && guess_xy.y != -1) {
                enemyTank_lastknown_x = guess_xy.x;
                enemyTank_lastknown_y = guess_xy.y;
            }
            
        }
        
        ticksBeforeAdjustLastXY = 0;
    }
    
    //distance from enemy
    CGFloat distance = [self getDistanceFromX:enemyTank_lastknown_x Y:enemyTank_lastknown_y];
    
//    NSLog(@"distance sq: %f" , distance);
    
    if (enemyTank_lastknown_x == -1 && enemyTank_lastknown_y == -1) return;
    
    //=== Detect bullet and evade if needed (high priority)
    
    NSMutableArray* bullets = [host.battleStage getAllBullets];
    NSUInteger numBullets = [bullets count];
    CGFloat closetBulletDistance = 0;
    int closet_bullet_region_id = -1;
    STABullet* closetBullet = nil;
    for (int i=0; i < numBullets; i++) {
        STABullet* bullet = [bullets objectAtIndex:i];
        if (bullet.ownerId != host.playerId) {
            int bullet_region_id = [self getRegionForX:bullet.position.x Y:bullet.position.y];
            if (bullet_region_id == -1) continue;
            
            //find the distance, only evade the closest one
            CGFloat distance = [self getDistanceFromX:bullet.position.x Y:bullet.position.y];
            if (distance > closetBulletDistance) {
                closetBulletDistance = distance;
                closetBullet = bullet;
                closet_bullet_region_id = bullet_region_id;
            }
        }
    }
    
    int evade_region_id = -1;
    if (closetBullet != nil) {
        
        BOOL isNeedEvade = false;
        
        
//        NSLog(@"bounds: %f/%f/%f/%f", bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
//        NSLog(@"bullet region: %@, num bullets: %lu, x: %f y: %f" ,
//              [self getRegionStr:bullet_region_id], (unsigned long)numBullets,
//              closetBullet.position.x,closetBullet.position.y);
        
//        NSMutableArray* evadeBulletProbArray;
//        if (distance < shortRange) {
//            evadeBulletProbArray = evadeBulletProbArrayShort;
//        }
//        else if (distance < midRange) {
//            evadeBulletProbArray = evadeBulletProbArrayMid;
//        }
//        else {
//            evadeBulletProbArray = evadeBulletProbArrayLong;
//        }
//        
//        if ([evadeBulletProbArray count] > 0) {
//            int rand = (int)arc4random_uniform((unsigned int)[evadeBulletProbArray count]);
//            
//            NSNumber *prod_action = [evadeBulletProbArray objectAtIndex:rand];
//            int prod_act_int = [prod_action intValue];
//            
//            if (prod_act_int == YES) {
//                
//                
        
        //evade base on the bullet's own rotation radian
        //also the bullet is actually aimming at the tank!
        
        //y-y1 = m(x-x1)
        //m is the slope (y/x)
        //y/x = tan(radian)
        //(y-y1)/(x-x1) = tan(radian)
        //randian = arctan(y_diff/x_diff)
        
        //slope = -2.7723966927368662
        //bullet_slope = -2.0506427100254951
        
        //degree depends on the distance too. the shorter the distance, the degree can have bigger margin to hit!
        
        //y+, x+: arc_slope_real_degree = arc_slope_degree
        //t_r about 0' : slope = 0.082085, arc_slope_radian = 0.081901(4.692596'), closetBullet.zRotation: 0.000891(0.051060')
        //t_r about 30': slope = 0.599615, arc_slope_radian = 0.540136(30.94753'), closetBullet.zRotation: 0.314156(17.999835')
        //t_r about 45': slope = 0.905726, arc_slope_radian = 0.735969(42.16794'), closetBullet.zRotation: 0.489273(28.033253')
        //t_r about 60': slope = 1.840613, arc_slope_radian = 1.073114(61.48489'), closetBullet.zRotation: 0.837726(47.998147')
        //t_r about 90': slope = 186.4628, arc_slope_radian = 1.565433(89.69272'), closetBullet.zRotation: 1.570811(90.000843')
        
        //y+, x-: arc_slope_real_degree = 180+arc_slope_degree
        //t_l about 90': slope = -18.9304, arc_slope_radian = -1.518020(-86.976'), closetBullet.zRotation: 1.606076(92.021390')
        //t_l about 60': slope = -2.04753, arc_slope_radian = -1.116477(-63.969'), closetBullet.zRotation: 1.919280(109.96667')
        //t_l about 45': slope = -0.85460, arc_slope_radian = -0.707161(-40.517'), closetBullet.zRotation: 2.514082(144.04631')
//180degree     //t_l about 0' : slope = 0.052224, arc_slope_radian = 0.052177(2.989513'), closetBullet.zRotation: 3.141517(179.99565')
        
        //y-, x-: arc_slope_real_degree = 180+arc_slope_degree
        //b_l about 0' : slope = 0.024342, arc_slope_radian = 0.024337(1.394409'), closetBullet.zRotation: -3.106715(-178.001683')
        //b_l about 30': slope = 0.444857, arc_slope_radian = 0.418569(23.98224'), closetBullet.zRotation: -2.652930(-152.001666')
        //b_l about 45': slope = 0.900370, arc_slope_radian = 0.733020(41.99892'), closetBullet.zRotation: -2.443871(-140.023495')
        //b_l about 60': slope = 4.026196, arc_slope_radian = 1.327349(76.05150'), closetBullet.zRotation: -1.918819(-109.940214')
        //b_l about 90': slope = 27.86663, arc_slope_radian = 1.534927(87.94481'), closetBullet.zRotation: -1.570325(-89.973023')
        
        //y-, x+: arc_slope_real_degree = 360+arc_slope_degree
        //b_r about 90': slope = -12.1642, arc_slope_radian = -1.48877(-85.3003'), closetBullet.zRotation: -1.569170(-89.906811')
        //b_r about 60': slope = -2.52964, arc_slope_radian = -1.194336(-68.430'), closetBullet.zRotation: -1.117934(-64.052906')
        //b_r about 45': slope = -1.19715, arc_slope_radian = -0.874887(-50.127'), closetBullet.zRotation: -0.697137(-39.943011')
        //b_r about 30': slope = -0.82220, arc_slope_radian = -0.688132(-39.427'), closetBullet.zRotation: -0.454643(-26.049107')
        //b_r about 0' : slope = -0.00593, arc_slope_radian = -0.005925(-0.3394'), closetBullet.zRotation: -0.069028(-3.955030')
        
        
        CGFloat y_diff = host.position.y - closetBullet.position.y;
        CGFloat x_diff = host.position.x - closetBullet.position.x;

        CGFloat slope = y_diff/x_diff;
        
        CGFloat arc_slope_radian = atan(slope);
        CGFloat arc_slope_degree = arc_slope_radian * 180/ M_PI;
        
        NSLog(@"slope = %f, arc_slope_radian = %f(%f'), closetBullet.zRotation: %f(%f')",slope,arc_slope_radian,arc_slope_degree,closetBullet.zRotation,closetBullet.zRotation*180/M_PI);
        NSLog(@"y_diff= %f, x_diff = %f", y_diff, x_diff);
        
        BOOL isUnknown = false;
        CGFloat arc_slope_real_degree = arc_slope_degree;
        if (y_diff > 0) {
            if (x_diff > 0) {
                arc_slope_real_degree = arc_slope_degree;
            }
            else if (x_diff < 0) {
                arc_slope_real_degree = 180+arc_slope_degree;
            }
            else if (x_diff == 0) {
                arc_slope_real_degree = 90;
            }
        }
        else if (y_diff < 0) {
            if (x_diff > 0) {
                arc_slope_real_degree = 360+arc_slope_degree;
            }
            else if (x_diff < 0) {
                arc_slope_real_degree = 180+arc_slope_degree;
            }
            else if (x_diff == 0) {
                arc_slope_real_degree = 270;
            }
        }
        else if (y_diff == 0) {
            if (x_diff > 0) {
                arc_slope_real_degree = 0;
            }
            else if (x_diff < 0) {
                arc_slope_real_degree = 180;
            }
            else if (x_diff == 0) {
                isUnknown = true;
            }
        }
        
        CGFloat closest_bullet_real_degree = closetBullet.zRotation*180/M_PI;
        if (closest_bullet_real_degree < 0) {
            closest_bullet_real_degree = 360 + closest_bullet_real_degree;
        }
        
        if (!isUnknown) {
            CGFloat bullet_distance = [self getDistanceFromX:closetBullet.position.x Y:closetBullet.position.y];
            
            CGFloat degree_margin = evadeDegreeMarginLong; //long range: needs to be really accurate
            if (bullet_distance < shortRange) {
                degree_margin = evadeDegreeMarginShort;
            }
            else if (bullet_distance < midRange) {
                degree_margin = evadeDegreeMarginMid;
            }
            
            CGFloat arc_slope_real_degree_min = arc_slope_real_degree - degree_margin;
            CGFloat arc_slope_real_degree_max = arc_slope_real_degree + degree_margin;
            
            if (arc_slope_real_degree_min < 0) {
                arc_slope_real_degree_min = 360 + arc_slope_real_degree_min;
            }
            else if (arc_slope_real_degree_max > 360) {
                arc_slope_real_degree_max = arc_slope_real_degree_max - 360;
            }
            
            if (arc_slope_real_degree_min > arc_slope_real_degree_max) {
                if ((closest_bullet_real_degree <= 360 && closest_bullet_real_degree >= arc_slope_real_degree_min) ||
                    (closest_bullet_real_degree > 0 && closest_bullet_real_degree <= arc_slope_real_degree_max )) {
                    isNeedEvade = true;
                }
            }
            else if (closest_bullet_real_degree <= arc_slope_real_degree_max &&
                     closest_bullet_real_degree >= arc_slope_real_degree_min) { //normal cases
                isNeedEvade = true;
            }
        }
        
        if (isNeedEvade) {
            //based on the bullet's direction, add around 90degree
            
            //arc_slope == closetBullet.zRotation?
//            CGFloat bullet_slope = tan(closetBullet.zRotation);
            
            CGFloat evade_radian = closetBullet.zRotation + M_PI/2;
            
            CGFloat degree1DiffFromLast = evade_radian - (host.zRotation + M_PI/2);
            
            CGFloat degree2 = degree1DiffFromLast-M_PI * 2;
            CGFloat degree_to_use = degree1DiffFromLast;
            
            if (fabs(degree2) < fabs(degree1DiffFromLast)) {
                degree_to_use=degree2;
            }
            
            //
            CGFloat evade_radian_2 = closetBullet.zRotation - M_PI/2;
            
            CGFloat degree1DiffFromLast_2 = evade_radian_2 - (host.zRotation + M_PI/2);
            
            CGFloat degree2_2 = degree1DiffFromLast_2-M_PI * 2;
            CGFloat degree_to_use_2 = degree1DiffFromLast_2;
            
            if (fabs(degree2_2) < fabs(degree1DiffFromLast_2)) {
                degree_to_use_2=degree2_2;
            }
            
            CGFloat real_degree_to_use = degree_to_use;
            if (fabs(degree_to_use_2) < fabs(degree_to_use)) {
                real_degree_to_use = degree_to_use_2;
            }
            
            isRotating = true;
            [host rotateInDegree:real_degree_to_use  complete:^(void) {
                isRotating = false;
                
                int rand = (int)arc4random_uniform((unsigned int)[evadeDirectionProbArray count]);
                
                NSNumber *prod_action = [evadeDirectionProbArray objectAtIndex:rand];
                int evade_dir_id = [prod_action intValue];
                
                //determine to move forward or backward..
                if (evade_dir_id == YES) {
                    [host moveForward];
                }
                else {
                    [host moveBackward];
                }
            }];
            
            evadingTicks = 1000;
        }
        
                /*
                
                int my_region_id = [self getRegionForX:host.position.x Y:host.position.y];
                
                evade_region_id = [self findEvadeRegionIdByMyRegionId:my_region_id BulletRegionId:closet_bullet_region_id];
                
                NSLog(@"bullet region: %@, my region: %@, evade region: %@",
                      [self getRegionStr:closet_bullet_region_id],
                      [self getRegionStr:my_region_id],
                      [self getRegionStr:evade_region_id]);
                
                CGPoint evade_xy = [self getXYByRegionId:(int)evade_region_id Bounds:bounds];
                
                if (evade_xy.x != -1 && evade_xy.y != -1) {
                    NSLog(@"\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\");
                    NSLog(@"\\\\\\\\\\\\\\\\ EVADINGGGGGG \\\\\\\\\\\\");
                    NSLog(@"\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\");
                    [host stop];
                    [self approach_LastX:evade_xy.x LastY:evade_xy.y];
                    evadingTicks = 10;  //todo: <= this kind of related to the movespeed
                    return;
                }
                 */
        
        
//            }
//        }
        
    } //closeBullet == null
    
    //=========================
    
    if (![self isAvailableForAction]) {
        //depending on certain conditions, stop the current action.
        
        //==== Condition 1 (critical): Evade bullet(s)
        //detect bullet(s) and try to avoid them if is close..
        
        
        
        //==== Condition 2: Distance Change
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
            if ([chancesStopActionDistanceChangeProbArray count] > 0) {
                int rand = (int)arc4random_uniform([chancesStopActionDistanceChangeProbArray count]);
                
                NSNumber *prod_action = [chancesStopActionDistanceChangeProbArray objectAtIndex:rand];
                int prod_act_int = [prod_action intValue];
                
                if (prod_act_int == YES) {
                    [host stop];
                }
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
            
            if ([revealedActionProbArrayShort count] > 0) {
                int rand = (int)arc4random_uniform([revealedActionProbArrayShort count]);
                
                NSNumber *prod_action = [revealedActionProbArrayShort objectAtIndex:rand];
                int prod_act_int = [prod_action intValue];
                
                if (prod_act_int == APPROACH_PROB_KEY) {
                    NSLog(@"revealed: approaching");
                    [self approach_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y];
                }
                else if (prod_act_int == WARNSHOT_PROB_KEY) {
                    NSLog(@"revealed: try warning shot");
                    if (!isAttackCoolDown) {
                        NSLog(@"revealed: warning shot");
                        [host stop];
                        [self attack_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y];
                    }
                }
                else if (prod_act_int == EVADE_PROB_KEY) {
                    NSLog(@"revealed: evade");
                    [self evadeFrom_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y LastRotation:lastRotation];
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
        }
        else if (distance < midRange) {
            enemyTank_lastknown_distance = DISTANCE_MID;
            
            if ([revealedActionProbArrayMid count] > 0) {
                int rand = (int)arc4random_uniform([revealedActionProbArrayMid count]);
                
                NSNumber *prod_action = [revealedActionProbArrayMid objectAtIndex:rand];
                int prod_act_int = [prod_action intValue];
                
                if (prod_act_int == APPROACH_PROB_KEY) {
                    NSLog(@"revealed: approaching");
                    [self approach_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y];
                }
                else if (prod_act_int == WARNSHOT_PROB_KEY) {
                    NSLog(@"revealed: try warning shot");
                    if (!isAttackCoolDown) {
                        NSLog(@"revealed: warning shot");
                        [host stop];
                        [self attack_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y];
                    }
                }
                else if (prod_act_int == EVADE_PROB_KEY) {
                    NSLog(@"revealed: evade");
                    [self evadeFrom_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y LastRotation:lastRotation];
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
        }
        else {
            enemyTank_lastknown_distance = DISTANCE_LONG;
            
            if ([revealedActionProbArrayLong count] > 0) {
                int rand = (int)arc4random_uniform([revealedActionProbArrayLong count]);
                
                NSNumber *prod_action = [revealedActionProbArrayLong objectAtIndex:rand];
                int prod_act_int = [prod_action intValue];
                
                if (prod_act_int == APPROACH_PROB_KEY) {
                    NSLog(@"revealed: approaching");
                    [self approach_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y];
                }
                else if (prod_act_int == WARNSHOT_PROB_KEY) {
                    NSLog(@"revealed: try warning shot");
                    if (!isAttackCoolDown) {
                        NSLog(@"revealed: warning shot");
                        [host stop];
                        [self attack_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y];
                    }
                }
                else if (prod_act_int == EVADE_PROB_KEY) {
                    NSLog(@"revealed: evade");
                    [self evadeFrom_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y LastRotation:lastRotation];
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
        }
        
    }
    else {
        NSLog(@"player go stealth..");
        //if no other actions are in progress
        if (distance < shortRange) {
            enemyTank_lastknown_distance = DISTANCE_SHORT;
            
            if ([stealthActionProbArrayShort count] > 0) {
                int rand = (int)arc4random_uniform([stealthActionProbArrayShort count]);
                
                NSNumber *prod_action = [stealthActionProbArrayShort objectAtIndex:rand];
                int prod_act_int = [prod_action intValue];
                
                if (prod_act_int == APPROACH_PROB_KEY) {
                    NSLog(@"stealth: approaching");
                    [self approach_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y];
                }
                else if (prod_act_int == WARNSHOT_PROB_KEY) {
                    NSLog(@"stealth: try warning shot");
                    if (!isAttackCoolDown) {
                        NSLog(@"stealth: warning shot");
                        [host stop];
                        [self attack_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y];
                    }
                }
                else if (prod_act_int == EVADE_PROB_KEY) {
                    NSLog(@"stealth: evade");
                    [self evadeFrom_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y LastRotation:lastRotation];
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
        else if (distance < midRange) {
            enemyTank_lastknown_distance = DISTANCE_MID;
            NSLog(@"stealh: mid range.. approaching");
            
            if ([stealthActionProbArrayMid count] > 0) {
                int rand = (int)arc4random_uniform([stealthActionProbArrayMid count]);
                
                NSNumber *prod_action = [stealthActionProbArrayMid objectAtIndex:rand];
                int prod_act_int = [prod_action intValue];
                
                if (prod_act_int == APPROACH_PROB_KEY) {
                    NSLog(@"stealth: approaching");
                    [self approach_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y];
                }
                else if (prod_act_int == WARNSHOT_PROB_KEY) {
                    NSLog(@"stealth: try warning shot");
                    if (!isAttackCoolDown) {
                        NSLog(@"stealth: warning shot");
                        [host stop];
                        [self attack_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y];
                    }
                }
                else if (prod_act_int == EVADE_PROB_KEY) {
                    NSLog(@"stealth: evade");
                    [self evadeFrom_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y LastRotation:lastRotation];
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
        }
        else { //long range
            enemyTank_lastknown_distance = DISTANCE_LONG;
            NSLog(@"stealh: long range.. approaching");
            
            if ([stealthActionProbArrayLong count] > 0) {
                int rand = (int)arc4random_uniform([stealthActionProbArrayLong count]);
                
                NSNumber *prod_action = [stealthActionProbArrayLong objectAtIndex:rand];
                int prod_act_int = [prod_action intValue];
                
                if (prod_act_int == APPROACH_PROB_KEY) {
                    NSLog(@"stealth: approaching");
                    [self approach_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y];
                }
                else if (prod_act_int == WARNSHOT_PROB_KEY) {
                    NSLog(@"stealth: try warning shot");
                    if (!isAttackCoolDown) {
                        [host stop];
                        NSLog(@"stealth: warning shot");
                        [self attack_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y];
                    }
                }
                else if (prod_act_int == EVADE_PROB_KEY) {
                    NSLog(@"stealth: evade");
                    [self evadeFrom_LastX:enemyTank_lastknown_x LastY:enemyTank_lastknown_y LastRotation:lastRotation];
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

-(CGFloat)getDistanceFromX:(CGFloat)lastX Y:(CGFloat)lastY {
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
    int rand_dir = arc4random_uniform(2);
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

-(NSString*)getRegionStr:(int)region_id {
    if (region_id == 1) {
        return @"left_bottom";
    }
    else if (region_id == 2) {
        return @"left_middle";
    }
    else if (region_id == 3) {
        return @"left_top";
    }
    else if (region_id == 4) {
        return @"middle_bottom";
    }
    else if (region_id == 5) {
        return @"middle_middle";
    }
    else if (region_id == 6) {
        return @"middle_top";
    }
    else if (region_id == 7) {
        return @"right_bottom";
    }
    else if (region_id == 8) {
        return @"right_middle";
    }
    else if (region_id == 9) {
        return @"right_top";
    }
    
    return @"unknown region";
}

-(void) stupid {
    
}

-(BOOL) isAvailableForAction {
    return !isApproaching;
}

//3 6 9
//2 5 8
//1 4 7
-(int)findEvadeRegionIdByMyRegionId:(int)my_region_id BulletRegionId:(int)bullet_region_id {
    if (bullet_region_id == 1) {
        if (my_region_id == 1) {
            int rand = arc4random_uniform(3);
            if (rand == 0) {
                return 2;
            }
            else if (rand == 1) {
                return 5;
            }
            else if (rand == 2) {
                return 4;
            }
        }
        else if (my_region_id == 2) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 3;
            }
            else if (rand == 1) {
                return 6;
            }
            else if (rand == 2) {
                return 5;
            }
            else if (rand == 3) {
                return 4;
            }
        }
        else if (my_region_id == 4) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 2;
            }
            else if (rand == 1) {
                return 5;
            }
            else if (rand == 2) {
                return 8;
            }
            else if (rand == 3) {
                return 7;
            }
        }
        else if (my_region_id == 5) {
            int rand = arc4random_uniform(7);
            if (rand == 0) {
                return 2;
            }
            else if (rand == 1) {
                return 3;
            }
            else if (rand == 2) {
                return 4;
            }
            else if (rand == 3) {
                return 6;
            }
            else if (rand == 4) {
                return 7;
            }
            else if (rand == 5) {
                return 8;
            }
            else if (rand == 6) {
                return 9;
            }
        }
    }
    else if (bullet_region_id == 2) {
        //1,2,3,4,5,6
        if (my_region_id == 1) {
            int rand = arc4random_uniform(2);
            if (rand == 0) {
                return 4;
            }
            else if (rand == 1) {
                return 5;
            }
        }
        else if (my_region_id == 2) {
            int rand = arc4random_uniform(5);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 3;
            }
            else if (rand == 2) {
                return 4;
            }
            else if (rand == 3) {
                return 5;
            }
            else if (rand == 4) {
                return 6;
            }
        }
        else if (my_region_id == 3) {
            int rand = arc4random_uniform(2);
            if (rand == 0) {
                return 6;
            }
            else if (rand == 1) {
                return 5;
            }
        }
        else if (my_region_id == 4) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 5;
            }
            else if (rand == 2) {
                return 8;
            }
            else if (rand == 3) {
                return 7;
            }
        }
        else if (my_region_id == 5) {
            int rand = arc4random_uniform(7);
            if (rand == 0) {
                return 2;
            }
            else if (rand == 1) {
                return 3;
            }
            else if (rand == 2) {
                return 4;
            }
            else if (rand == 3) {
                return 6;
            }
            else if (rand == 4) {
                return 7;
            }
            else if (rand == 5) {
                return 8;
            }
            else if (rand == 6) {
                return 9;
            }
        }
        else if (my_region_id == 6) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 3;
            }
            else if (rand == 1) {
                return 5;
            }
            else if (rand == 2) {
                return 8;
            }
            else if (rand == 3) {
                return 9;
            }
        }
    }
    else if (bullet_region_id == 3) {
        //2,3,5,6
        if (my_region_id == 2) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 4;
            }
            else if (rand == 2) {
                return 5;
            }
            else if (rand == 3) {
                return 6;
            }
        }
        else if (my_region_id == 3) {
            int rand = arc4random_uniform(3);
            if (rand == 0) {
                return 2;
            }
            else if (rand == 1) {
                return 5;
            }
            else if (rand == 2) {
                return 6;
            }
        }
        else if (my_region_id == 5) {
            int rand = arc4random_uniform(7);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 4;
            }
            else if (rand == 3) {
                return 6;
            }
            else if (rand == 4) {
                return 7;
            }
            else if (rand == 5) {
                return 8;
            }
            else if (rand == 6) {
                return 9;
            }
        }
        else if (my_region_id == 6) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 2;
            }
            else if (rand == 1) {
                return 5;
            }
            else if (rand == 2) {
                return 8;
            }
            else if (rand == 3) {
                return 9;
            }
        }
    }
    //3 6 9
    //2 5 8
    //1 4 7
    else if (bullet_region_id == 4) {
        if (my_region_id == 1) {
            int rand = arc4random_uniform(2);
            if (rand == 0) {
                return 2;
            }
            else if (rand == 1) {
                return 5;
            }
        }
        else if (my_region_id == 2) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 3;
            }
            else if (rand == 2) {
                return 5;
            }
            else if (rand == 3) {
                return 6;
            }
        }
        else if (my_region_id == 4) {
            int rand = arc4random_uniform(5);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 5;
            }
            else if (rand == 3) {
                return 7;
            }
            else if (rand == 4) {
                return 8;
            }
        }
        else if (my_region_id == 5) {
            int rand = arc4random_uniform(7);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 3;
            }
            else if (rand == 3) {
                return 6;
            }
            else if (rand == 4) {
                return 7;
            }
            else if (rand == 5) {
                return 8;
            }
            else if (rand == 6) {
                return 9;
            }
        }
        else if (my_region_id == 7) {
            int rand = arc4random_uniform(2);
            if (rand == 0) {
                return 5;
            }
            else if (rand == 1) {
                return 8;
            }
        }
        else if (my_region_id == 8) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 6;
            }
            else if (rand == 1) {
                return 9;
            }
            else if (rand == 2) {
                return 5;
            }
            else if (rand == 3) {
                return 7;
            }
        }
    }
    //3 6 9
    //2 5 8
    //1 4 7
    else if (bullet_region_id == 5) {
        //1,2,3,4,5,6,7,8,9
        if (my_region_id == 1) {
            int rand = arc4random_uniform(2);
            if (rand == 0) {
                return 2;
            }
            else if (rand == 1) {
                return 4;
            }
        }
        else if (my_region_id == 2) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 3;
            }
            else if (rand == 2) {
                return 4;
            }
            else if (rand == 3) {
                return 6;
            }
        }
        else if (my_region_id == 3) {
            int rand = arc4random_uniform(2);
            if (rand == 0) {
                return 2;
            }
            else if (rand == 1) {
                return 6;
            }
        }
        else if (my_region_id == 4) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 7;
            }
            else if (rand == 3) {
                return 8;
            }
        }
        else if (my_region_id == 5) {
            int rand = arc4random_uniform(8);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 3;
            }
            else if (rand == 3) {
                return 4;
            }
            else if (rand == 4) {
                return 6;
            }
            else if (rand == 5) {
                return 7;
            }
            else if (rand == 6) {
                return 8;
            }
            else if (rand == 7) {
                return 9;
            }
        }
        else if (my_region_id == 6) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 3;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 8;
            }
            else if (rand == 3) {
                return 9;
            }
        }
        else if (my_region_id == 7) {
            int rand = arc4random_uniform(2);
            if (rand == 0) {
                return 4;
            }
            else if (rand == 1) {
                return 8;
            }
        }
        else if (my_region_id == 8) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 4;
            }
            else if (rand == 1) {
                return 7;
            }
            else if (rand == 2) {
                return 6;
            }
            else if (rand == 3) {
                return 9;
            }
        }
        else if (my_region_id == 9) {
            int rand = arc4random_uniform(2);
            if (rand == 0) {
                return 6;
            }
            else if (rand == 1) {
                return 8;
            }
        }
    }
    //3 6 9
    //2 5 8
    //1 4 7
    else if (bullet_region_id == 6) {
        //2,3,5,6,8,9
        if (my_region_id == 2) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 4;
            }
            else if (rand == 2) {
                return 5;
            }
            else if (rand == 3) {
                return 3;
            }
        }
        else if (my_region_id == 3) {
            int rand = arc4random_uniform(2);
            if (rand == 0) {
                return 2;
            }
            else if (rand == 1) {
                return 5;
            }
        }
        else if (my_region_id == 5) {
            int rand = arc4random_uniform(7);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 3;
            }
            else if (rand == 3) {
                return 4;
            }
            else if (rand == 4) {
                return 7;
            }
            else if (rand == 5) {
                return 8;
            }
            else if (rand == 6) {
                return 9;
            }
        }
        else if (my_region_id == 6) {
            int rand = arc4random_uniform(5);
            if (rand == 0) {
                return 3;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 5;
            }
            else if (rand == 3) {
                return 8;
            }
            else if (rand == 4) {
                return 9;
            }
        }
        else if (my_region_id == 8) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 9;
            }
            else if (rand == 1) {
                return 4;
            }
            else if (rand == 2) {
                return 5;
            }
            else if (rand == 3) {
                return 7;
            }
        }
        else if (my_region_id == 9) {
            int rand = arc4random_uniform(2);
            if (rand == 0) {
                return 5;
            }
            else if (rand == 1) {
                return 8;
            }
        }
    }
    //3 6 9
    //2 5 8
    //1 4 7
    else if (bullet_region_id == 7) {
        //4,5,7,8
        if (my_region_id == 4) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 5;
            }
            else if (rand == 3) {
                return 8;
            }
        }
        else if (my_region_id == 5) {
            int rand = arc4random_uniform(7);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 3;
            }
            else if (rand == 3) {
                return 4;
            }
            else if (rand == 4) {
                return 6;
            }
            else if (rand == 5) {
                return 8;
            }
            else if (rand == 6) {
                return 9;
            }
        }
        else if (my_region_id == 7) {
            int rand = arc4random_uniform(3);
            if (rand == 0) {
                return 4;
            }
            else if (rand == 1) {
                return 5;
            }
            else if (rand == 2) {
                return 8;
            }
        }
        else if (my_region_id == 8) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 4;
            }
            else if (rand == 1) {
                return 5;
            }
            else if (rand == 2) {
                return 6;
            }
            else if (rand == 3) {
                return 9;
            }
        }
    }
    //3 6 9
    //2 5 8
    //1 4 7
    else if (bullet_region_id == 8) {
        //4,5,6,7,8,9
        if (my_region_id == 4) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 5;
            }
            else if (rand == 3) {
                return 7;
            }
        }
        else if (my_region_id == 5) {
            int rand = arc4random_uniform(7);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 3;
            }
            else if (rand == 3) {
                return 4;
            }
            else if (rand == 4) {
                return 6;
            }
            else if (rand == 5) {
                return 7;
            }
            else if (rand == 6) {
                return 9;
            }
        }
        else if (my_region_id == 6) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 3;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 5;
            }
            else if (rand == 3) {
                return 9;
            }
        }
        else if (my_region_id == 7) {
            int rand = arc4random_uniform(2);
            if (rand == 0) {
                return 4;
            }
            else if (rand == 1) {
                return 5;
            }
        }
        else if (my_region_id == 8) {
            int rand = arc4random_uniform(5);
            if (rand == 0) {
                return 4;
            }
            else if (rand == 1) {
                return 5;
            }
            else if (rand == 2) {
                return 6;
            }
            else if (rand == 3) {
                return 7;
            }
            else if (rand == 4) {
                return 9;
            }
        }
        else if (my_region_id == 9) {
            int rand = arc4random_uniform(2);
            if (rand == 0) {
                return 6;
            }
            else if (rand == 1) {
                return 5;
            }
        }
    }
    //3 6 9
    //2 5 8
    //1 4 7
    else if (bullet_region_id == 9) {
        //5,6,8,9
        if (my_region_id == 5) {
            int rand = arc4random_uniform(7);
            if (rand == 0) {
                return 1;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 3;
            }
            else if (rand == 3) {
                return 4;
            }
            else if (rand == 4) {
                return 6;
            }
            else if (rand == 5) {
                return 7;
            }
            else if (rand == 6) {
                return 8;
            }
        }
        else if (my_region_id == 6) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 3;
            }
            else if (rand == 1) {
                return 2;
            }
            else if (rand == 2) {
                return 5;
            }
            else if (rand == 3) {
                return 8;
            }
        }
        else if (my_region_id == 8) {
            int rand = arc4random_uniform(4);
            if (rand == 0) {
                return 4;
            }
            else if (rand == 1) {
                return 5;
            }
            else if (rand == 2) {
                return 6;
            }
            else if (rand == 3) {
                return 7;
            }
        }
        else if (my_region_id == 9) {
            int rand = arc4random_uniform(3);
            if (rand == 0) {
                return 6;
            }
            else if (rand == 1) {
                return 5;
            }
            else if (rand == 2) {
                return 8;
            }
        }
    }
    
    return -1;
}

-(CGPoint) getXYByRegionId:(int)p_region_id Bounds:(CGRect)p_bounds {
    
    CGFloat block_width = p_bounds.size.width/3;
    CGFloat block_height = p_bounds.size.height/3;
    CGFloat right_x = p_bounds.origin.x+bounds.size.width;
    CGFloat top_y = p_bounds.origin.y+bounds.size.height;
    
    CGFloat new_x = -1;
    CGFloat new_y = -1;
    
    int region_id=1;
    BOOL isFound = false;
    for (CGFloat x = p_bounds.origin.x; x < right_x && !isFound; x+=block_width) {
        for (CGFloat y = p_bounds.origin.y; y < top_y && !isFound; y+=block_height) {
            if (p_region_id == region_id) {
                //find the mid point of this region, and randomize a point in it
                int rand_x = (int)arc4random_uniform(block_width/2);
                int rand_y = (int)arc4random_uniform(block_height/2);
                
                int rand_xdir = arc4random_uniform(2);
                if (rand_xdir == 1) {
                    rand_x *= -1;
                }
                int rand_ydir = arc4random_uniform(2);
                if (rand_ydir == 1) {
                    rand_y *= -1;
                }
                
                new_x = x + block_width/2 + rand_x;
                new_y = y + block_height/2 + rand_y;
                
                isFound = true;
                break;
            }
            region_id++;
        }
    }
    
    return CGPointMake(new_x, new_y);
}

@end
