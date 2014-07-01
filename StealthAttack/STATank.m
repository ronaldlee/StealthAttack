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
    CGFloat wheel_origin_y;
    
    CGFloat scaled_width;
    CGFloat scaled_height;
    
    CGFloat wheel_height;
    CGFloat wheel_diff;
    
    BOOL isMovingForward;
    BOOL isMovingBackward;
    BOOL isRotatingClockwise;
    BOOL isRotatingCounterClockwise;
    
    CGFloat moveSpeed;
    
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

@synthesize tankl1;
@synthesize tankl2;
@synthesize tankl3;
@synthesize tankl4;

@synthesize tankr1;
@synthesize tankr2;
@synthesize tankr3;
@synthesize tankr4;


- (id)initWithScale:(CGFloat)f_scale {
    self = [super init];
    if (self) {
        moveSpeed = 20;
        isVisible = TRUE;
        scale = f_scale;
        
        scaled_width = PIXEL_WIDTHHEIGHT*scale; //6
        scaled_height = PIXEL_WIDTHHEIGHT*scale; //6
        
        max_width = scaled_width*3;
        max_height = scaled_height*3;
        
        anchoroffset_x = max_width/2;
        anchoroffset_y = max_height/2;
        
        NSLog(@"max width: %f, %f, ancx/y: %f, %f", max_width, max_height, anchoroffset_x,anchoroffset_y);
        
        self.tankA = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        self.tankA.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankA];
        self.tankA.position = CGPointMake(scaled_width-anchoroffset_x,scaled_height*2-anchoroffset_y);
        
        self.tankB = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        self.tankB.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankB];
        self.tankB.position = CGPointMake(0-anchoroffset_x,scaled_height-anchoroffset_y);
        
        self.tankC = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        self.tankC.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankC];
        self.tankC.position = CGPointMake(scaled_width-anchoroffset_x,scaled_height-anchoroffset_y);
        
        self.tankD = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        self.tankD.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankD];
        self.tankD.position = CGPointMake(scaled_width*2-anchoroffset_x,scaled_height-anchoroffset_y);
        
        self.tankE = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        self.tankE.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankE];
        self.tankE.position = CGPointMake(0-anchoroffset_x,0-anchoroffset_y);
        
        self.tankF = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        self.tankF.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankF];
        self.tankF.position = CGPointMake(scaled_width-anchoroffset_x,0-anchoroffset_y);
        
        self.tankG = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        self.tankG.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankG];
        self.tankG.position = CGPointMake(scaled_width*2-anchoroffset_x,0-anchoroffset_y);
        
        //wheels
        CGFloat wheel_x_offset = -1;
        CGFloat wheel_y_offset = -1;
        CGFloat wheel_width = 3;
        
        wheel_height = 2;
        UIColor *wheel_color = [UIColor blackColor];
        wheel_diff = 2;
        
        self.tankl1 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        self.tankl1.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankl1];
        self.tankl1.position = CGPointMake(0-anchoroffset_x-wheel_x_offset,
                                           scaled_height*2-wheel_y_offset-anchoroffset_y);
        
        wheel_origin_y = self.tankl1.position.y;
        
        self.tankl2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        self.tankl2.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankl2];
        self.tankl2.position = CGPointMake(0-anchoroffset_x-wheel_x_offset,
                                           self.tankl1.position.y-wheel_height-wheel_diff);
        
        self.tankl3 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        self.tankl3.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankl3];
        self.tankl3.position = CGPointMake(0-anchoroffset_x-wheel_x_offset,
                                           self.tankl2.position.y-wheel_height-wheel_diff);
        
        self.tankl4 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        self.tankl4.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankl4];
        self.tankl4.position = CGPointMake(0-anchoroffset_x-wheel_x_offset,
                                           self.tankl3.position.y-wheel_height-wheel_diff);
        
        //==
        wheel_x_offset = 1;
        self.tankr1 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        self.tankr1.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankr1];
        self.tankr1.position = CGPointMake(scaled_width*3-wheel_width-wheel_x_offset-anchoroffset_x,
                                           scaled_height*2-wheel_y_offset-anchoroffset_y);
        
        self.tankr2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        self.tankr2.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankr2];
        self.tankr2.position = CGPointMake(scaled_width*3-wheel_width-wheel_x_offset-anchoroffset_x,
                                           self.tankr1.position.y-wheel_height-wheel_diff);
        
        self.tankr3 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        self.tankr3.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankr3];
        self.tankr3.position = CGPointMake(scaled_width*3-wheel_width-wheel_x_offset-anchoroffset_x,
                                           self.tankr2.position.y-wheel_height-wheel_diff);
        
        self.tankr4 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        self.tankr4.anchorPoint = CGPointMake(0,0);
        [self addChild:self.tankr4];
        self.tankr4.position = CGPointMake(scaled_width*3-wheel_width-wheel_x_offset-anchoroffset_x,
                                           self.tankr3.position.y-wheel_height-wheel_diff);
        
        self.size = CGSizeMake(max_width, max_height);
//        self.anchorPoint = CGPointMake(0,0);
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(max_width, max_height)];
        
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = PLAYER_CATEGORY;
        self.physicsBody.contactTestBitMask = ENEMY_CATEGORY | WALL_CATEGORY;
        self.physicsBody.collisionBitMask = WALL_CATEGORY | PLAYER_CATEGORY | ENEMY_CATEGORY;
        self.physicsBody.restitution = -1;
//        self.physicsBody.friction = 0;
//        self.physicsBody.linearDamping = 0;
//        self.physicsBody.angularDamping = 0;
        
//        self.physicsBody.collisionBitMask = 0;
        
        NSLog(@"tb.top.y: %f, y: %f", self.tankB.position.y+self.tankB.size.height, self.tankB.position.y);
        NSLog(@"start tl1.y: %f, l2: %f, l3: %f",self.tankl1.position.y,self.tankl2.position.y,self.tankl3.position.y);
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

-(void) correctLeftWheels {
    if (self.tankl1.position.y > self.tankl2.position.y &&
        self.tankl2.position.y > self.tankl3.position.y &&
        self.tankl3.position.y > self.tankl4.position.y) {
        self.tankl2.position = CGPointMake(self.tankl2.position.x,
                                           self.tankl1.position.y-wheel_height-wheel_diff);
        self.tankl3.position = CGPointMake(self.tankl3.position.x,
                                           self.tankl2.position.y-wheel_height-wheel_diff);
        self.tankl4.position = CGPointMake(self.tankl4.position.x,
                                           self.tankl3.position.y-wheel_height-wheel_diff);
    }
    else if (self.tankl2.position.y > self.tankl3.position.y &&
             self.tankl3.position.y > self.tankl4.position.y &&
             self.tankl4.position.y > self.tankl1.position.y) {
        self.tankl3.position = CGPointMake(self.tankl3.position.x,
                                           self.tankl2.position.y-wheel_height-wheel_diff);
        self.tankl4.position = CGPointMake(self.tankl4.position.x,
                                           self.tankl3.position.y-wheel_height-wheel_diff);
        self.tankl1.position = CGPointMake(self.tankl1.position.x,
                                           self.tankl4.position.y-wheel_height-wheel_diff);
    }
    else if (self.tankl3.position.y > self.tankl4.position.y &&
             self.tankl4.position.y > self.tankl1.position.y &&
             self.tankl1.position.y > self.tankl2.position.y) {
        self.tankl4.position = CGPointMake(self.tankl4.position.x,
                                           self.tankl3.position.y-wheel_height-wheel_diff);
        self.tankl1.position = CGPointMake(self.tankl1.position.x,
                                           self.tankl4.position.y-wheel_height-wheel_diff);
        self.tankl2.position = CGPointMake(self.tankl2.position.x,
                                           self.tankl1.position.y-wheel_height-wheel_diff);
    }
    else if (self.tankl4.position.y > self.tankl1.position.y &&
             self.tankl1.position.y > self.tankl2.position.y &&
             self.tankl2.position.y > self.tankl3.position.y) {
        self.tankl1.position = CGPointMake(self.tankl1.position.x,
                                           self.tankl4.position.y-wheel_height-wheel_diff);
        self.tankl2.position = CGPointMake(self.tankl2.position.x,
                                           self.tankl1.position.y-wheel_height-wheel_diff);
        self.tankl3.position = CGPointMake(self.tankl3.position.x,
                                           self.tankl2.position.y-wheel_height-wheel_diff);
    }
}
-(void) correctRightWheels {
    if (self.tankr1.position.y > self.tankr2.position.y &&
        self.tankr2.position.y > self.tankr3.position.y &&
        self.tankr3.position.y > self.tankr4.position.y) {
        self.tankr2.position = CGPointMake(self.tankr2.position.x,
                                           self.tankr1.position.y-wheel_height-wheel_diff);
        self.tankr3.position = CGPointMake(self.tankr3.position.x,
                                           self.tankr2.position.y-wheel_height-wheel_diff);
        self.tankr4.position = CGPointMake(self.tankr4.position.x,
                                           self.tankr3.position.y-wheel_height-wheel_diff);
    }
    else if (self.tankr2.position.y > self.tankr3.position.y &&
             self.tankr3.position.y > self.tankr4.position.y &&
             self.tankr4.position.y > self.tankr1.position.y) {
        self.tankr3.position = CGPointMake(self.tankr3.position.x,
                                           self.tankr2.position.y-wheel_height-wheel_diff);
        self.tankr4.position = CGPointMake(self.tankr4.position.x,
                                           self.tankr3.position.y-wheel_height-wheel_diff);
        self.tankr1.position = CGPointMake(self.tankr1.position.x,
                                           self.tankr4.position.y-wheel_height-wheel_diff);
    }
    else if (self.tankr3.position.y > self.tankr4.position.y &&
             self.tankr4.position.y > self.tankr1.position.y &&
             self.tankr1.position.y > self.tankr2.position.y) {
        self.tankr4.position = CGPointMake(self.tankr4.position.x,
                                           self.tankr3.position.y-wheel_height-wheel_diff);
        self.tankr1.position = CGPointMake(self.tankr1.position.x,
                                           self.tankr4.position.y-wheel_height-wheel_diff);
        self.tankr2.position = CGPointMake(self.tankr2.position.x,
                                           self.tankr1.position.y-wheel_height-wheel_diff);
    }
    else if (self.tankr4.position.y > self.tankr1.position.y &&
             self.tankr1.position.y > self.tankr2.position.y &&
             self.tankr2.position.y > self.tankr3.position.y) {
        self.tankr1.position = CGPointMake(self.tankr1.position.x,
                                           self.tankr4.position.y-wheel_height-wheel_diff);
        self.tankr2.position = CGPointMake(self.tankr2.position.x,
                                           self.tankr1.position.y-wheel_height-wheel_diff);
        self.tankr3.position = CGPointMake(self.tankr3.position.x,
                                           self.tankr2.position.y-wheel_height-wheel_diff);
    }
}

-(void)moveLeftWheelsForward {
//    NSLog(@"tl1.y: %f, l2: %f, l3: %f, l4: %f",
//          self.tankl1.position.y,self.tankl2.position.y,self.tankl3.position.y,self.tankl4.position.y);
    
    [self correctLeftWheels];
    
    CGFloat speed = 1;
    CGFloat base_y = -anchoroffset_y-wheel_height-1;
    CGFloat tank_body_height = scaled_height*3-wheel_height;
    
    //left
    CGPoint base_location = CGPointMake(self.tankl1.position.x,base_y);
    CGPoint start_location = CGPointMake(self.tankl1.position.x,wheel_origin_y);
    
    CGFloat duration_l1 = fabsf(base_y-self.tankl1.position.y)/tank_body_height*speed;
    CGFloat duration_l2 = fabsf(base_y-self.tankl2.position.y)/tank_body_height*speed;
    CGFloat duration_l3 = fabsf(base_y-self.tankl3.position.y)/tank_body_height*speed;
    CGFloat duration_l4 = fabsf(base_y-self.tankl4.position.y)/tank_body_height*speed;
    
    SKAction *rotationl1 = [SKAction moveTo:base_location duration:duration_l1];
    SKAction *rotationl2 = [SKAction moveTo:base_location duration:duration_l2];
    SKAction *rotationl3 = [SKAction moveTo:base_location duration:duration_l3];
    SKAction *rotationl4 = [SKAction moveTo:base_location duration:duration_l4];
    
    //move back to top
    SKAction *rotation2 = [SKAction moveTo:start_location duration:0];
    SKAction *rotation3 = [SKAction moveTo:base_location duration:speed];
    
    [self.tankl1 runAction:rotationl1 completion:^(void) {
        [self.tankl1 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
    [self.tankl2 runAction:rotationl2 completion:^(void) {
        [self.tankl2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
    [self.tankl3 runAction:rotationl3 completion:^(void) {
        [self.tankl3 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
    [self.tankl4 runAction:rotationl4 completion:^(void) {
        [self.tankl4 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
}

-(void)moveRightWheelsForward {
    [self correctRightWheels];
    
    CGFloat speed = 1;
    CGFloat base_y = -anchoroffset_y-wheel_height-1;
    CGFloat tank_body_height = scaled_height*3-wheel_height;
    //right
    CGPoint location = CGPointMake(self.tankr1.position.x,base_y);
    CGPoint location2 = CGPointMake(self.tankr1.position.x,wheel_origin_y);
    
    CGFloat duration_r1 = fabsf(base_y-self.tankr1.position.y)/tank_body_height*speed;
    CGFloat duration_r2 = fabsf(base_y-self.tankr2.position.y)/tank_body_height*speed;
    CGFloat duration_r3 = fabsf(base_y-self.tankr3.position.y)/tank_body_height*speed;
    CGFloat duration_r4 = fabsf(base_y-self.tankr4.position.y)/tank_body_height*speed;
    
    SKAction *rotationr1 = [SKAction moveTo:location duration:duration_r1];
    SKAction *rotationr2 = [SKAction moveTo:location duration:duration_r2];
    SKAction *rotationr3 = [SKAction moveTo:location duration:duration_r3];
    SKAction *rotationr4 = [SKAction moveTo:location duration:duration_r4];
    
    //move back to top
    SKAction *rotation2 = [SKAction moveTo:location2 duration:0];
    SKAction *rotation3 = [SKAction moveTo:location duration:speed];
    
    [self.tankr1 runAction:rotationr1 completion:^(void) {
        [self.tankr1 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
    [self.tankr2 runAction:rotationr2 completion:^(void) {
        [self.tankr2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
    [self.tankr3 runAction:rotationr3 completion:^(void) {
        [self.tankr3 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
    [self.tankr4 runAction:rotationr4 completion:^(void) {
        [self.tankr4 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
}


-(void)moveLeftWheelsBackward {
    [self correctLeftWheels];
    
    CGFloat speed = 1;
    CGFloat base_y = -anchoroffset_y-wheel_height-1;
    CGFloat tank_body_height = scaled_height*3-wheel_height;
    
    //left
    CGPoint location = CGPointMake(self.tankl1.position.x,wheel_origin_y);
    CGPoint location2 = CGPointMake(self.tankl1.position.x,base_y);
    
    CGFloat duration_l1 = (tank_body_height-fabsf(base_y-self.tankl1.position.y))/tank_body_height*speed;
    CGFloat duration_l2 = (tank_body_height-fabsf(base_y-self.tankl2.position.y))/tank_body_height*speed;
    CGFloat duration_l3 = (tank_body_height-fabsf(base_y-self.tankl3.position.y))/tank_body_height*speed;
    CGFloat duration_l4 = (tank_body_height-fabsf(base_y-self.tankl4.position.y))/tank_body_height*speed;
    
    SKAction *rotationl1 = [SKAction moveTo:location duration:duration_l1];
    SKAction *rotationl2 = [SKAction moveTo:location duration:duration_l2];
    SKAction *rotationl3 = [SKAction moveTo:location duration:duration_l3];
    SKAction *rotationl4 = [SKAction moveTo:location duration:duration_l4];
    
    //move back to top
    SKAction *rotation2 = [SKAction moveTo:location2 duration:0];
    SKAction *rotation3 = [SKAction moveTo:location duration:speed];
    
    [self.tankl1 runAction:rotationl1 completion:^(void) {
        [self.tankl1 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
    [self.tankl2 runAction:rotationl2 completion:^(void) {
        [self.tankl2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
    [self.tankl3 runAction:rotationl3 completion:^(void) {
        [self.tankl3 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
    [self.tankl4 runAction:rotationl4 completion:^(void) {
        [self.tankl4 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
}


-(void)moveRightWheelsBackward {
    [self correctRightWheels];
    
    CGFloat speed = 1;
    CGFloat base_y = -anchoroffset_y-wheel_height-1;
    CGFloat tank_body_height = scaled_height*3-wheel_height;
    //right
    CGPoint location = CGPointMake(self.tankr1.position.x,wheel_origin_y);
    CGPoint location2 = CGPointMake(self.tankr1.position.x,base_y);
    
    CGFloat duration_r1 = (tank_body_height-fabsf(base_y-self.tankr1.position.y))/tank_body_height*speed;
    CGFloat duration_r2 = (tank_body_height-fabsf(base_y-self.tankr2.position.y))/tank_body_height*speed;
    CGFloat duration_r3 = (tank_body_height-fabsf(base_y-self.tankr3.position.y))/tank_body_height*speed;
    CGFloat duration_r4 = (tank_body_height-fabsf(base_y-self.tankr4.position.y))/tank_body_height*speed;
    
    SKAction *rotationr1 = [SKAction moveTo:location duration:duration_r1];
    SKAction *rotationr2 = [SKAction moveTo:location duration:duration_r2];
    SKAction *rotationr3 = [SKAction moveTo:location duration:duration_r3];
    SKAction *rotationr4 = [SKAction moveTo:location duration:duration_r4];
    
    //move back to top
    SKAction *rotation2 = [SKAction moveTo:location2 duration:0];
    SKAction *rotation3 = [SKAction moveTo:location duration:speed];
    
    [self.tankr1 runAction:rotationr1 completion:^(void) {
        [self.tankr1 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
    [self.tankr2 runAction:rotationr2 completion:^(void) {
        [self.tankr2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
    [self.tankr3 runAction:rotationr3 completion:^(void) {
        [self.tankr3 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
    [self.tankr4 runAction:rotationr4 completion:^(void) {
        [self.tankr4 runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotation2,rotation3]]]];
    }];
}

-(void)moveForward {
    if (isRotatingClockwise || isRotatingCounterClockwise || isMovingBackward) return;
    isMovingForward= true;
    
    CGFloat x = cos([self getAdjRotation])*moveSpeed;//+self.position.x;
    CGFloat y = sin([self getAdjRotation])*moveSpeed;//+self.position.y;
    
//    CGPoint location = CGPointMake(x,y);
//    
//    SKAction *rotation = [SKAction moveTo:location duration:300];
//    
//    [self runAction:[SKAction repeatActionForever:rotation]];
    
    self.physicsBody.velocity = CGVectorMake(x, y);
    
    [self moveLeftWheelsForward];
    [self moveRightWheelsForward];
}
-(void)moveBackward {
    if (isRotatingClockwise || isRotatingCounterClockwise || isMovingForward) return;
    isMovingBackward= true;
    
    CGFloat x = cos([self getAdjRotation]+M_PI)*moveSpeed;//+self.position.x;
    CGFloat y = sin([self getAdjRotation]+M_PI)*moveSpeed;//+self.position.y;
    
//    
//    CGPoint location = CGPointMake(x,y);
//    
//    SKAction *rotation = [SKAction moveTo:location duration:300];
//    
//    [self runAction:[SKAction repeatActionForever:rotation]];
    
    self.physicsBody.velocity = CGVectorMake(x, y);
//    [self.physicsBody applyImpulse:location];
    
    [self moveLeftWheelsBackward];
    [self moveRightWheelsBackward];
}

-(void)rotateClockwise {
    if (isRotatingCounterClockwise || isMovingForward || isMovingBackward) return;
    isRotatingClockwise= true;
    
    SKAction *rotation = [SKAction rotateByAngle:-M_PI*2 duration:3];
    
    [self runAction:[SKAction repeatActionForever:rotation]];
    
    [self moveLeftWheelsForward];
    [self moveRightWheelsBackward];
}
-(void)rotateCounterClockwise {
    if (isRotatingClockwise || isMovingForward || isMovingBackward) return;
    isRotatingCounterClockwise= true;
    
    SKAction *rotation = [SKAction rotateByAngle:M_PI*2 duration:3];
    
    [self runAction:[SKAction repeatActionForever:rotation]];
    
    [self moveLeftWheelsBackward];
    [self moveRightWheelsForward];
}

-(void)stop {
    isMovingForward = isMovingBackward = false;
    isRotatingClockwise = isRotatingCounterClockwise = false;
    
    self.physicsBody.velocity = CGVectorMake(0, 0);
    
    [self removeAllActions];
    [self.tankl1 removeAllActions];
    [self.tankl2 removeAllActions];
    [self.tankl3 removeAllActions];
    [self.tankl4 removeAllActions];
    
    [self.tankr1 removeAllActions];
    [self.tankr2 removeAllActions];
    [self.tankr3 removeAllActions];
    [self.tankr4 removeAllActions];
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

-(void)stopMovement {
    if (isMovingForward || isMovingBackward) {
        isMovingForward = isMovingBackward = false;
        [self removeAllActions];
    }
}


@end
