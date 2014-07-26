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
    STATank* host;
}
@end

@implementation STAAI

@synthesize stage;

- (id)initWithStage:(STABattleStage*)b_stage {
    self = [super init];
    if (self) {
        stage = b_stage;
        enemyTank_lastknown_x=-1;
        enemyTank_lastknown_y=-1;
    }
    return self;
}

-(void)setHost:(STATank*)t_host {
    host = t_host;
}

-(void)think {
    NSLog(@"thinking");
    
    STATank* player = [stage player];
    CGFloat lastX = [player lastX];
    CGFloat lastY = [player lastY];
    CGVector lastDirection = [player lastDirection];
    CGFloat lastRotation = [player lastRotation];
    
    if (lastX == -1 && lastY == -1) return;
    
    //if last pos is not the same, act!
//    if (enemyTank_lastknown_x != lastX ||
//        enemyTank_lastknown_y != lastY ||
//        enemyTank_lastknown_rotation != lastRotation) {
    if (enemyTank_lastknown_x != lastX ||
        enemyTank_lastknown_y != lastY) {
//        NSLog(@"**** not same! ****");
        
        CGFloat faceRotate = [self calculateAngleX1:host.position.x Y1:host.position.y
                                                 X2:lastX Y2:lastY];
        
        CGFloat degree1 = (M_PI_2-faceRotate) + M_PI_2;
        
        CGFloat degree1DiffFromLast = degree1 - host.zRotation;
        
        CGFloat degree2 = degree1DiffFromLast-M_PI * 2;
        CGFloat degree_to_use = degree1DiffFromLast;
        
        if (fabs(degree2) < fabs(degree1DiffFromLast)) {
            degree_to_use=degree2;
        }
            
        [host rotateInDegree:degree_to_use];
            
        enemyTank_lastknown_x = lastX;
        enemyTank_lastknown_y = lastY;
        enemyTank_lastknown_rotation = lastRotation;
    }
    
    /*
        get the reference of enemy tank
        if (isVisible) {
            update its last x/y position
        }
        else {

        }
     */
    
}

-(void)faceEnemy {
    //my current zRotation
    CGFloat myRotate = host.zRotation;
    CGFloat myX = host.position.x;
    CGFloat myY = host.position.y;
    
//    enemyTank_lastknown_x
    
}

-(CGFloat) calculateAngleX1:(CGFloat)x1 Y1:(CGFloat)y1 X2:(CGFloat)x2 Y2:(CGFloat)y2 {
    
    CGFloat x = x2-x1;
    CGFloat y = y2-y1;
    CGFloat baseangle = atan2(-x,-y);
    
    return baseangle;
}

@end
