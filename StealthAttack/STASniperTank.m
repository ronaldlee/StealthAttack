//
//  STASniperTank.m
//  StealthAttack
//
//  Created by Ronald Lee on 8/17/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STASniperTank.h"

@implementation STASniperTank


- (id)initWithScale:(CGFloat)f_scale Id:(int)t_id BodyColor:tankBodyColor BodyBaseColor:tankBodyBaseColor
                 AI:(STAAI*) ai Category:(uint32_t)category Bounds:(CGRect)p_bounds
                    IsEnableStealth:(BOOL)is_enable_stealth{
    
    self = [super initWithScale:f_scale Id:t_id BodyColor:tankBodyColor BodyBaseColor:tankBodyBaseColor
                             AI:ai Category:category Bounds:p_bounds IsEnableStealth:is_enable_stealth];
    
    self.rotation_speed=2;
    self.moveSpeed = 20;
    self.evadeSpeed= 30;
    
    self.wheel_rotate_speed = 1;
    self.bulletSpeed = 300;
    self.fadeOutDuration = 3;
    
    return self;
}
-(void)preAiConfig {
    self.attackCoolDownDuration = 10;
    self.attackAccuracyInRadian = 15; //less accurate
}

-(void) buildTankBody {
    
    self.tankA = [SKSpriteNode spriteNodeWithColor:self.tankBodyColor
                                              size:CGSizeMake(self.scaled_width/2,self.scaled_height)];
    [self addChild:self.tankA];
    self.tankA.position = CGPointMake(self.scaled_width-self.anchoroffset_x,self.scaled_height*3-self.anchoroffset_y);
    
    //
    self.tankC = [SKSpriteNode spriteNodeWithColor:self.tankBodyColor
                                              size:CGSizeMake(self.scaled_width/2,self.scaled_height)];
    [self addChild:self.tankC];
    self.tankC.position = CGPointMake(self.scaled_width-self.anchoroffset_x,self.scaled_height*2-self.anchoroffset_y);
    
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
    
    self.tankJ = [SKSpriteNode spriteNodeWithColor:self.tankBodyColor
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankJ];
    self.tankJ.position = CGPointMake(self.scaled_width-self.anchoroffset_x,0-self.anchoroffset_y);
    
    self.tankI = [SKSpriteNode spriteNodeWithColor:self.tankBodyBaseColor
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankI];
    self.tankI.position = CGPointMake(self.scaled_width*2-self.anchoroffset_x,0-self.anchoroffset_y);
    
}

-(void)setBodyColor:(UIColor*)color BaseColor:(UIColor*)b_color {
  
    self.tankA.color = color;
    self.tankC.color = color;
    
    self.tankE.color = b_color;
    self.tankF.color = color;
    self.tankG.color = b_color;
    
    self.tankH.color = b_color;
    self.tankJ.color = color;
    self.tankI.color = b_color;
}

-(void) fadeInThenOutPreFadeOut {
    [super fadeInThenOutPreFadeOut];
    
    SKAction* fadeIn=[SKAction fadeInWithDuration:1];
    [self.tankJ runAction:fadeIn];
}

-(void)fadeOut {
    if (!self.isEnableStealth && !self.isGameOver) return;
    
    [super fadeOut];
    SKAction* fadeOut=[SKAction fadeOutWithDuration:self.fadeOutDuration];
    [self.tankJ runAction:fadeOut completion:^() {
        if (self.isGameOver) {
            self.tankJ.alpha = 1.0;
        }
    }];
}

-(void) stopFadeOut {
    [super stopFadeOut];
    [self.tankJ removeAllActions];
}

-(void)fadeInNow {
    if (!self.isEnableStealth) return;
    
    self.tankJ.alpha = 1.0;
    
    [super fadeInNow];
}

-(void)explode {
    //    [super explode];
    
    self.isExploded = true;
    [self removeAllActions];
    
    float f_duration = 2.0;
    float fo_duration = 10;//0.5;
    float r_duration = 2.0;
    
    //hands and eyes just randomly flies away
    [self explodePart:self.tankA XDiff:0 YDiff:30 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    
    [self explodePart:self.tankC XDiff:-20 YDiff:20 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    
    [self explodePart:self.tankE XDiff:30 YDiff:20 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:self.tankF XDiff:10 YDiff:10 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:self.tankG XDiff:-30 YDiff:20 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    
    [self explodePart:self.tankl1 XDiff:-5 YDiff:5 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:self.tankl2 XDiff:15 YDiff:15 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:self.tankl3 XDiff:5 YDiff:10 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:self.tankl4 XDiff:10 YDiff:5 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    
    [self explodePart:self.tankr1 XDiff:5 YDiff:10 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:self.tankr2 XDiff:20 YDiff:5 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:self.tankr3 XDiff:-10 YDiff:10 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:self.tankr4 XDiff:10 YDiff:5 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    
    //    float f_duration = 2.0;
    //    float fo_duration = 10;//0.5;
    //    float r_duration = 2.0;
    
    [self explodePart:self.tankH XDiff:10 YDiff:5 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    
    [self explodePart:self.tankJ XDiff:0 YDiff:10 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    
    [self explodePart:self.tankI XDiff:10 YDiff:5 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    
    [self fadeInNow];
}


@end
