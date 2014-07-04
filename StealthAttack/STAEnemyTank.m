//
//  STAEnemyTank.m
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAEnemyTank.h"

@implementation STAEnemyTank

- (id)initWithScale:(CGFloat)f_scale {
    self = [super initWithScale:f_scale];
    
    if (self) {
        self.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    }
    return self;
}

@end
