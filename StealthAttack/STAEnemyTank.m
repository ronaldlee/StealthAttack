//
//  STAEnemyTank.m
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAEnemyTank.h"

@implementation STAEnemyTank

@synthesize tankA;

@synthesize tankB;
@synthesize tankC;
@synthesize tankD;
@synthesize tankE;
@synthesize tankF;
@synthesize tankG;
@synthesize tankH;
@synthesize tankI;

@synthesize tankl1;
@synthesize tankl2;
@synthesize tankl3;
@synthesize tankl4;

@synthesize tankr1;
@synthesize tankr2;
@synthesize tankr3;
@synthesize tankr4;

- (id)initWithScale:(CGFloat)f_scale {
    self = [super initWithScale:f_scale];
    
    if (self) {
        self.physicsBody.categoryBitMask = ENEMY_CATEGORY;

    }
    return self;
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
