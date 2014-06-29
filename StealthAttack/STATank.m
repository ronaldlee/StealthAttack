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
    BOOL isVisible;
    BOOL is_firing;
    CGFloat anchoroffset_x;
    CGFloat anchoroffset_y;
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
        isVisible = TRUE;
        scale = f_scale;
        
        CGFloat scaled_width = PIXEL_WIDTHHEIGHT*scale;
        CGFloat scaled_height = PIXEL_WIDTHHEIGHT*scale;
        
        max_width = scaled_width*3;
        max_height = scaled_height*3;
        
        anchoroffset_x = max_width/3;
        anchoroffset_y = max_height/3;
        
        self.tankA = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankA];
        self.tankA.position = CGPointMake(scaled_width-anchoroffset_x,scaled_height*2-anchoroffset_y);
        
        self.tankB = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankB];
        self.tankB.position = CGPointMake(0-anchoroffset_x,scaled_height-anchoroffset_y);
        
        self.tankC = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankC];
        self.tankC.position = CGPointMake(scaled_width-anchoroffset_x,scaled_height-anchoroffset_y);
        
        self.tankD = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankD];
        self.tankD.position = CGPointMake(scaled_width*2-anchoroffset_x,scaled_height-anchoroffset_y);
        
        self.tankE = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankE];
        self.tankE.position = CGPointMake(0-anchoroffset_x,0-anchoroffset_y);
        
        self.tankF = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankF];
        self.tankF.position = CGPointMake(scaled_width-anchoroffset_x,0-anchoroffset_y);
        
        self.tankG = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.tankG];
        self.tankG.position = CGPointMake(scaled_width*2-anchoroffset_x,0-anchoroffset_y);
        
        
        self.size = CGSizeMake(max_width, max_height);
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(max_width, max_height)];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = PLAYER_CATEGORY;
        self.physicsBody.contactTestBitMask = ENEMY_CATEGORY;
        self.physicsBody.collisionBitMask = 0;
        
    }
    return self;
}

-(CGFloat)getAdjRotation {
    return self.zRotation + M_PI_2;
}


-(CGFloat)getAnchorOffsetX {
    return anchoroffset_x;
}
-(CGFloat)getAnchorOffsetY {
    return anchoroffset_y;
}

-(void)setBorderBounds:(CGRect)p_bounds {
    bounds = p_bounds;
    
    left_border_x = bounds.origin.x;
    right_border_x = left_border_x+bounds.size.width;
    bottom_border_y = bounds.origin.y;
    top_border_y = bottom_border_y+bounds.size.height;
}

-(void)moveForward {
    CGFloat x = cos([self getAdjRotation])*100+self.position.x;
    CGFloat y = sin([self getAdjRotation])*100+self.position.y;
    
    NSLog(@"move zrotation: %f, x: %f, y: %f",self.zRotation,x,y);
    
    CGPoint location = CGPointMake(x,y);
    
    SKAction *rotation = [SKAction moveTo:location duration:3];
    
    [self runAction:[SKAction repeatActionForever:rotation]];
}
-(void)moveBackward {
    
}
-(void)rotateClockwise {
    SKAction *rotation = [SKAction rotateByAngle:-M_PI*2 duration:3];
    
    [self runAction:[SKAction repeatActionForever:rotation]];
}
-(void)rotateCounterClockwise {
    SKAction *rotation = [SKAction rotateByAngle:M_PI*2 duration:3];
    
    [self runAction:[SKAction repeatActionForever:rotation]];
}

-(void)stop {
    [self removeAllActions];
}

-(void)explode {
    
}

-(void)toggleFiring {
    is_firing = !is_firing;
}

-(BOOL)isFiring {
    return is_firing;
}

-(void)toggleVisibilty {
    UIColor* color = [UIColor blackColor];
    if (isVisible) {
       color = [UIColor whiteColor];
    }
    self.tankA.color = color;
    self.tankB.color = color;
    self.tankC.color = color;
    self.tankD.color = color;
    self.tankE.color = color;
    self.tankF.color = color;
    self.tankG.color = color;
    isVisible = !isVisible;
}

-(void)contactWith:(id<STAGameObject>)gameObj {
    //player can only contact with monster
    
    //drop eneryg
    
    STAEnemyTank* enemy = (STAEnemyTank*)gameObj;
    
    //monster explode
    [enemy explode];
}

@end
