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
    BOOL isApproaching;
}
@end

@implementation STAAI

@synthesize stage;
@synthesize accuracyInRadian;

- (id)initWithStage:(STABattleStage*)b_stage {
    self = [super init];
    if (self) {
        stage = b_stage;
        enemyTank_lastknown_x=-1;
        enemyTank_lastknown_y=-1;
        
        accuracyInRadian = 5;
        isApproaching = false;
    }
    return self;
}

-(void)setHost:(STATank*)t_host {
    host = t_host;
}

-(void)think {
//    NSLog(@"thinking");
    
    STATank* player = [stage player];
    
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
//        if (distance > 30000) {
//            //approach
//            [self approach_LastX:lastX LastY:lastY];
//        }
//        else {
//            [host stopMoveToAction];
//            [self attack_LastX:lastX LastY:lastY];
//        }
        enemyTank_lastknown_x = lastX;
        enemyTank_lastknown_y = lastY;
        enemyTank_lastknown_rotation = lastRotation;
    }
    
    if (distance > 100000) {
        //approach
        NSLog(@"approaching");
        [self approach_LastX:lastX LastY:lastY];
    }
    else {
        NSLog(@"attacking");
        [host stopMoveToAction];
        [self attack_LastX:lastX LastY:lastY];
    }

}

-(CGFloat)getDistanceFromEnemy_LastX:(CGFloat)lastX LastY:(CGFloat)lastY {
    CGFloat xDiff = lastX - host.position.x;
    CGFloat yDiff = lastY - host.position.y;
    
    return xDiff*xDiff + yDiff*yDiff;
}

-(void)faceEnemy_LastX:(CGFloat)lastX LastY:(CGFloat)lastY
              Accuracy:(CGFloat)accuracy
              complete:(void (^)() )block{
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
    
    [host rotateInDegree:degree_to_use complete:block];
}

-(void)evade_LastX:(CGFloat)lastX LastY:(CGFloat)lastY Last:(CGFloat)lastRotation{
    
}

-(void)approach_LastX:(CGFloat)lastX LastY:(CGFloat)lastY {
    if (isApproaching) return;
    
    isApproaching = true;
    //calculate accuracy value
    //accuracyInRadian
    CGFloat rand = (CGFloat)arc4random_uniform(accuracyInRadian);
    CGFloat r = rand / (CGFloat)100.0;
    
    r=0;
    
    [self faceEnemy_LastX:lastX LastY:lastY Accuracy:r complete:^(void) {
        [host moveForwardToX:lastX Y:lastY];
    }];
}

-(void)attack_LastX:(CGFloat)lastX LastY:(CGFloat)lastY {
    //calculate accuracy value
    //accuracyInRadian
    CGFloat rand = (CGFloat)arc4random_uniform(accuracyInRadian);
    CGFloat r = rand / (CGFloat)100.0;
    
    [self faceEnemy_LastX:lastX LastY:lastY Accuracy:r complete:^(void) {
        [host fire];
    }];
}

-(CGFloat) calculateAngleX1:(CGFloat)x1 Y1:(CGFloat)y1 X2:(CGFloat)x2 Y2:(CGFloat)y2 {
    
    CGFloat x = x2-x1;
    CGFloat y = y2-y1;
    CGFloat baseangle = atan2(-x,-y);
    
    return baseangle;
}

@end
