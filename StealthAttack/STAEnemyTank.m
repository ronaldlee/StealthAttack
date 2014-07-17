//
//  STAEnemyTank.m
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAEnemyTank.h"

@implementation STAEnemyTank

//@synthesize tankA;
//
//@synthesize tankB;
//@synthesize tankC;
//@synthesize tankD;
//@synthesize tankE;
//@synthesize tankF;
//@synthesize tankG;
@synthesize tankH;
@synthesize tankI;

//@synthesize tankl1;
//@synthesize tankl2;
//@synthesize tankl3;
//@synthesize tankl4;
//
//@synthesize tankr1;
//@synthesize tankr2;
//@synthesize tankr3;
//@synthesize tankr4;

- (id)initWithScale:(CGFloat)f_scale Id:(int)t_id{
    self = [super initWithScale:f_scale Id:t_id];
    
    if (self) {
        self.physicsBody.categoryBitMask = ENEMY_CATEGORY;

    }
    return self;
}

-(void) buildTankWheels {
    CGFloat wheel_x_offset = 1;
    CGFloat wheel_y_offset = -1;
    CGFloat wheel_width = 3;
    
    self.wheel_height = 2;
    UIColor *wheel_color = [UIColor blackColor];
    self.wheel_diff = 2;
    
    self.tankl1 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankl1];
    self.tankl1.position = CGPointMake(0-self.anchoroffset_x-wheel_x_offset,
                                       self.scaled_height*2-wheel_y_offset-self.anchoroffset_y);
    
    self.wheel_origin_y = self.tankl1.position.y;
    
    self.tankl2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankl2];
    self.tankl2.position = CGPointMake(0-self.anchoroffset_x-wheel_x_offset,
                                       self.tankl1.position.y-self.wheel_height-self.wheel_diff);
    
    self.tankl3 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankl3];
    self.tankl3.position = CGPointMake(0-self.anchoroffset_x-wheel_x_offset,
                                       self.tankl2.position.y-self.wheel_height-self.wheel_diff);
    
    self.tankl4 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankl4];
    self.tankl4.position = CGPointMake(0-self.anchoroffset_x-wheel_x_offset,
                                       self.tankl3.position.y-self.wheel_height-self.wheel_diff);
    
    self.wheel_bottom_y = self.tankl4.position.y-self.wheel_height-self.wheel_diff;
    
    //==
    wheel_x_offset = 2;
    self.tankr1 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankr1];
    self.tankr1.position = CGPointMake(self.scaled_width*3-wheel_width-wheel_x_offset-self.anchoroffset_x,
                                       self.scaled_height*2-wheel_y_offset-self.anchoroffset_y);
    
    self.tankr2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankr2];
    self.tankr2.position = CGPointMake(self.scaled_width*3-wheel_width-wheel_x_offset-self.anchoroffset_x,
                                       self.tankr1.position.y-self.wheel_height-self.wheel_diff);
    
    self.tankr3 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankr3];
    self.tankr3.position = CGPointMake(self.scaled_width*3-wheel_width-wheel_x_offset-self.anchoroffset_x,
                                       self.tankr2.position.y-self.wheel_height-self.wheel_diff);
    
    self.tankr4 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankr4];
    self.tankr4.position = CGPointMake(self.scaled_width*3-wheel_width-wheel_x_offset-self.anchoroffset_x,
                                       self.tankr3.position.y-self.wheel_height-self.wheel_diff);
}


-(void) buildTankBody {
    self.tankA = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor]
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankA];
    self.tankA.position = CGPointMake(self.scaled_width-self.anchoroffset_x,self.scaled_height*3-self.anchoroffset_y);
    
    //
    
    self.tankB = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor]
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankB];
    self.tankB.position = CGPointMake(0-self.anchoroffset_x,self.scaled_height*2-self.anchoroffset_y);
    
    self.tankC = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor]
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankC];
    self.tankC.position = CGPointMake(self.scaled_width-self.anchoroffset_x,self.scaled_height*2-self.anchoroffset_y);
    
    self.tankD = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor]
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankD];
    self.tankD.position = CGPointMake(self.scaled_width*2-self.anchoroffset_x,self.scaled_height*2-self.anchoroffset_y);
    
    //
    self.tankE = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor]
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankE];
    self.tankE.position = CGPointMake(0-self.anchoroffset_x,self.scaled_height-self.anchoroffset_y);
    
    self.tankF = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor]
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankF];
    self.tankF.position = CGPointMake(self.scaled_width-self.anchoroffset_x,self.scaled_height-self.anchoroffset_y);
    
    self.tankG = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor]
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankG];
    self.tankG.position = CGPointMake(self.scaled_width*2-self.anchoroffset_x,self.scaled_height-self.anchoroffset_y);
    

    //
    self.tankH = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor]
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankH];
    self.tankH.position = CGPointMake(0-self.anchoroffset_x,0-self.anchoroffset_y);
    
    
    self.tankI = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor]
                                              size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankI];
    self.tankI.position = CGPointMake(self.scaled_width*2-self.anchoroffset_x,0-self.anchoroffset_y);

}


-(int)getWidthInPixels {
    return 3;
}
-(int)getHeightInPixels {
    return 4;
}

@end
