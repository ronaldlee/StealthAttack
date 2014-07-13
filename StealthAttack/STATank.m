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
    CGFloat wheel_origin_y;
    CGFloat wheel_bottom_y;
    
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

@synthesize scaled_width;
@synthesize scaled_height;

@synthesize anchoroffset_x;
@synthesize anchoroffset_y;


- (id)initWithScale:(CGFloat)f_scale {
    self = [super init];
    if (self) {
        moveSpeed = 20;
        isVisible = TRUE;
        scale = f_scale;
        
        scaled_width = PIXEL_WIDTHHEIGHT*scale; //6
        scaled_height = PIXEL_WIDTHHEIGHT*scale; //6
        
        max_width = scaled_width*[self getWidthInPixels];
        max_height = scaled_height*[self getHeightInPixels];
        
        anchoroffset_x = scaled_width; //max_width/2;
        anchoroffset_y = scaled_height; //max_height/2;
        
        NSLog(@"max width: %f, %f, ancx/y: %f, %f", max_width, max_height, anchoroffset_x,anchoroffset_y);
        
        [self buildTankBody];
        
        //wheels
        CGFloat wheel_x_offset = 1;
        CGFloat wheel_y_offset = 1;
        CGFloat wheel_width = 3;
        
        wheel_height = 2;
        UIColor *wheel_color = [UIColor blackColor];
        wheel_diff = 2;
        
        self.tankl1 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankl1];
        self.tankl1.position = CGPointMake(0-anchoroffset_x-wheel_x_offset,
                                           scaled_height*2-wheel_y_offset-anchoroffset_y);
        
        wheel_origin_y = self.tankl1.position.y;
        
        self.tankl2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankl2];
        self.tankl2.position = CGPointMake(0-anchoroffset_x-wheel_x_offset,
                                           self.tankl1.position.y-wheel_height-wheel_diff);
        
        self.tankl3 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankl3];
        self.tankl3.position = CGPointMake(0-anchoroffset_x-wheel_x_offset,
                                           self.tankl2.position.y-wheel_height-wheel_diff);
        
        self.tankl4 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankl4];
        self.tankl4.position = CGPointMake(0-anchoroffset_x-wheel_x_offset,
                                           self.tankl3.position.y-wheel_height-wheel_diff);
        
        wheel_bottom_y = self.tankl4.position.y-wheel_height-wheel_diff;
        
//        NSLog(@"after l4 tl1.y: %f, l2: %f, l3: %f, l4: %f",self.tankl1.position.y,self.tankl2.position.y,self.tankl3.position.y,self.tankl4.position.y);
//        NSLog(@"start bottom y: %f, tl4.y: %f, wheel_height: %f, wheel_diff: %f",
//              wheel_bottom_y,self.tankl4.position.y,wheel_height,wheel_diff);
        
        //==
        wheel_x_offset = 2;
        self.tankr1 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankr1];
        self.tankr1.position = CGPointMake(scaled_width*3-wheel_width-wheel_x_offset-anchoroffset_x,
                                           scaled_height*2-wheel_y_offset-anchoroffset_y);
        
        self.tankr2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankr2];
        self.tankr2.position = CGPointMake(scaled_width*3-wheel_width-wheel_x_offset-anchoroffset_x,
                                           self.tankr1.position.y-wheel_height-wheel_diff);
        
        self.tankr3 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankr3];
        self.tankr3.position = CGPointMake(scaled_width*3-wheel_width-wheel_x_offset-anchoroffset_x,
                                           self.tankr2.position.y-wheel_height-wheel_diff);
        
        self.tankr4 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankr4];
        self.tankr4.position = CGPointMake(scaled_width*3-wheel_width-wheel_x_offset-anchoroffset_x,
                                           self.tankr3.position.y-wheel_height-wheel_diff);
        
        self.size = CGSizeMake(max_width, max_height);
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(max_width, max_height)];
        
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = PLAYER_CATEGORY;
        self.physicsBody.contactTestBitMask = ENEMY_CATEGORY | WALL_CATEGORY | PLAYER_CATEGORY;
        self.physicsBody.collisionBitMask = WALL_CATEGORY | PLAYER_CATEGORY | ENEMY_CATEGORY;
        self.physicsBody.restitution = -1.0f;
        
        //need these so the tank won't slow down when moving
        self.physicsBody.friction = 0;
        self.physicsBody.linearDamping = 0;
        self.physicsBody.angularDamping = 0;
        
        NSLog(@"tb.top.y: %f, y: %f", self.tankB.position.y+self.tankB.size.height, self.tankB.position.y);
        NSLog(@"start tl1.y: %f, l2: %f, l3: %f, l4: %f",self.tankl1.position.y,self.tankl2.position.y,self.tankl3.position.y,self.tankl4.position.y);
        NSLog(@"start wheel origin y: %f, bottom y: %f",wheel_origin_y,wheel_bottom_y);
    }
    return self;
}

-(void) buildTankBody {
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
}

-(int)getWidthInPixels {
    return 3;
}
-(int)getHeightInPixels {
    return 3;
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
    SKSpriteNode *first = self.tankl1;
    if (self.tankl2.position.y >= first.position.y) {
        first = self.tankl2;
    }
    if (self.tankl3.position.y >= first.position.y) {
        first = self.tankl3;
    }
    if (self.tankl4.position.y >= first.position.y) {
        first = self.tankl4;
    }
    
    if (first == self.tankl1) {
        self.tankl2.position = CGPointMake(first.position.x,
                                           first.position.y-wheel_height-wheel_diff);
        self.tankl3.position = CGPointMake(first.position.x,
                                           self.tankl2.position.y-wheel_height-wheel_diff);
        self.tankl4.position = CGPointMake(first.position.x,
                                           self.tankl3.position.y-wheel_height-wheel_diff);
    }
    else if (first == self.tankl2) {
        self.tankl3.position = CGPointMake(first.position.x,
                                           first.position.y-wheel_height-wheel_diff);
        self.tankl4.position = CGPointMake(first.position.x,
                                           self.tankl3.position.y-wheel_height-wheel_diff);
        self.tankl1.position = CGPointMake(first.position.x,
                                           self.tankl4.position.y-wheel_height-wheel_diff);
    }
    else if (first == self.tankl3) {
        self.tankl4.position = CGPointMake(first.position.x,
                                           first.position.y-wheel_height-wheel_diff);
        self.tankl1.position = CGPointMake(first.position.x,
                                           self.tankl4.position.y-wheel_height-wheel_diff);
        self.tankl2.position = CGPointMake(first.position.x,
                                           self.tankl1.position.y-wheel_height-wheel_diff);
    }
    else if (first == self.tankl4) {
        self.tankl1.position = CGPointMake(first.position.x,
                                           first.position.y-wheel_height-wheel_diff);
        self.tankl2.position = CGPointMake(first.position.x,
                                           self.tankl1.position.y-wheel_height-wheel_diff);
        self.tankl3.position = CGPointMake(first.position.x,
                                           self.tankl2.position.y-wheel_height-wheel_diff);
    }

}
-(void) correctRightWheels {
    SKSpriteNode *first = self.tankr1;
    if (self.tankr2.position.y >= first.position.y) {
        first = self.tankr2;
    }
    if (self.tankr3.position.y >= first.position.y) {
        first = self.tankr3;
    }
    if (self.tankr4.position.y >= first.position.y) {
        first = self.tankr4;
    }
    
    if (first == self.tankr1) {
        self.tankr2.position = CGPointMake(first.position.x,
                                           first.position.y-wheel_height-wheel_diff);
        self.tankr3.position = CGPointMake(first.position.x,
                                           self.tankr2.position.y-wheel_height-wheel_diff);
        self.tankr4.position = CGPointMake(first.position.x,
                                           self.tankr3.position.y-wheel_height-wheel_diff);
    }
    else if (first == self.tankr2) {
        self.tankr3.position = CGPointMake(first.position.x,
                                           first.position.y-wheel_height-wheel_diff);
        self.tankr4.position = CGPointMake(first.position.x,
                                           self.tankr3.position.y-wheel_height-wheel_diff);
        self.tankr1.position = CGPointMake(first.position.x,
                                           self.tankr4.position.y-wheel_height-wheel_diff);
    }
    else if (first == self.tankr3) {
        self.tankr4.position = CGPointMake(first.position.x,
                                           first.position.y-wheel_height-wheel_diff);
        self.tankr1.position = CGPointMake(first.position.x,
                                           self.tankr4.position.y-wheel_height-wheel_diff);
        self.tankr2.position = CGPointMake(first.position.x,
                                           self.tankr1.position.y-wheel_height-wheel_diff);
    }
    else if (first == self.tankr4) {
        self.tankr1.position = CGPointMake(first.position.x,
                                           first.position.y-wheel_height-wheel_diff);
        self.tankr2.position = CGPointMake(first.position.x,
                                           self.tankr1.position.y-wheel_height-wheel_diff);
        self.tankr3.position = CGPointMake(first.position.x,
                                           self.tankr2.position.y-wheel_height-wheel_diff);
    }
    
}

-(void)moveLeftWheelsForward {
    NSLog(@"forward tl1.y: %f, l2: %f, l3: %f, l4: %f",
          self.tankl1.position.y,self.tankl2.position.y,self.tankl3.position.y,self.tankl4.position.y);
    
    [self correctLeftWheels];
    
    CGFloat speed = 1;
    CGFloat tank_body_height = scaled_height*3-wheel_height;
    
    NSLog(@"forward wheel_origin_y: %f, bottom_y: %f, tank_body_height: %f",
          wheel_origin_y,wheel_bottom_y,tank_body_height);
    
    //left
    CGPoint base_location = CGPointMake(self.tankl1.position.x,wheel_bottom_y);
    CGPoint start_location = CGPointMake(self.tankl1.position.x,wheel_origin_y);
    
    CGFloat duration_l1 = fabsf(wheel_bottom_y-self.tankl1.position.y)/tank_body_height*speed;
    CGFloat duration_l2 = fabsf(wheel_bottom_y-self.tankl2.position.y)/tank_body_height*speed;
    CGFloat duration_l3 = fabsf(wheel_bottom_y-self.tankl3.position.y)/tank_body_height*speed;
    CGFloat duration_l4 = fabsf(wheel_bottom_y-self.tankl4.position.y)/tank_body_height*speed;
    
    SKAction *rotationl1 = [SKAction moveTo:base_location duration:duration_l1];
    SKAction *rotationl2 = [SKAction moveTo:base_location duration:duration_l2];
    SKAction *rotationl3 = [SKAction moveTo:base_location duration:duration_l3];
    SKAction *rotationl4 = [SKAction moveTo:base_location duration:duration_l4];
    
//    SKAction *correct = [SKAction runBlock:^(void) {
//        [self correctLeftWheels];
//    }];
    
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
    CGFloat tank_body_height = scaled_height*3-wheel_height;
    //right
    CGPoint location = CGPointMake(self.tankr1.position.x,wheel_bottom_y);
    CGPoint location2 = CGPointMake(self.tankr1.position.x,wheel_origin_y);
    
    CGFloat duration_r1 = fabsf(wheel_bottom_y-self.tankr1.position.y)/tank_body_height*speed;
    CGFloat duration_r2 = fabsf(wheel_bottom_y-self.tankr2.position.y)/tank_body_height*speed;
    CGFloat duration_r3 = fabsf(wheel_bottom_y-self.tankr3.position.y)/tank_body_height*speed;
    CGFloat duration_r4 = fabsf(wheel_bottom_y-self.tankr4.position.y)/tank_body_height*speed;
    
    SKAction *rotationr1 = [SKAction moveTo:location duration:duration_r1];
    SKAction *rotationr2 = [SKAction moveTo:location duration:duration_r2];
    SKAction *rotationr3 = [SKAction moveTo:location duration:duration_r3];
    SKAction *rotationr4 = [SKAction moveTo:location duration:duration_r4];
    
//    SKAction *correct = [SKAction runBlock:^(void) {
//        [self correctRightWheels];
//    }];
    
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
//    NSLog(@"backward: tl1.y: %f, l2: %f, l3: %f, l4: %f",
//          self.tankl1.position.y,self.tankl2.position.y,self.tankl3.position.y,self.tankl4.position.y);
    
    [self correctLeftWheels];
    
    CGFloat speed = 1;
    CGFloat tank_body_height = scaled_height*3-wheel_height;
    
//    NSLog(@"bw base_y: %f: tank_body_height: %f: wheel_origin_y: %f",base_y, tank_body_height, wheel_origin_y);
    
    //left
    CGPoint location = CGPointMake(self.tankl1.position.x,wheel_origin_y);
    CGPoint location2 = CGPointMake(self.tankl1.position.x,wheel_bottom_y);
    
    CGFloat duration_l1 = (tank_body_height-fabsf(wheel_bottom_y-self.tankl1.position.y))/tank_body_height*speed;
    CGFloat duration_l2 = (tank_body_height-fabsf(wheel_bottom_y-self.tankl2.position.y))/tank_body_height*speed;
    CGFloat duration_l3 = (tank_body_height-fabsf(wheel_bottom_y-self.tankl3.position.y))/tank_body_height*speed;
    CGFloat duration_l4 = (tank_body_height-fabsf(wheel_bottom_y-self.tankl4.position.y))/tank_body_height*speed;
    
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
    CGFloat tank_body_height = scaled_height*3-wheel_height;
    //right
    CGPoint location = CGPointMake(self.tankr1.position.x,wheel_origin_y);
    CGPoint location2 = CGPointMake(self.tankr1.position.x,wheel_bottom_y);
    
    CGFloat duration_r1 = (tank_body_height-fabsf(wheel_bottom_y-self.tankr1.position.y))/tank_body_height*speed;
    CGFloat duration_r2 = (tank_body_height-fabsf(wheel_bottom_y-self.tankr2.position.y))/tank_body_height*speed;
    CGFloat duration_r3 = (tank_body_height-fabsf(wheel_bottom_y-self.tankr3.position.y))/tank_body_height*speed;
    CGFloat duration_r4 = (tank_body_height-fabsf(wheel_bottom_y-self.tankr4.position.y))/tank_body_height*speed;
    
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

-(void)explodePart:(SKSpriteNode*)part XDiff:(CGFloat)x_diff YDiff:(CGFloat)y_diff
       FlyDuration:(float)f_duration FadeoutDuration:(float)fo_duration
       RotateDuration:(float)r_duration{
    
    self.physicsBody = NULL;
    
    CGFloat cur_x = part.position.x;
    CGFloat cur_y = part.position.y;
    
    SKAction *rotate = [SKAction rotateByAngle:360.0 duration:r_duration];
    
    SKAction *fadeout = [SKAction fadeOutWithDuration:fo_duration];
    SKAction *m_hand_1_explode = [SKAction moveTo:CGPointMake(cur_x+x_diff, cur_y+y_diff) duration:f_duration];
    
    [part runAction:m_hand_1_explode];
//    [part runAction:[SKAction repeatActionForever:rotate]];
    [part runAction:rotate];
    
    SKAction *wait = [SKAction waitForDuration:f_duration-fo_duration];
    SKAction* sequence=[SKAction sequence:@[wait,fadeout]];
    [part runAction:sequence];
}

-(void)explode {
    [self removeAllActions];
    
    float f_duration = 2.0;
    float fo_duration = 0.5;
    float r_duration = 100.0;
    
    //hands and eyes just randomly flies away
    [self explodePart:tankA XDiff:0 YDiff:30 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    
    [self explodePart:tankB XDiff:20 YDiff:30 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:tankC XDiff:-20 YDiff:20 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:tankD XDiff:20 YDiff:30 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    
    [self explodePart:tankE XDiff:30 YDiff:20 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:tankF XDiff:10 YDiff:10 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:tankG XDiff:-30 YDiff:20 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];

    [self explodePart:tankl1 XDiff:-5 YDiff:5 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:tankl2 XDiff:15 YDiff:15 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:tankl3 XDiff:5 YDiff:10 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:tankl4 XDiff:10 YDiff:5 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];

    [self explodePart:tankr1 XDiff:5 YDiff:10 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:tankr2 XDiff:20 YDiff:5 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:tankr3 XDiff:-10 YDiff:10 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
    [self explodePart:tankr4 XDiff:10 YDiff:5 FlyDuration:f_duration FadeoutDuration:fo_duration
       RotateDuration:r_duration];
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
//    [enemy explode];
}

-(void)stopMovement {
    if (isMovingForward || isMovingBackward) {
        isMovingForward = isMovingBackward = false;
        [self removeAllActions];
    }
}


@end
