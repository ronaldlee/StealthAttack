//
//  STATank.m
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STATank.h"

@interface STATank() {
    CGRect bounds;
    float bottom_border_y, top_border_y, left_border_x, right_border_x;
    BOOL isVisible;
    BOOL is_firing;

    
    BOOL isMovingForward;
    BOOL isMovingBackward;
    BOOL isRotatingClockwise;
    BOOL isRotatingCounterClockwise;
    
    CGVector prevVelocity;
    
    CGFloat lastRotationDiff;
    CGFloat lastSelfRotate;
    
}
@end

@implementation STATank

@synthesize scale;
@synthesize brainNode;
@synthesize moveToNode;
@synthesize attackCooldownNode;
@synthesize attackNode;
@synthesize fadeInOutNode;

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

@synthesize wheel_height;
@synthesize wheel_diff;

@synthesize wheel_origin_y;
@synthesize wheel_bottom_y;

@synthesize playerId;

@synthesize tankBodyColor;
@synthesize tankBodyBaseColor;

@synthesize ai;

@synthesize rotation_speed;
@synthesize wheel_rotate_speed;

@synthesize lastX;
@synthesize lastY;
@synthesize lastDirection;
@synthesize lastRotation;
@synthesize fireCount;

@synthesize isExploded;
@synthesize isBrakingOn;
@synthesize danceNode;

@synthesize battleStage;

@synthesize moveSpeed;
@synthesize evadeSpeed;

@synthesize isGameOver;

@synthesize max_width;
@synthesize max_height;

@synthesize numShots;
@synthesize betweenShotsAccuracyInRadian;
@synthesize accuracyInRadian;
@synthesize attackAccuracyInRadian;
@synthesize bulletSpeed;
@synthesize attackCoolDownDuration;
@synthesize fadeOutDuration;

@synthesize isEnableStealth;

- (id)initWithScale:(CGFloat)f_scale Id:(int)t_id BodyColor:(UIColor*)b_color BodyBaseColor:(UIColor*)bb_color
                 AI:(STAAI*)t_ai Category:(uint32_t)category Bounds:(CGRect)p_bounds
                    IsEnableStealth:(BOOL)is_enable_stealth{
    self = [super init];
    if (self) {
        isEnableStealth = is_enable_stealth;
        bounds = p_bounds;
        
        left_border_x = bounds.origin.x;
        right_border_x = left_border_x+bounds.size.width;
        bottom_border_y = bounds.origin.y;
        top_border_y = bottom_border_y+bounds.size.height;
        
        //
        isGameOver = false;
        isBrakingOn = true;
        lastX = -1;
        lastY = -1;
        rotation_speed = 3;
        wheel_rotate_speed= 1;
        ai = t_ai;
        
        tankBodyColor = b_color;
        tankBodyBaseColor = bb_color;
        
        playerId = t_id;
        moveSpeed = 20;
        evadeSpeed= 20;
        isVisible = TRUE;
        scale = f_scale;
        numShots = 1;
        betweenShotsAccuracyInRadian=0;
        accuracyInRadian=5;
        attackAccuracyInRadian=5;
        bulletSpeed = 100;
        fadeOutDuration = 1;
        attackCoolDownDuration = 5;
        
        scaled_width = PIXEL_WIDTHHEIGHT*scale; //6
        scaled_height = PIXEL_WIDTHHEIGHT*scale; //6
        
        max_width = scaled_width*[self getWidthInPixels];
        max_height = scaled_height*[self getHeightInPixels];
        
        anchoroffset_x = [self setupAnchorOffsetX]; //max_width/2;
        anchoroffset_y = [self setupAnchorOffsetY]; //max_height/2;
        
//        NSLog(@"max width: %f, %f, ancx/y: %f, %f", max_width, max_height, anchoroffset_x,anchoroffset_y);
        
        brainNode = [[SKNode alloc] init];
        [self addChild:brainNode];
        
        moveToNode = [[SKNode alloc] init];
        [self addChild:moveToNode];
        
        attackNode =[[SKNode alloc] init];
        [self addChild:attackNode];
        
        attackCooldownNode = [[SKNode alloc] init];
        [self addChild:attackCooldownNode];
        
        fadeInOutNode = [[SKNode alloc] init];
        [self addChild:fadeInOutNode];
        
        danceNode = [[SKNode alloc] init];
        [self addChild:danceNode];
        
        [self buildTankBody];
        
        //wheels
        [self buildTankWheels];
        
//        self.size = CGSizeMake(max_width, max_height);
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(max_width, max_height)];
        
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = category;
//        self.physicsBody.contactTestBitMask = 0;
//        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.contactTestBitMask = ENEMY_CATEGORY | WALL_CATEGORY | PLAYER_CATEGORY;
//        self.physicsBody.collisionBitMask = WALL_CATEGORY | PLAYER_CATEGORY | ENEMY_CATEGORY;
        self.physicsBody.collisionBitMask = WALL_CATEGORY;
        self.physicsBody.restitution = 0.0f;//-1.0f;
//        self.physicsBody.density = 0.0f;
        self.physicsBody.mass = 0.0f;
        
        //need these so the tank won't slow down when moving
        self.physicsBody.friction = 0;
        self.physicsBody.linearDamping = 0;
        self.physicsBody.angularDamping = 0;
        
//        NSLog(@"tb.top.y: %f, y: %f", self.tankB.position.y+self.tankB.size.height, self.tankB.position.y);
//        NSLog(@"start tl1.y: %f, l2: %f, l3: %f, l4: %f",self.tankl1.position.y,self.tankl2.position.y,self.tankl3.position.y,self.tankl4.position.y);
//        NSLog(@"start wheel origin y: %f, bottom y: %f",wheel_origin_y,wheel_bottom_y);
        
//        lastX = self.position.x;
//        lastY = self.position.y;
//        lastDirection = self.physicsBody.velocity;
        
        if (ai != NULL) {
            [self preAiConfig];
            [ai setHost:self];
            SKAction* aiAction = [SKAction runBlock:^(void) {
                [ai think];
            }];
            
            SKAction *wait = [SKAction waitForDuration:ai.thinkSpeed];
            [self.brainNode runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait,aiAction]]]];
        }
    }
    return self;
}

-(void)preAiConfig {
    
}

-(CGFloat)setupAnchorOffsetX {
    return scaled_width;
}

-(CGFloat)setupAnchorOffsetY {
    return scaled_height;
}

-(void) buildTankWheels {
    CGFloat wheel_x_offset = 0.5*scale;
    CGFloat wheel_y_offset = 0.5*scale;
    CGFloat wheel_width = 1.5*scale;
    
    wheel_height = 1*scale;
    UIColor *wheel_color = [UIColor blackColor];
    wheel_diff = 1*scale;
    
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
    
    //==
    wheel_x_offset = 1*scale;
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
}

-(void) buildTankBody {
    self.tankA = [SKSpriteNode spriteNodeWithColor:tankBodyColor size:CGSizeMake(scaled_width/2,scaled_height)];
    [self addChild:self.tankA];
    self.tankA.position = CGPointMake(scaled_width-anchoroffset_x,scaled_height*2-anchoroffset_y);
    
    //==
    self.tankB = [SKSpriteNode spriteNodeWithColor:tankBodyBaseColor size:CGSizeMake(scaled_width,scaled_height)];
    [self addChild:self.tankB];
    self.tankB.position = CGPointMake(0-anchoroffset_x,scaled_height-anchoroffset_y);
    
    self.tankC = [SKSpriteNode spriteNodeWithColor:tankBodyColor size:CGSizeMake(scaled_width,scaled_height)];
    [self addChild:self.tankC];
    self.tankC.position = CGPointMake(scaled_width-anchoroffset_x,scaled_height-anchoroffset_y);
    
    self.tankD = [SKSpriteNode spriteNodeWithColor:tankBodyBaseColor size:CGSizeMake(scaled_width,scaled_height)];
    [self addChild:self.tankD];
    self.tankD.position = CGPointMake(scaled_width*2-anchoroffset_x,scaled_height-anchoroffset_y);
    
    //==
    self.tankE = [SKSpriteNode spriteNodeWithColor:tankBodyBaseColor size:CGSizeMake(scaled_width,scaled_height)];
    [self addChild:self.tankE];
    self.tankE.position = CGPointMake(0-anchoroffset_x,0-anchoroffset_y);
    
    self.tankF = [SKSpriteNode spriteNodeWithColor:tankBodyColor size:CGSizeMake(scaled_width,scaled_height)];
    [self addChild:self.tankF];
    self.tankF.position = CGPointMake(scaled_width-anchoroffset_x,0-anchoroffset_y);
    
    self.tankG = [SKSpriteNode spriteNodeWithColor:tankBodyBaseColor size:CGSizeMake(scaled_width,scaled_height)];
    [self addChild:self.tankG];
    self.tankG.position = CGPointMake(scaled_width*2-anchoroffset_x,0-anchoroffset_y);
}

-(void)setBodyColor:(UIColor*)color BaseColor:(UIColor*)b_color {
    self.tankA.color = color;
    self.tankB.color = b_color;
    self.tankC.color = color;
    self.tankD.color = b_color;
    self.tankE.color = b_color;
    self.tankF.color = color;
    self.tankG.color = b_color;
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

//-(void)setBorderBounds:(CGRect)p_bounds {
//    bounds = p_bounds;
//    
//    left_border_x = bounds.origin.x;
//    right_border_x = left_border_x+bounds.size.width;
//    bottom_border_y = bounds.origin.y;
//    top_border_y = bottom_border_y+bounds.size.height;
//}

-(CGRect)getBorderBounds {
    return bounds;
}
-(void)setBorderBounds:(CGRect)player_bounds {
    bounds = player_bounds;
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
//    NSLog(@"forward tl1.y: %f, l2: %f, l3: %f, l4: %f",
//          self.tankl1.position.y,self.tankl2.position.y,self.tankl3.position.y,self.tankl4.position.y);
    
    [self correctLeftWheels];
    
    CGFloat tank_body_height = scaled_height*3-wheel_height;
    
//    NSLog(@"forward wheel_origin_y: %f, bottom_y: %f, tank_body_height: %f",
//          wheel_origin_y,wheel_bottom_y,tank_body_height);
    
    //left
    CGPoint base_location = CGPointMake(self.tankl1.position.x,wheel_bottom_y);
    CGPoint start_location = CGPointMake(self.tankl1.position.x,wheel_origin_y);
    
    CGFloat duration_l1 = fabsf(wheel_bottom_y-self.tankl1.position.y)/tank_body_height*wheel_rotate_speed;
    CGFloat duration_l2 = fabsf(wheel_bottom_y-self.tankl2.position.y)/tank_body_height*wheel_rotate_speed;
    CGFloat duration_l3 = fabsf(wheel_bottom_y-self.tankl3.position.y)/tank_body_height*wheel_rotate_speed;
    CGFloat duration_l4 = fabsf(wheel_bottom_y-self.tankl4.position.y)/tank_body_height*wheel_rotate_speed;
    
    SKAction *rotationl1 = [SKAction moveTo:base_location duration:duration_l1];
    SKAction *rotationl2 = [SKAction moveTo:base_location duration:duration_l2];
    SKAction *rotationl3 = [SKAction moveTo:base_location duration:duration_l3];
    SKAction *rotationl4 = [SKAction moveTo:base_location duration:duration_l4];
    
//    SKAction *correct = [SKAction runBlock:^(void) {
//        [self correctLeftWheels];
//    }];
    
    //move back to top
    SKAction *rotation2 = [SKAction moveTo:start_location duration:0];
    SKAction *rotation3 = [SKAction moveTo:base_location duration:wheel_rotate_speed];
    
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
    
    CGFloat tank_body_height = scaled_height*3-wheel_height;
    //right
    CGPoint location = CGPointMake(self.tankr1.position.x,wheel_bottom_y);
    CGPoint location2 = CGPointMake(self.tankr1.position.x,wheel_origin_y);
    
    CGFloat duration_r1 = fabsf(wheel_bottom_y-self.tankr1.position.y)/tank_body_height*wheel_rotate_speed;
    CGFloat duration_r2 = fabsf(wheel_bottom_y-self.tankr2.position.y)/tank_body_height*wheel_rotate_speed;
    CGFloat duration_r3 = fabsf(wheel_bottom_y-self.tankr3.position.y)/tank_body_height*wheel_rotate_speed;
    CGFloat duration_r4 = fabsf(wheel_bottom_y-self.tankr4.position.y)/tank_body_height*wheel_rotate_speed;
    
    SKAction *rotationr1 = [SKAction moveTo:location duration:duration_r1];
    SKAction *rotationr2 = [SKAction moveTo:location duration:duration_r2];
    SKAction *rotationr3 = [SKAction moveTo:location duration:duration_r3];
    SKAction *rotationr4 = [SKAction moveTo:location duration:duration_r4];
    
//    SKAction *correct = [SKAction runBlock:^(void) {
//        [self correctRightWheels];
//    }];
    
    //move back to top
    SKAction *rotation2 = [SKAction moveTo:location2 duration:0];
    SKAction *rotation3 = [SKAction moveTo:location duration:wheel_rotate_speed];
    
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
    
    CGFloat tank_body_height = scaled_height*3-wheel_height;
    
//    NSLog(@"bw base_y: %f: tank_body_height: %f: wheel_origin_y: %f",base_y, tank_body_height, wheel_origin_y);
    
    //left
    CGPoint location = CGPointMake(self.tankl1.position.x,wheel_origin_y);
    CGPoint location2 = CGPointMake(self.tankl1.position.x,wheel_bottom_y);
    
    CGFloat duration_l1 = (tank_body_height-fabsf(wheel_bottom_y-self.tankl1.position.y))/tank_body_height*wheel_rotate_speed;
    CGFloat duration_l2 = (tank_body_height-fabsf(wheel_bottom_y-self.tankl2.position.y))/tank_body_height*wheel_rotate_speed;
    CGFloat duration_l3 = (tank_body_height-fabsf(wheel_bottom_y-self.tankl3.position.y))/tank_body_height*wheel_rotate_speed;
    CGFloat duration_l4 = (tank_body_height-fabsf(wheel_bottom_y-self.tankl4.position.y))/tank_body_height*wheel_rotate_speed;
    
    SKAction *rotationl1 = [SKAction moveTo:location duration:duration_l1];
    SKAction *rotationl2 = [SKAction moveTo:location duration:duration_l2];
    SKAction *rotationl3 = [SKAction moveTo:location duration:duration_l3];
    SKAction *rotationl4 = [SKAction moveTo:location duration:duration_l4];
    
    //move back to top
    SKAction *rotation2 = [SKAction moveTo:location2 duration:0];
    SKAction *rotation3 = [SKAction moveTo:location duration:wheel_rotate_speed];
    
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
    
    CGFloat tank_body_height = scaled_height*3-wheel_height;
    //right
    CGPoint location = CGPointMake(self.tankr1.position.x,wheel_origin_y);
    CGPoint location2 = CGPointMake(self.tankr1.position.x,wheel_bottom_y);
    
    CGFloat duration_r1 = (tank_body_height-fabsf(wheel_bottom_y-self.tankr1.position.y))/tank_body_height*wheel_rotate_speed;
    CGFloat duration_r2 = (tank_body_height-fabsf(wheel_bottom_y-self.tankr2.position.y))/tank_body_height*wheel_rotate_speed;
    CGFloat duration_r3 = (tank_body_height-fabsf(wheel_bottom_y-self.tankr3.position.y))/tank_body_height*wheel_rotate_speed;
    CGFloat duration_r4 = (tank_body_height-fabsf(wheel_bottom_y-self.tankr4.position.y))/tank_body_height*wheel_rotate_speed;
    
    SKAction *rotationr1 = [SKAction moveTo:location duration:duration_r1];
    SKAction *rotationr2 = [SKAction moveTo:location duration:duration_r2];
    SKAction *rotationr3 = [SKAction moveTo:location duration:duration_r3];
    SKAction *rotationr4 = [SKAction moveTo:location duration:duration_r4];
    
    //move back to top
    SKAction *rotation2 = [SKAction moveTo:location2 duration:0];
    SKAction *rotation3 = [SKAction moveTo:location duration:wheel_rotate_speed];
    
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
    if (isRotatingClockwise || isRotatingCounterClockwise || isMovingBackward || isGameOver) return;
    isMovingForward= true;
    
    CGFloat x = cos([self getAdjRotation])*moveSpeed;//+self.position.x;
    CGFloat y = sin([self getAdjRotation])*moveSpeed;//+self.position.y;
    
//    CGPoint location = CGPointMake(x,y);
//    
//    SKAction *rotation = [SKAction moveTo:location duration:300];
//    
//    [self runAction:[SKAction repeatActionForever:rotation]];
    
    if (!isBrakingOn) {
        self.physicsBody.velocity = CGVectorMake(x, y);
    }
    
    [self moveLeftWheelsBackward];
    [self moveRightWheelsBackward];
}

-(void)evadeForward {
    if (isRotatingClockwise || isRotatingCounterClockwise || isMovingBackward || isGameOver) return;
    isMovingForward= true;
    
    CGFloat x = cos([self getAdjRotation])*evadeSpeed;//+self.position.x;
    CGFloat y = sin([self getAdjRotation])*evadeSpeed;//+self.position.y;
    
    if (!isBrakingOn) {
        self.physicsBody.velocity = CGVectorMake(x, y);
    }
    
    [self moveLeftWheelsBackward];
    [self moveRightWheelsBackward];
}

-(void)moveForwardToX:(CGFloat)dest_x Y:(CGFloat)dest_y complete:(void (^)() )block {
    if (isRotatingClockwise || isRotatingCounterClockwise || isMovingBackward || isGameOver) return;
    isMovingForward= true;
    
    CGFloat x = cos([self getAdjRotation])*moveSpeed;//+self.position.x;
    CGFloat y = sin([self getAdjRotation])*moveSpeed;//+self.position.y;
    
    CGFloat xdiff = self.position.x - dest_x;
    CGFloat ydiff = self.position.y - dest_y;
    CGFloat distance = sqrt(xdiff*xdiff + ydiff*ydiff);
    CGFloat duration = distance/moveSpeed;
    
    [moveToNode removeAllActions];
    
    SKAction* stopAction = [SKAction runBlock:^(void) {
        NSLog(@"I am there!!");
        [self stop];
        block();
    }];
    
    SKAction *wait = [SKAction waitForDuration:duration];
    SKAction* sequence=[SKAction sequence:@[wait,stopAction]];
    
    [moveToNode runAction:sequence];
    
    self.physicsBody.velocity = CGVectorMake(x, y);
    
    [self moveLeftWheelsForward];
    [self moveRightWheelsForward];
}

-(void)moveBackward {
    if (isRotatingClockwise || isRotatingCounterClockwise || isMovingForward || isGameOver) return;
    isMovingBackward= true;
    
    CGFloat x = cos([self getAdjRotation]+M_PI)*moveSpeed;//+self.position.x;
    CGFloat y = sin([self getAdjRotation]+M_PI)*moveSpeed;//+self.position.y;
    
    if (!isBrakingOn) {
        self.physicsBody.velocity = CGVectorMake(x, y);
    }
    
    [self moveLeftWheelsForward];
    [self moveRightWheelsForward];
}

-(void)evadeBackward {
    if (isRotatingClockwise || isRotatingCounterClockwise || isMovingForward || isGameOver) return;
    isMovingBackward= true;
    
    CGFloat x = cos([self getAdjRotation]+M_PI)*evadeSpeed;//+self.position.x;
    CGFloat y = sin([self getAdjRotation]+M_PI)*evadeSpeed;//+self.position.y;
    
    if (!isBrakingOn) {
        self.physicsBody.velocity = CGVectorMake(x, y);
    }
    
    [self moveLeftWheelsForward];
    [self moveRightWheelsForward];
}

-(void)rotateClockwise {
    if (isRotatingCounterClockwise || isMovingForward || isMovingBackward || isGameOver) return;
    isRotatingClockwise= true;
    
    SKAction *rotation = [SKAction rotateByAngle:-M_PI*2 duration:rotation_speed];
    
    [self runAction:[SKAction repeatActionForever:rotation]];
    
    [self moveLeftWheelsBackward];
    [self moveRightWheelsForward];
}
-(void)rotateCounterClockwise {
    if (isRotatingClockwise || isMovingForward || isMovingBackward || isGameOver) return;
    isRotatingCounterClockwise= true;
    
    SKAction *rotation = [SKAction rotateByAngle:M_PI*2 duration:rotation_speed];
    
    [self runAction:[SKAction repeatActionForever:rotation]];
    
    [self moveLeftWheelsForward];
    [self moveRightWheelsBackward];
}

-(void)rotateInDegree:(CGFloat)degree complete:(void (^)() )block{
    if (degree < 0) {
        //rotate clockwise
        if (isRotatingCounterClockwise || isMovingForward || isMovingBackward) return;
        isRotatingClockwise= true;
        
        SKAction *rotation = [SKAction rotateByAngle:degree duration:degree/(-M_PI*2)*rotation_speed];
        
        [self runAction:rotation completion:^(void) {
            [self updateLastSelfRotate];
            [self stop];
            if (block) {
                block();
            }
        }];
        
        [self moveLeftWheelsBackward];
        [self moveRightWheelsForward];
    }
    else {
        //rotate counter clockwise
        if (isRotatingClockwise || isMovingForward || isMovingBackward) return;
        isRotatingCounterClockwise= true;
        
        SKAction *rotation = [SKAction rotateByAngle:degree duration:degree/(M_PI*2)*rotation_speed];
        
        [self runAction:rotation completion:^(void) {
            [self updateLastSelfRotate];
            [self stop];
            if (block) {
                block();
            }
        }];
        
        [self moveLeftWheelsForward];
        [self moveRightWheelsBackward];
    }
}


-(void)explodePart:(SKSpriteNode*)part XDiff:(CGFloat)x_diff YDiff:(CGFloat)y_diff
       FlyDuration:(float)f_duration FadeoutDuration:(float)fo_duration
       RotateDuration:(float)r_duration{
    
    self.physicsBody = NULL;
    
    CGFloat cur_x = part.position.x;
    CGFloat cur_y = part.position.y;
    
    SKAction *rotate = [SKAction rotateByAngle:360.0 duration:r_duration];//[SKAction rotateByAngle:360.0 duration:r_duration];
    
    SKAction *fadeout = [SKAction fadeOutWithDuration:fo_duration];
    SKAction *m_hand_1_explode = [SKAction moveTo:CGPointMake(cur_x+x_diff, cur_y+y_diff) duration:f_duration];
    
    [part runAction:m_hand_1_explode];
//    [part runAction:[SKAction repeatActionForever:rotate]];
    [part runAction:rotate];
    
//    SKAction *wait = [SKAction waitForDuration:f_duration-fo_duration];
//    SKAction* sequence=[SKAction sequence:@[wait,fadeout]];
//    [part runAction:sequence];
}

-(void)explode {
    if (isExploded) return;
    
    isExploded = true;
    [self removeAllActions];
    
    float f_duration = 2.0;
    float fo_duration = 10;//0.5;
    float r_duration = 2.0;
    
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
    
    [self fadeInNow];
}

-(void)toggleFiring {
    is_firing = !is_firing;
}

-(BOOL)isFiring {
    return is_firing;
}

-(void)contactWith:(id<STAGameObject>)gameObj {
    //player can only contact with monster
    
    //drop eneryg
    
    STAEnemyTank* enemy = (STAEnemyTank*)gameObj;
    
    //monster explode
//    [enemy explode];
}


-(void)stopVelocity {
    prevVelocity = self.physicsBody.velocity;
    self.physicsBody.velocity = CGVectorMake(0, 0);
}

-(void)restoreVelocity {
    self.physicsBody.velocity = prevVelocity;
}

-(void)updateLastPositionData {
//    NSLog(@"update last pos: x: %f; y: %f; rotate: %f; v.dx: %f; dy: %f",
//          self.position.x,self.position.y,self.self.zRotation,
//          self.physicsBody.velocity.dx,self.physicsBody.velocity.dy);
    
    lastX = self.position.x;
    lastY = self.position.y;
    lastDirection = self.physicsBody.velocity;
    
    lastRotationDiff = self.zRotation - lastRotation;
    lastRotation = self.zRotation;
}

-(void)clearLastPositionData {
    lastX = -1;
    lastY = -1;
}

-(void)updateLastSelfRotate {
    lastSelfRotate = self.zRotation;
}

-(CGFloat)getLastSelfRotate {
    return lastSelfRotate;
}

-(void)stopBrain {
    [self.brainNode removeAllActions];
}

-(void) setBattleStage:(STABattleStage*)stage {
    battleStage = stage;
}

-(void)fire {
    if (isBrakingOn || isGameOver) return;
    
    if (battleStage != NULL) {
        [battleStage fireBullet:self];
    }
}

//=============================
//============== STOP functions

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
   
    [moveToNode removeAllActions];
    
    if (ai != NULL) {
        ai.isApproaching = false;
        ai.isRotating = false;
    }
}

-(void)stopMovement {
    if (isMovingForward || isMovingBackward) {
        isMovingForward = isMovingBackward = false;
        [self removeAllActions];
    }
}

-(CGFloat)getMoveSpeed {
    return moveSpeed;
}

-(void)fadeInThenOutPreFadeOut {
}

-(void)fadeInThenOut {
    if (!isEnableStealth && !isGameOver) return;
    
    SKAction* fadeIn=[SKAction fadeInWithDuration:1];
    
    [self.tankA runAction:fadeIn];
    [self.tankB runAction:fadeIn];
    [self.tankC runAction:fadeIn];
    [self.tankD runAction:fadeIn];
    [self.tankE runAction:fadeIn];
    [self.tankF runAction:fadeIn];
    
    [self fadeInThenOutPreFadeOut];
    [self.tankG runAction:fadeIn completion:^() {
        [self fadeOut];
    }];
}

-(void)fadeOut {
    if (!isEnableStealth && !isGameOver) return;
    
    [self stopFadeOut];
    
    SKAction* fadeOut=[SKAction fadeOutWithDuration:self.fadeOutDuration];
    
    [self.tankA runAction:fadeOut completion:^() {
        if (isGameOver) {
            self.tankA.alpha = 1.0;
        }
    }];
    [self.tankB runAction:fadeOut completion:^() {
        if (isGameOver) {
            self.tankB.alpha = 1.0;
        }
    }];
    [self.tankC runAction:fadeOut completion:^() {
        if (isGameOver) {
            self.tankC.alpha = 1.0;
        }
    }];
    [self.tankD runAction:fadeOut completion:^() {
        if (isGameOver) {
            self.tankD.alpha = 1.0;
        }
    }];
    [self.tankE runAction:fadeOut completion:^() {
        if (isGameOver) {
            self.tankE.alpha = 1.0;
        }
    }];
    [self.tankF runAction:fadeOut completion:^() {
        if (isGameOver) {
            self.tankF.alpha = 1.0;
        }
    }];
    [self.tankG runAction:fadeOut completion:^() {
        if (isGameOver) {
            self.tankG.alpha = 1.0;
        }
    }];
}

-(void) stopFadeOut {
    [self.tankA removeAllActions];
    [self.tankB removeAllActions];
    [self.tankC removeAllActions];
    [self.tankD removeAllActions];
    [self.tankE removeAllActions];
    [self.tankF removeAllActions];
    [self.tankG removeAllActions];
    
    if (isGameOver) {
        [self fadeInNow];
    }
}

-(void)fadeInNow {
    isGameOver = true;
    
    if (!isEnableStealth) return;
    
    self.tankA.alpha = 1.0;
    self.tankB.alpha = 1.0;
    self.tankC.alpha = 1.0;
    self.tankD.alpha = 1.0;
    self.tankE.alpha = 1.0;
    self.tankF.alpha = 1.0;
    self.tankG.alpha = 1.0;
    
}

-(void) dance:(int)regionId {
    
    if (ai != NULL) {
        [ai dance:regionId];
    }
    else {
        SKAction* dance = [SKAction runBlock:^(){
            CGFloat dance_degree = (CGFloat)arc4random_uniform(314)/(CGFloat)100;

            [self rotateInDegree:dance_degree complete:^(){
                CGFloat dance_degree = (CGFloat)arc4random_uniform(314)/(CGFloat)100;
                dance_degree *= -1;
                
                [self rotateInDegree:dance_degree complete:^(){
                    CGFloat dance_degree = (CGFloat)arc4random_uniform(314)/(CGFloat)100;
                    
                    if (regionId != -1) {
                        CGPoint guess_xy = [self getXYByRegionId:regionId];
                        
                        if (guess_xy.x != -1 && guess_xy.y != -1) {
                            [self faceEnemy_LastX:guess_xy.x LastY:guess_xy.y];
                        }
                    }
                    else {
                        [self rotateInDegree:dance_degree complete:^(){
                            [self stop];
                        }];
                    }
                    
                }];
                
            }];
        }];
        
        [self.danceNode runAction:dance];
    }
}

-(void)faceEnemy_LastX:(CGFloat)p_lastX LastY:(CGFloat)p_lastY {
    
    CGFloat faceRotate = [self calculateAngleX1:self.position.x Y1:self.position.y
                                             X2:p_lastX Y2:p_lastY];
    
    CGFloat degree1 = (M_PI_2-faceRotate) + M_PI_2;
    
    CGFloat degree1DiffFromLast = degree1 - self.zRotation;
    
    CGFloat degree2 = degree1DiffFromLast-M_PI * 2;
    CGFloat degree_to_use = degree1DiffFromLast;
    
    if (fabs(degree2) < fabs(degree1DiffFromLast)) {
        degree_to_use=degree2;
    }
    
    [self rotateInDegree:degree_to_use complete:NULL];
}


-(CGFloat) calculateAngleX1:(CGFloat)x1 Y1:(CGFloat)y1 X2:(CGFloat)x2 Y2:(CGFloat)y2 {
    
    CGFloat x = x2-x1;
    CGFloat y = y2-y1;
    CGFloat baseangle = atan2(-x,-y);
    
    return baseangle;
}

-(CGPoint) getXYByRegionId:(int)p_region_id {
    
    CGFloat block_width = bounds.size.width/3;
    CGFloat block_height = bounds.size.height/3;
    CGFloat right_x = bounds.origin.x+bounds.size.width;
    CGFloat top_y = bounds.origin.y+bounds.size.height;
    
    CGFloat new_x = -1;
    CGFloat new_y = -1;
    
    int region_id=1;
    BOOL isFound = false;
    for (CGFloat x = bounds.origin.x; x < right_x && !isFound; x+=block_width) {
        for (CGFloat y = bounds.origin.y; y < top_y && !isFound; y+=block_height) {
            if (p_region_id == region_id) {
                //find the mid point of this region, and randomize a point in it
                int rand_x = (int)arc4random_uniform(block_width/2);
                int rand_y = (int)arc4random_uniform(block_height/2);
                
                int rand_xdir = arc4random_uniform(2);
                if (rand_xdir == 1) {
                    rand_x *= -1;
                }
                int rand_ydir = arc4random_uniform(2);
                if (rand_ydir == 1) {
                    rand_y *= -1;
                }
                
                new_x = x + block_width/2 + rand_x;
                new_y = y + block_height/2 + rand_y;
                
                isFound = true;
                break;
            }
            region_id++;
        }
    }
    
    return CGPointMake(new_x, new_y);
}


@end
