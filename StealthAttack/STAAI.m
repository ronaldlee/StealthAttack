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
    
    NSLog(@"last x: %f, y: %f; rotation: %f; vector dx: %f; dy: %f", lastX, lastY, lastRotation,
          lastDirection.dx, lastDirection.dy);
    
    //if last pos is not the same, act!
    if (enemyTank_lastknown_x != lastX ||
        enemyTank_lastknown_y != lastY ||
        enemyTank_lastknown_rotation != lastRotation) {
        NSLog(@"**** not same! ****");
        
        [host rotateInDegree:lastRotation];
        
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

@end
