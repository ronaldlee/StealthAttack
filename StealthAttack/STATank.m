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

@synthesize tankr1;
@synthesize tankr2;
@synthesize tankr3;


- (id)initWithScale:(CGFloat)f_scale {
    self = [super init];
    if (self) {
        isVisible = TRUE;
        scale = f_scale;
        
        scaled_width = PIXEL_WIDTHHEIGHT*scale;
        scaled_height = PIXEL_WIDTHHEIGHT*scale;
        
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
        
        //wheels
        CGFloat wheel_x_offset = 1;
        CGFloat wheel_y_offset = -1;
        CGFloat wheel_width = 3;
        
        wheel_height = 2;
        UIColor *wheel_color = [UIColor blackColor];
        wheel_diff = 2;
        
        self.tankl1 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankl1];
        self.tankl1.position = CGPointMake(0-anchoroffset_x-wheel_x_offset,
                                           scaled_height-anchoroffset_y-wheel_y_offset);
        
        self.tankl2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankl2];
        self.tankl2.position = CGPointMake(0-anchoroffset_x-wheel_x_offset,
                                           self.tankl1.position.y-wheel_height-wheel_diff);
        
        self.tankl3 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankl3];
        self.tankl3.position = CGPointMake(0-anchoroffset_x-wheel_x_offset,
                                           self.tankl2.position.y-wheel_height-wheel_diff);
        
//        self.tankl4 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
//        [self addChild:self.tankl4];
//        self.tankl4.position = CGPointMake(0-anchoroffset_x-wheel_x_offset,
//                                           self.tankl3.position.y-wheel_height-wheel_diff);
        
        //==
        wheel_x_offset = -1;
        self.tankr1 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankr1];
        self.tankr1.position = CGPointMake(scaled_width*2-anchoroffset_x-wheel_x_offset,
                                           scaled_height-anchoroffset_y-wheel_y_offset);
        
        self.tankr2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankr2];
        self.tankr2.position = CGPointMake(scaled_width*2-anchoroffset_x-wheel_x_offset,
                                           self.tankl1.position.y-wheel_height-wheel_diff);
        
        self.tankr3 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,wheel_height)];
        [self addChild:self.tankr3];
        self.tankr3.position = CGPointMake(scaled_width*2-anchoroffset_x-wheel_x_offset,
                                           self.tankl2.position.y-wheel_height-wheel_diff);
        
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

-(void)moveLeftWheelsForward {
//    //make sure the wheels have same distance from each others
//    if (self.tankl1.position.y > self.tankl2.position.y > self.tankl3.position.y) {
//        self.tankl2.position =
//            CGPointMake(self.tankl2.position.x,self.tankl1.position.y-wheel_height-wheel_diff);
//        self.tankl3.position =
//            CGPointMake(self.tankl3.position.x,self.tankl2.position.y-wheel_height-wheel_diff);
//    }
//    else if (self.tankl2.position.y > self.tankl3.position.y > self.tankl1.position.y) {
//        self.tankl3.position =
//            CGPointMake(self.tankl3.position.x,self.tankl2.position.y-wheel_height-wheel_diff);
//        self.tankl1.position =
//            CGPointMake(self.tankl1.position.x,self.tankl3.position.y-wheel_height-wheel_diff);
//    }
//    else if (self.tankl3.position.y > self.tankl1.position.y > self.tankl2.position.y) {
//        self.tankl1.position =
//            CGPointMake(self.tankl1.position.x,self.tankl3.position.y-wheel_height-wheel_diff);
//        self.tankl2.position =
//            CGPointMake(self.tankl2.position.x,self.tankl1.position.y-wheel_height-wheel_diff);
//    }
    
    CGFloat speed = 1;
    CGFloat base_y = anchoroffset_y + 2;
    CGFloat tank_body_height = scaled_height*2;
    
    //left
    CGPoint location = CGPointMake(self.tankl1.position.x,0-base_y);
    CGPoint location2 = CGPointMake(self.tankl1.position.x,scaled_height*2-base_y);
    
    CGFloat duration_l1 = (self.tankl1.position.y+base_y)/tank_body_height*speed;
    CGFloat duration_l2 = (self.tankl2.position.y+base_y)/tank_body_height*speed;
    CGFloat duration_l3 = (self.tankl3.position.y+base_y)/tank_body_height*speed;
    
    SKAction *rotationl1 = [SKAction moveTo:location duration:duration_l1];
    SKAction *rotationl2 = [SKAction moveTo:location duration:duration_l2];
    SKAction *rotationl3 = [SKAction moveTo:location duration:duration_l3];
    
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
}

-(void)moveLeftWheelsBackward {
//    //make sure the wheels have same distance from each others
//    if (self.tankl1.position.y > self.tankl2.position.y > self.tankl3.position.y) {
//        self.tankl2.position =
//        CGPointMake(self.tankl2.position.x,self.tankl1.position.y-wheel_height-wheel_diff);
//        self.tankl3.position =
//        CGPointMake(self.tankl3.position.x,self.tankl2.position.y-wheel_height-wheel_diff);
//    }
//    else if (self.tankl2.position.y > self.tankl3.position.y > self.tankl1.position.y) {
//        self.tankl3.position =
//        CGPointMake(self.tankl3.position.x,self.tankl2.position.y-wheel_height-wheel_diff);
//        self.tankl1.position =
//        CGPointMake(self.tankl1.position.x,self.tankl3.position.y-wheel_height-wheel_diff);
//    }
//    else if (self.tankl3.position.y > self.tankl1.position.y > self.tankl2.position.y) {
//        self.tankl1.position =
//        CGPointMake(self.tankl1.position.x,self.tankl3.position.y-wheel_height-wheel_diff);
//        self.tankl2.position =
//        CGPointMake(self.tankl2.position.x,self.tankl1.position.y-wheel_height-wheel_diff);
//    }
    
    CGFloat speed = 1;
    CGFloat base_y = anchoroffset_y + 2;
    CGFloat tank_body_height = scaled_height*2;
    
    //left
    CGPoint location = CGPointMake(self.tankl1.position.x,scaled_height*2-base_y);
    CGPoint location2 = CGPointMake(self.tankl1.position.x,0-base_y);
    
    CGFloat duration_l1 = (tank_body_height-(self.tankl1.position.y+base_y))/tank_body_height*speed;
    CGFloat duration_l2 = (tank_body_height-(self.tankl2.position.y+base_y))/tank_body_height*speed;
    CGFloat duration_l3 = (tank_body_height-(self.tankl3.position.y+base_y))/tank_body_height*speed;
    
    SKAction *rotationl1 = [SKAction moveTo:location duration:duration_l1];
    SKAction *rotationl2 = [SKAction moveTo:location duration:duration_l2];
    SKAction *rotationl3 = [SKAction moveTo:location duration:duration_l3];
    
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
}

-(void)moveRightWheelsForward {
//    //make sure the wheels have same distance from each others
//    if (self.tankr1.position.y > self.tankr2.position.y > self.tankr3.position.y) {
//        self.tankr2.position =
//            CGPointMake(self.tankr2.position.x,self.tankr1.position.y-wheel_height-wheel_diff);
//        self.tankr3.position =
//            CGPointMake(self.tankr3.position.x,self.tankr2.position.y-wheel_height-wheel_diff);
//    }
//    else if (self.tankr2.position.y > self.tankr3.position.y > self.tankr1.position.y) {
//        self.tankr3.position =
//            CGPointMake(self.tankr3.position.x,self.tankr2.position.y-wheel_height-wheel_diff);
//        self.tankr1.position =
//            CGPointMake(self.tankr1.position.x,self.tankr3.position.y-wheel_height-wheel_diff);
//    }
//    else if (self.tankr3.position.y > self.tankr1.position.y > self.tankr2.position.y) {
//        self.tankr1.position =
//            CGPointMake(self.tankr1.position.x,self.tankr3.position.y-wheel_height-wheel_diff);
//        self.tankr2.position =
//            CGPointMake(self.tankr2.position.x,self.tankr1.position.y-wheel_height-wheel_diff);
//    }
    
    CGFloat speed = 1;
    CGFloat base_y = anchoroffset_y + 2;
    CGFloat tank_body_height = scaled_height*2;
    //right
    CGPoint location = CGPointMake(self.tankr1.position.x,0-base_y);
    CGPoint location2 = CGPointMake(self.tankr1.position.x,scaled_height*2-base_y);
    
    CGFloat duration_r1 = (self.tankr1.position.y+base_y)/tank_body_height*speed;
    CGFloat duration_r2 = (self.tankr2.position.y+base_y)/tank_body_height*speed;
    CGFloat duration_r3 = (self.tankr3.position.y+base_y)/tank_body_height*speed;
    
    SKAction *rotationr1 = [SKAction moveTo:location duration:duration_r1];
    SKAction *rotationr2 = [SKAction moveTo:location duration:duration_r2];
    SKAction *rotationr3 = [SKAction moveTo:location duration:duration_r3];
    
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
}

-(void)moveRightWheelsBackward {
//    //make sure the wheels have same distance from each others
//    if (self.tankr1.position.y > self.tankr2.position.y > self.tankr3.position.y) {
//        self.tankr2.position =
//        CGPointMake(self.tankr2.position.x,self.tankr1.position.y-wheel_height-wheel_diff);
//        self.tankr3.position =
//        CGPointMake(self.tankr3.position.x,self.tankr2.position.y-wheel_height-wheel_diff);
//    }
//    else if (self.tankr2.position.y > self.tankr3.position.y > self.tankr1.position.y) {
//        self.tankr3.position =
//        CGPointMake(self.tankr3.position.x,self.tankr2.position.y-wheel_height-wheel_diff);
//        self.tankr1.position =
//        CGPointMake(self.tankr1.position.x,self.tankr3.position.y-wheel_height-wheel_diff);
//    }
//    else if (self.tankr3.position.y > self.tankr1.position.y > self.tankr2.position.y) {
//        self.tankr1.position =
//        CGPointMake(self.tankr1.position.x,self.tankr3.position.y-wheel_height-wheel_diff);
//        self.tankr2.position =
//        CGPointMake(self.tankr2.position.x,self.tankr1.position.y-wheel_height-wheel_diff);
//    }
    
    CGFloat speed = 1;
    CGFloat base_y = anchoroffset_y + 2;
    CGFloat tank_body_height = scaled_height*2;
    //right
    CGPoint location = CGPointMake(self.tankr1.position.x,scaled_height*2-base_y);
    CGPoint location2 = CGPointMake(self.tankr1.position.x,0-base_y);
    
    CGFloat duration_r1 = (tank_body_height-(self.tankr1.position.y+base_y))/tank_body_height*speed;
    CGFloat duration_r2 = (tank_body_height-(self.tankr2.position.y+base_y))/tank_body_height*speed;
    CGFloat duration_r3 = (tank_body_height-(self.tankr3.position.y+base_y))/tank_body_height*speed;
    
    SKAction *rotationr1 = [SKAction moveTo:location duration:duration_r1];
    SKAction *rotationr2 = [SKAction moveTo:location duration:duration_r2];
    SKAction *rotationr3 = [SKAction moveTo:location duration:duration_r3];
    
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
}

-(void)moveForward {
    CGFloat x = cos([self getAdjRotation])*10000+self.position.x;
    CGFloat y = sin([self getAdjRotation])*10000+self.position.y;
    
    CGPoint location = CGPointMake(x,y);
    
    SKAction *rotation = [SKAction moveTo:location duration:300];
    
    [self runAction:[SKAction repeatActionForever:rotation]];
    
    [self moveLeftWheelsForward];
    [self moveRightWheelsForward];
}
-(void)moveBackward {
    CGFloat x = cos([self getAdjRotation]+M_PI)*10000+self.position.x;
    CGFloat y = sin([self getAdjRotation]+M_PI)*10000+self.position.y;
    
    CGPoint location = CGPointMake(x,y);
    
    SKAction *rotation = [SKAction moveTo:location duration:300];
    
    [self runAction:[SKAction repeatActionForever:rotation]];
    
    [self moveLeftWheelsBackward];
    [self moveRightWheelsBackward];
}

-(void)rotateClockwise {
    SKAction *rotation = [SKAction rotateByAngle:-M_PI*2 duration:3];
    
    [self runAction:[SKAction repeatActionForever:rotation]];
    
    [self moveLeftWheelsForward];
    [self moveRightWheelsBackward];
}
-(void)rotateCounterClockwise {
    SKAction *rotation = [SKAction rotateByAngle:M_PI*2 duration:3];
    
    [self runAction:[SKAction repeatActionForever:rotation]];
    
    [self moveLeftWheelsBackward];
    [self moveRightWheelsForward];
}

-(void)stop {
    [self removeAllActions];
    [self.tankl1 removeAllActions];
    [self.tankl2 removeAllActions];
    [self.tankl3 removeAllActions];
    [self.tankr1 removeAllActions];
    [self.tankr2 removeAllActions];
    [self.tankr3 removeAllActions];
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
