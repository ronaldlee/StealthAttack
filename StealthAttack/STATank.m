//
//  STATank.m
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STATank.h"

@interface STATank() {
    float scale;
    float max_width, max_height;
    CGRect bounds;
    float bottom_border_y, top_border_y, left_border_x, right_border_x;
}
@end

@implementation STATank

@synthesize tankA;
@synthesize tankB;
@synthesize tankC;
@synthesize tankD;
@synthesize tankE;
@synthesize tankF;
@synthesize tankG;

- (id)initWithScale:(CGFloat)f_scale {
    self = [super init];
    if (self) {
        
        scale = f_scale;
        
        CGFloat scaled_width = PIXEL_WIDTHHEIGHT*scale;
        CGFloat scaled_height = PIXEL_WIDTHHEIGHT*scale;
        
        self.tankA = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankA];
        self.tankA.position = CGPointMake(scaled_width,scaled_height*2);
        
        self.tankB = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankB];
        self.tankB.position = CGPointMake(0,scaled_height);
        
        self.tankC = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankC];
        self.tankC.position = CGPointMake(scaled_width,scaled_height);
        
        self.tankD = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankD];
        self.tankD.position = CGPointMake(scaled_width*2,scaled_height);
        
        self.tankE = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankE];
        self.tankE.position = CGPointMake(0,0);
        
        self.tankF = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankF];
        self.tankF.position = CGPointMake(scaled_width,0);
        
        self.tankG = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankG];
        self.tankG.position = CGPointMake(scaled_width*2,0);
        
        max_width = scaled_width*3;
        max_height = scaled_height*3;
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(max_width, max_height)];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = PLAYER_CATEGORY;
        self.physicsBody.contactTestBitMask = ENEMY_CATEGORY;
        self.physicsBody.collisionBitMask = 0;
        
    }
    return self;
}

-(void)setBorderBounds:(CGRect)p_bounds {
    bounds = p_bounds;
    
    left_border_x = bounds.origin.x;
    right_border_x = left_border_x+bounds.size.width;
    bottom_border_y = bounds.origin.y;
    top_border_y = bottom_border_y+bounds.size.height;
}

-(void)moveForward {
    
}
-(void)moveBackward {
    
}
-(void)rotateClockwise {
    
}
-(void)rotateBlackwise {
    
}
-(void)stop {
    
}

-(void)explode {
    
}

-(void)contactWith:(id<STAGameObject>)gameObj {
    //player can only contact with monster
    
    //drop eneryg
    
    STAEnemyTank* enemy = (STAEnemyTank*)gameObj;
    
    //monster explode
    [enemy explode];
}

@end
