//
//  STAShotgunTank.m
//  StealthAttack
//
//  Created by Ronald Lee on 8/17/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAShotgunTank.h"

@implementation STAShotgunTank

- (id)initWithScale:(CGFloat)f_scale Id:(int)t_id BodyColor:tankBodyColor BodyBaseColor:tankBodyBaseColor
                 AI:(STAAI*) ai Category:(uint32_t)category Bounds:(CGRect)p_bounds {
    
    self = [super initWithScale:f_scale Id:t_id BodyColor:tankBodyColor BodyBaseColor:tankBodyBaseColor
                             AI:ai Category:category Bounds:p_bounds];
    
    self.rotation_speed=3;
    self.moveSpeed = 10;
    self.evadeSpeed= 20;
    
    self.wheel_rotate_speed = 1;
    
    return self;
}

-(void)preAiConfig {
    self.numShots = 3;
    self.betweenShotsAccuracyInRadian = 25;
}

-(void) buildTankBody {
    
    self.tankAl = [SKSpriteNode spriteNodeWithColor:self.tankBodyColor
                                              size:CGSizeMake(self.scaled_width/2,self.scaled_height)];
    [self addChild:self.tankAl];
    self.tankAl.position = CGPointMake(0-self.anchoroffset_x,self.scaled_height*3-self.anchoroffset_y);
    
    self.tankA = [SKSpriteNode spriteNodeWithColor:self.tankBodyColor
                                              size:CGSizeMake(self.scaled_width/2,self.scaled_height)];
    [self addChild:self.tankA];
    self.tankA.position = CGPointMake(self.scaled_width-self.anchoroffset_x,self.scaled_height*3-self.anchoroffset_y);
    
    self.tankAr = [SKSpriteNode spriteNodeWithColor:self.tankBodyColor
                                               size:CGSizeMake(self.scaled_width/2,self.scaled_height)];
    [self addChild:self.tankAr];
    self.tankAr.position = CGPointMake(self.scaled_width*2-self.anchoroffset_x,self.scaled_height*3-self.anchoroffset_y);
    
    //
    
    self.tankB = [SKSpriteNode spriteNodeWithColor:self.tankBodyBaseColor
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankB];
    self.tankB.position = CGPointMake(0-self.anchoroffset_x,self.scaled_height*2-self.anchoroffset_y);
    
    self.tankC = [SKSpriteNode spriteNodeWithColor:self.tankBodyColor
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankC];
    self.tankC.position = CGPointMake(self.scaled_width-self.anchoroffset_x,self.scaled_height*2-self.anchoroffset_y);
    
    self.tankD = [SKSpriteNode spriteNodeWithColor:self.tankBodyBaseColor
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankD];
    self.tankD.position = CGPointMake(self.scaled_width*2-self.anchoroffset_x,self.scaled_height*2-self.anchoroffset_y);
    
    //
    self.tankE = [SKSpriteNode spriteNodeWithColor:self.tankBodyBaseColor
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankE];
    self.tankE.position = CGPointMake(0-self.anchoroffset_x,self.scaled_height-self.anchoroffset_y);
    
    self.tankF = [SKSpriteNode spriteNodeWithColor:self.tankBodyColor
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankF];
    self.tankF.position = CGPointMake(self.scaled_width-self.anchoroffset_x,self.scaled_height-self.anchoroffset_y);
    
    self.tankG = [SKSpriteNode spriteNodeWithColor:self.tankBodyBaseColor
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankG];
    self.tankG.position = CGPointMake(self.scaled_width*2-self.anchoroffset_x,self.scaled_height-self.anchoroffset_y);
    
    
    //
    self.tankH = [SKSpriteNode spriteNodeWithColor:self.tankBodyBaseColor
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankH];
    self.tankH.position = CGPointMake(0-self.anchoroffset_x,0-self.anchoroffset_y);
    
    
    self.tankI = [SKSpriteNode spriteNodeWithColor:self.tankBodyBaseColor
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankI];
    self.tankI.position = CGPointMake(self.scaled_width*2-self.anchoroffset_x,0-self.anchoroffset_y);
    
}


-(void)fadeInThenOut {
    if (!IS_ENABLE_STEALTH) return;
    
    [super fadeInThenOut];
    SKAction* fadeIn=[SKAction fadeInWithDuration:1];
    [self.tankAl runAction:fadeIn];
    [self.tankAr runAction:fadeIn];
}

-(void)fadeOut {
    if (!IS_ENABLE_STEALTH) return;
    
    [super fadeOut];
    SKAction* fadeOut=[SKAction fadeOutWithDuration:1];
    [self.tankAl runAction:fadeOut completion:^() {
        if (self.isGameOver) {
            self.tankAl.alpha = 1.0;
        }
    }];
    [self.tankAr runAction:fadeOut completion:^() {
        if (self.isGameOver) {
            self.tankAr.alpha = 1.0;
        }
    }];
}

-(void) stopFadeOut {
    [super stopFadeOut];
    [self.tankAl removeAllActions];
    [self.tankAr removeAllActions];
}

-(void)fadeInNow {
    if (!IS_ENABLE_STEALTH) return;
    
    self.tankAl.alpha = 1.0;
    self.tankAr.alpha = 1.0;
    
    [super fadeInNow];
}

@end
