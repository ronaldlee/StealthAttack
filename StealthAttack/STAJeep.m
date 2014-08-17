//
//  STAJeep.m
//  StealthAttack
//
//  Created by Ronald Lee on 8/16/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAJeep.h"
@interface STAJeep() {
    CGFloat front_wheel_origin_y;
    CGFloat front_wheel_bottom_y;
    
    CGFloat back_wheel_origin_y;
    CGFloat back_wheel_bottom_y;
}
@end

@implementation STAJeep

@synthesize tankFl;
@synthesize tankFl2;
@synthesize tankFr;
@synthesize tankFr2;
@synthesize tankBl;
@synthesize tankBl2;
@synthesize tankBr;
@synthesize tankBr2;

- (id)initWithScale:(CGFloat)f_scale Id:(int)t_id BodyColor:tankBodyColor BodyBaseColor:tankBodyBaseColor AI:(STAAI*) ai RotationSpeed:(CGFloat)r_speed Category:(uint32_t)category Bounds:(CGRect)p_bounds {
    
    self = [super initWithScale:f_scale Id:t_id BodyColor:tankBodyColor BodyBaseColor:tankBodyBaseColor AI:ai
                  RotationSpeed:r_speed Category:category Bounds:p_bounds];
    
    return self;
}

-(CGFloat)setupAnchorOffsetX {
    return self.scaled_width;
}

-(CGFloat)setupAnchorOffsetY {
    return self.scaled_height+3;
}



-(void) buildTankBody {
    self.tankA = [SKSpriteNode spriteNodeWithColor:self.tankBodyColor size:CGSizeMake(self.scaled_width/2,self.scaled_height)];
    [self addChild:self.tankA];
    self.tankA.position = CGPointMake(self.scaled_width-self.anchoroffset_x,self.scaled_height*2-self.anchoroffset_y);
    
    //==
    self.tankB = [SKSpriteNode spriteNodeWithColor:self.tankBodyBaseColor size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankB];
    self.tankB.position = CGPointMake(0-self.anchoroffset_x,self.scaled_height*2-self.anchoroffset_y);
    
    self.tankC = [SKSpriteNode spriteNodeWithColor:self.tankBodyColor size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankC];
    self.tankC.position = CGPointMake(self.scaled_width-self.anchoroffset_x,self.scaled_height-self.anchoroffset_y);
    
    self.tankD = [SKSpriteNode spriteNodeWithColor:self.tankBodyBaseColor size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankD];
    self.tankD.position = CGPointMake(self.scaled_width*2-self.anchoroffset_x,self.scaled_height*2-self.anchoroffset_y);
    
    //==
    self.tankE = [SKSpriteNode spriteNodeWithColor:self.tankBodyBaseColor size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankE];
    self.tankE.position = CGPointMake(0-self.anchoroffset_x,0-self.anchoroffset_y);
    
    self.tankF = [SKSpriteNode spriteNodeWithColor:self.tankBodyColor size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankF];
    self.tankF.position = CGPointMake(self.scaled_width-self.anchoroffset_x,0-self.anchoroffset_y);
    
    self.tankG = [SKSpriteNode spriteNodeWithColor:self.tankBodyBaseColor size:CGSizeMake(self.scaled_width,self.scaled_height)];
    [self addChild:self.tankG];
    self.tankG.position = CGPointMake(self.scaled_width*2-self.anchoroffset_x,0-self.anchoroffset_y);
}

-(void) buildTankWheels {
    CGFloat wheel_x_offset = 1;
    CGFloat wheel_y_offset = -4;
    CGFloat wheel_width = 3;
    
    self.wheel_height = 1;
    UIColor *wheel_color = [UIColor blackColor];
    self.wheel_diff = 1;
    
    self.tankl1 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankl1];
    self.tankl1.position = CGPointMake(0-self.anchoroffset_x-wheel_x_offset,
                                       self.scaled_height*2-wheel_y_offset-self.anchoroffset_y);
    
    front_wheel_origin_y = self.tankl1.position.y;
    
    self.tankFl = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankFl];
    self.tankFl.position = CGPointMake(0-self.anchoroffset_x-wheel_x_offset,
                                       self.tankl1.position.y-self.wheel_height-self.wheel_diff);
    
    self.tankFl2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankFl2];
    self.tankFl2.position = CGPointMake(0-self.anchoroffset_x-wheel_x_offset,
                                       self.tankFl.position.y-self.wheel_height-self.wheel_diff);
    
    self.tankl2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankl2];
    self.tankl2.position = CGPointMake(0-self.anchoroffset_x-wheel_x_offset,
                                       self.tankFl2.position.y-self.wheel_height-self.wheel_diff);
    
    front_wheel_bottom_y = self.tankl2.position.y-self.wheel_height-self.wheel_diff;
    
    //==
    
    self.tankl3 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankl3];
    self.tankl3.position = CGPointMake(0-self.anchoroffset_x-wheel_x_offset,
                                       -wheel_y_offset-self.anchoroffset_y);
    
    back_wheel_origin_y = self.tankl3.position.y;
    
    self.tankBl = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankBl];
    self.tankBl.position = CGPointMake(0-self.anchoroffset_x-wheel_x_offset,
                                       self.tankl3.position.y-self.wheel_height-self.wheel_diff);
    
    self.tankBl2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankBl2];
    self.tankBl2.position = CGPointMake(0-self.anchoroffset_x-wheel_x_offset,
                                       self.tankBl.position.y-self.wheel_height-self.wheel_diff);
    
    self.tankl4 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankl4];
    self.tankl4.position = CGPointMake(0-self.anchoroffset_x-wheel_x_offset,
                                       self.tankBl2.position.y-self.wheel_height-self.wheel_diff);
    
    back_wheel_bottom_y = self.tankl4.position.y-self.wheel_height-self.wheel_diff;
    
    //==
    wheel_x_offset = 2;
    self.tankr1 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankr1];
    self.tankr1.position = CGPointMake(self.scaled_width*3-wheel_width-wheel_x_offset-self.anchoroffset_x,
                                       self.scaled_height*2-wheel_y_offset-self.anchoroffset_y);
    
    self.tankFr = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankFr];
    self.tankFr.position = CGPointMake(self.scaled_width*3-wheel_width-wheel_x_offset-self.anchoroffset_x,
                                       self.tankr1.position.y-self.wheel_height-self.wheel_diff);
    
    self.tankFr2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankFr2];
    self.tankFr2.position = CGPointMake(self.scaled_width*3-wheel_width-wheel_x_offset-self.anchoroffset_x,
                                       self.tankFr.position.y-self.wheel_height-self.wheel_diff);
    
    self.tankr2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankr2];
    self.tankr2.position = CGPointMake(self.scaled_width*3-wheel_width-wheel_x_offset-self.anchoroffset_x,
                                       self.tankFr2.position.y-self.wheel_height-self.wheel_diff);
    //==
    
    self.tankr3 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankr3];
    self.tankr3.position = CGPointMake(self.scaled_width*3-wheel_width-wheel_x_offset-self.anchoroffset_x,
                                       -wheel_y_offset-self.anchoroffset_y);
    
    self.tankBr = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankBr];
    self.tankBr.position = CGPointMake(self.scaled_width*3-wheel_width-wheel_x_offset-self.anchoroffset_x,
                                       self.tankr3.position.y-self.wheel_height-self.wheel_diff);
    
    self.tankBr2 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankBr2];
    self.tankBr2.position = CGPointMake(self.scaled_width*3-wheel_width-wheel_x_offset-self.anchoroffset_x,
                                       self.tankBr.position.y-self.wheel_height-self.wheel_diff);
    
    self.tankr4 = [SKSpriteNode spriteNodeWithColor:wheel_color size:CGSizeMake(wheel_width,self.wheel_height)];
    [self addChild:self.tankr4];
    self.tankr4.position = CGPointMake(self.scaled_width*3-wheel_width-wheel_x_offset-self.anchoroffset_x,
                                       self.tankBr2.position.y-self.wheel_height-self.wheel_diff);
}

//-(void) correctLeftWheels {
//    SKSpriteNode *first = self.tankl1;
//    if (self.tankl2.position.y >= first.position.y) {
//        first = self.tankl2;
//    }
//    if (self.tankl3.position.y >= first.position.y) {
//        first = self.tankl3;
//    }
//    if (self.tankl4.position.y >= first.position.y) {
//        first = self.tankl4;
//    }
//    
//    if (first == self.tankl1) {
//        self.tankl2.position = CGPointMake(first.position.x,
//                                           first.position.y-wheel_height-wheel_diff);
//        self.tankl3.position = CGPointMake(first.position.x,
//                                           self.tankl2.position.y-wheel_height-wheel_diff);
//        self.tankl4.position = CGPointMake(first.position.x,
//                                           self.tankl3.position.y-wheel_height-wheel_diff);
//    }
//    else if (first == self.tankl2) {
//        self.tankl3.position = CGPointMake(first.position.x,
//                                           first.position.y-wheel_height-wheel_diff);
//        self.tankl4.position = CGPointMake(first.position.x,
//                                           self.tankl3.position.y-wheel_height-wheel_diff);
//        self.tankl1.position = CGPointMake(first.position.x,
//                                           self.tankl4.position.y-wheel_height-wheel_diff);
//    }
//    else if (first == self.tankl3) {
//        self.tankl4.position = CGPointMake(first.position.x,
//                                           first.position.y-wheel_height-wheel_diff);
//        self.tankl1.position = CGPointMake(first.position.x,
//                                           self.tankl4.position.y-wheel_height-wheel_diff);
//        self.tankl2.position = CGPointMake(first.position.x,
//                                           self.tankl1.position.y-wheel_height-wheel_diff);
//    }
//    else if (first == self.tankl4) {
//        self.tankl1.position = CGPointMake(first.position.x,
//                                           first.position.y-wheel_height-wheel_diff);
//        self.tankl2.position = CGPointMake(first.position.x,
//                                           self.tankl1.position.y-wheel_height-wheel_diff);
//        self.tankl3.position = CGPointMake(first.position.x,
//                                           self.tankl2.position.y-wheel_height-wheel_diff);
//    }
//    
//}
//-(void) correctRightWheels {
//    SKSpriteNode *first = self.tankr1;
//    if (self.tankr2.position.y >= first.position.y) {
//        first = self.tankr2;
//    }
//    if (self.tankr3.position.y >= first.position.y) {
//        first = self.tankr3;
//    }
//    if (self.tankr4.position.y >= first.position.y) {
//        first = self.tankr4;
//    }
//    
//    if (first == self.tankr1) {
//        self.tankr2.position = CGPointMake(first.position.x,
//                                           first.position.y-wheel_height-wheel_diff);
//        self.tankr3.position = CGPointMake(first.position.x,
//                                           self.tankr2.position.y-wheel_height-wheel_diff);
//        self.tankr4.position = CGPointMake(first.position.x,
//                                           self.tankr3.position.y-wheel_height-wheel_diff);
//    }
//    else if (first == self.tankr2) {
//        self.tankr3.position = CGPointMake(first.position.x,
//                                           first.position.y-wheel_height-wheel_diff);
//        self.tankr4.position = CGPointMake(first.position.x,
//                                           self.tankr3.position.y-wheel_height-wheel_diff);
//        self.tankr1.position = CGPointMake(first.position.x,
//                                           self.tankr4.position.y-wheel_height-wheel_diff);
//    }
//    else if (first == self.tankr3) {
//        self.tankr4.position = CGPointMake(first.position.x,
//                                           first.position.y-wheel_height-wheel_diff);
//        self.tankr1.position = CGPointMake(first.position.x,
//                                           self.tankr4.position.y-wheel_height-wheel_diff);
//        self.tankr2.position = CGPointMake(first.position.x,
//                                           self.tankr1.position.y-wheel_height-wheel_diff);
//    }
//    else if (first == self.tankr4) {
//        self.tankr1.position = CGPointMake(first.position.x,
//                                           first.position.y-wheel_height-wheel_diff);
//        self.tankr2.position = CGPointMake(first.position.x,
//                                           self.tankr1.position.y-wheel_height-wheel_diff);
//        self.tankr3.position = CGPointMake(first.position.x,
//                                           self.tankr2.position.y-wheel_height-wheel_diff);
//    }
//    
//}

-(void)moveLeftWheelsForward {
    //    NSLog(@"forward tl1.y: %f, l2: %f, l3: %f, l4: %f",
    //          self.tankl1.position.y,self.tankl2.position.y,self.tankl3.position.y,self.tankl4.position.y);
    
//    [self correctLeftWheels];
    
    CGFloat speed = 1;
    CGFloat tank_body_height = self.scaled_height+self.wheel_height+self.wheel_diff;
    
    //    NSLog(@"forward wheel_origin_y: %f, bottom_y: %f, tank_body_height: %f",
    //          wheel_origin_y,wheel_bottom_y,tank_body_height);
    
    //left
    CGPoint f_base_location = CGPointMake(self.tankl1.position.x,front_wheel_bottom_y);
    CGPoint f_start_location = CGPointMake(self.tankl1.position.x,front_wheel_origin_y);
    CGPoint b_base_location = CGPointMake(self.tankl3.position.x,back_wheel_bottom_y);
    CGPoint b_start_location = CGPointMake(self.tankl3.position.x,back_wheel_origin_y);
    
    CGFloat duration_l1 = fabsf(front_wheel_bottom_y-self.tankl1.position.y)/tank_body_height*speed;
    CGFloat duration_fl1 = fabsf(front_wheel_bottom_y-self.tankFl.position.y)/tank_body_height*speed;
    CGFloat duration_fl2 = fabsf(front_wheel_bottom_y-self.tankFl2.position.y)/tank_body_height*speed;
    CGFloat duration_l2 = fabsf(front_wheel_bottom_y-self.tankl2.position.y)/tank_body_height*speed;
    
    CGFloat duration_l3 = fabsf(back_wheel_bottom_y-self.tankl3.position.y)/tank_body_height*speed;
    CGFloat duration_bl1 = fabsf(back_wheel_bottom_y-self.tankBl.position.y)/tank_body_height*speed;
    CGFloat duration_bl2 = fabsf(back_wheel_bottom_y-self.tankBl2.position.y)/tank_body_height*speed;
    CGFloat duration_l4 = fabsf(back_wheel_bottom_y-self.tankl4.position.y)/tank_body_height*speed;
    
    SKAction *rotationl1 = [SKAction moveTo:f_base_location duration:duration_l1];
    SKAction *rotationlfl1 = [SKAction moveTo:f_base_location duration:duration_fl1];
    SKAction *rotationlfl2 = [SKAction moveTo:f_base_location duration:duration_fl2];
    SKAction *rotationl2 = [SKAction moveTo:f_base_location duration:duration_l2];
    
    SKAction *rotationl3 = [SKAction moveTo:b_base_location duration:duration_l3];
    SKAction *rotationlbl1 = [SKAction moveTo:b_base_location duration:duration_bl1];
    SKAction *rotationlbl2 = [SKAction moveTo:b_base_location duration:duration_bl2];
    SKAction *rotationl4 = [SKAction moveTo:b_base_location duration:duration_l4];
    
    //    SKAction *correct = [SKAction runBlock:^(void) {
    //        [self correctLeftWheels];
    //    }];
    
    //move back to top
    SKAction *f_rotation2 = [SKAction moveTo:f_start_location duration:0];
    SKAction *f_rotation3 = [SKAction moveTo:f_base_location duration:speed];
    SKAction *b_rotation2 = [SKAction moveTo:b_start_location duration:0];
    SKAction *b_rotation3 = [SKAction moveTo:b_base_location duration:speed];
    
    [self.tankl1 runAction:rotationl1 completion:^(void) {
        [self.tankl1 runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    [self.tankFl runAction:rotationlfl1 completion:^(void) {
        [self.tankFl runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    [self.tankFl2 runAction:rotationlfl2 completion:^(void) {
        [self.tankFl2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    [self.tankl2 runAction:rotationl2 completion:^(void) {
        [self.tankl2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];

    
    [self.tankl3 runAction:rotationl3 completion:^(void) {
        [self.tankl3 runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
    [self.tankBl runAction:rotationlbl1 completion:^(void) {
        [self.tankBl runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
    [self.tankBl2 runAction:rotationlbl2 completion:^(void) {
        [self.tankBl2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
    [self.tankl4 runAction:rotationl4 completion:^(void) {
        [self.tankl4 runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
}

-(void)moveRightWheelsForward {
//    [self correctRightWheels];
    
    CGFloat speed = 1;
    CGFloat tank_body_height = self.scaled_height+self.wheel_height+self.wheel_diff;
    //right
    CGPoint f_location = CGPointMake(self.tankr1.position.x,front_wheel_bottom_y);
    CGPoint f_location2 = CGPointMake(self.tankr1.position.x,front_wheel_origin_y);
    CGPoint b_location = CGPointMake(self.tankr3.position.x,back_wheel_bottom_y);
    CGPoint b_location2 = CGPointMake(self.tankr3.position.x,back_wheel_origin_y);
    
    CGFloat duration_r1 = fabsf(front_wheel_bottom_y-self.tankr1.position.y)/tank_body_height*speed;
    CGFloat duration_fr1 = fabsf(front_wheel_bottom_y-self.tankFr.position.y)/tank_body_height*speed;
    CGFloat duration_fr2 = fabsf(front_wheel_bottom_y-self.tankFr2.position.y)/tank_body_height*speed;
    CGFloat duration_r2 = fabsf(front_wheel_bottom_y-self.tankr2.position.y)/tank_body_height*speed;
    
    CGFloat duration_r3 = fabsf(back_wheel_bottom_y-self.tankr3.position.y)/tank_body_height*speed;
    CGFloat duration_br1 = fabsf(back_wheel_bottom_y-self.tankBr.position.y)/tank_body_height*speed;
    CGFloat duration_br2 = fabsf(back_wheel_bottom_y-self.tankBr2.position.y)/tank_body_height*speed;
    CGFloat duration_r4 = fabsf(back_wheel_bottom_y-self.tankr4.position.y)/tank_body_height*speed;
    
    SKAction *rotationr1 = [SKAction moveTo:f_location duration:duration_r1];
    SKAction *rotationfr1 = [SKAction moveTo:f_location duration:duration_fr1];
    SKAction *rotationfr2 = [SKAction moveTo:f_location duration:duration_fr2];
    SKAction *rotationr2 = [SKAction moveTo:f_location duration:duration_r2];
    
    SKAction *rotationr3 = [SKAction moveTo:b_location duration:duration_r3];
    SKAction *rotationbr1 = [SKAction moveTo:b_location duration:duration_br1];
    SKAction *rotationbr2 = [SKAction moveTo:b_location duration:duration_br2];
    SKAction *rotationr4 = [SKAction moveTo:b_location duration:duration_r4];
    
    //    SKAction *correct = [SKAction runBlock:^(void) {
    //        [self correctRightWheels];
    //    }];
    
    //move back to top
    SKAction *f_rotation2 = [SKAction moveTo:f_location2 duration:0];
    SKAction *f_rotation3 = [SKAction moveTo:f_location duration:speed];
    SKAction *b_rotation2 = [SKAction moveTo:b_location2 duration:0];
    SKAction *b_rotation3 = [SKAction moveTo:b_location duration:speed];
    
    [self.tankr1 runAction:rotationr1 completion:^(void) {
        [self.tankr1 runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    [self.tankFr runAction:rotationfr1 completion:^(void) {
        [self.tankFr runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    [self.tankFr2 runAction:rotationfr2 completion:^(void) {
        [self.tankFr2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    [self.tankr2 runAction:rotationr2 completion:^(void) {
        [self.tankr2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    
    [self.tankr3 runAction:rotationr3 completion:^(void) {
        [self.tankr3 runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
    [self.tankBr runAction:rotationbr1 completion:^(void) {
        [self.tankBr runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
    [self.tankBr2 runAction:rotationbr2 completion:^(void) {
        [self.tankBr2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
    [self.tankr4 runAction:rotationr4 completion:^(void) {
        [self.tankr4 runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
}


-(void)moveLeftWheelsBackward {
    //    NSLog(@"backward: tl1.y: %f, l2: %f, l3: %f, l4: %f",
    //          self.tankl1.position.y,self.tankl2.position.y,self.tankl3.position.y,self.tankl4.position.y);
    
//    [self correctLeftWheels];
    
    CGFloat speed = 1;
    CGFloat tank_body_height = self.scaled_height+self.wheel_height+self.wheel_diff;
    
    //    NSLog(@"bw base_y: %f: tank_body_height: %f: wheel_origin_y: %f",base_y, tank_body_height, wheel_origin_y);
    
    //left
    CGPoint f_location = CGPointMake(self.tankl1.position.x,front_wheel_origin_y);
    CGPoint f_location2 = CGPointMake(self.tankl1.position.x,front_wheel_bottom_y);
    
    CGPoint b_location = CGPointMake(self.tankl3.position.x,back_wheel_origin_y);
    CGPoint b_location2 = CGPointMake(self.tankl3.position.x,back_wheel_bottom_y);
    
    CGFloat duration_l1 = (tank_body_height-fabsf(front_wheel_bottom_y-self.tankl1.position.y))/tank_body_height*speed;
    CGFloat duration_fl1 = (tank_body_height-fabsf(front_wheel_bottom_y-self.tankFl.position.y))/tank_body_height*speed;
    CGFloat duration_fl2 = (tank_body_height-fabsf(front_wheel_bottom_y-self.tankFl2.position.y))/tank_body_height*speed;
    CGFloat duration_l2 = (tank_body_height-fabsf(front_wheel_bottom_y-self.tankl2.position.y))/tank_body_height*speed;
    
    CGFloat duration_l3 = (tank_body_height-fabsf(back_wheel_bottom_y-self.tankl3.position.y))/tank_body_height*speed;
    CGFloat duration_bl1 = (tank_body_height-fabsf(back_wheel_bottom_y-self.tankBl.position.y))/tank_body_height*speed;
    CGFloat duration_bl2 = (tank_body_height-fabsf(back_wheel_bottom_y-self.tankBl2.position.y))/tank_body_height*speed;
    CGFloat duration_l4 = (tank_body_height-fabsf(back_wheel_bottom_y-self.tankl4.position.y))/tank_body_height*speed;
    
    SKAction *rotationl1 = [SKAction moveTo:f_location duration:duration_l1];
    SKAction *rotationfl1 = [SKAction moveTo:f_location duration:duration_fl1];
    SKAction *rotationfl2 = [SKAction moveTo:f_location duration:duration_fl2];
    SKAction *rotationl2 = [SKAction moveTo:f_location duration:duration_l2];
    
    SKAction *rotationl3 = [SKAction moveTo:b_location duration:duration_l3];
    SKAction *rotationbl1 = [SKAction moveTo:b_location duration:duration_bl1];
    SKAction *rotationbl2 = [SKAction moveTo:b_location duration:duration_bl2];
    SKAction *rotationl4 = [SKAction moveTo:b_location duration:duration_l4];
    
    //move back to top
    SKAction *f_rotation2 = [SKAction moveTo:f_location2 duration:0];
    SKAction *f_rotation3 = [SKAction moveTo:f_location duration:speed];
    SKAction *b_rotation2 = [SKAction moveTo:b_location2 duration:0];
    SKAction *b_rotation3 = [SKAction moveTo:b_location duration:speed];
    
    [self.tankl1 runAction:rotationl1 completion:^(void) {
        [self.tankl1 runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    [self.tankFl runAction:rotationfl1 completion:^(void) {
        [self.tankFl runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    [self.tankFl2 runAction:rotationfl2 completion:^(void) {
        [self.tankFl2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    [self.tankl2 runAction:rotationl2 completion:^(void) {
        [self.tankl2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    
    [self.tankl3 runAction:rotationl3 completion:^(void) {
        [self.tankl3 runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
    [self.tankBl runAction:rotationbl1 completion:^(void) {
        [self.tankBl runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
    [self.tankBl2 runAction:rotationbl2 completion:^(void) {
        [self.tankBl2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
    [self.tankl4 runAction:rotationl4 completion:^(void) {
        [self.tankl4 runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
}


-(void)moveRightWheelsBackward {
//    [self correctRightWheels];
    
    CGFloat speed = 1;
    CGFloat tank_body_height = self.scaled_height+self.wheel_height+self.wheel_diff;
    //right
    CGPoint f_location = CGPointMake(self.tankr1.position.x,front_wheel_origin_y);
    CGPoint f_location2 = CGPointMake(self.tankr1.position.x,front_wheel_bottom_y);
    CGPoint b_location = CGPointMake(self.tankr3.position.x,back_wheel_origin_y);
    CGPoint b_location2 = CGPointMake(self.tankr3.position.x,back_wheel_bottom_y);
    
    CGFloat duration_r1 = (tank_body_height-fabsf(front_wheel_bottom_y-self.tankr1.position.y))/tank_body_height*speed;
    CGFloat duration_fr1 = (tank_body_height-fabsf(front_wheel_bottom_y-self.tankFr.position.y))/tank_body_height*speed;
    CGFloat duration_fr2 = (tank_body_height-fabsf(front_wheel_bottom_y-self.tankFr2.position.y))/tank_body_height*speed;
    CGFloat duration_r2 = (tank_body_height-fabsf(front_wheel_bottom_y-self.tankr2.position.y))/tank_body_height*speed;
    
    CGFloat duration_r3 = (tank_body_height-fabsf(back_wheel_bottom_y-self.tankr3.position.y))/tank_body_height*speed;
    CGFloat duration_br1 = (tank_body_height-fabsf(back_wheel_bottom_y-self.tankBr.position.y))/tank_body_height*speed;
    CGFloat duration_br2 = (tank_body_height-fabsf(back_wheel_bottom_y-self.tankBr2.position.y))/tank_body_height*speed;
    CGFloat duration_r4 = (tank_body_height-fabsf(back_wheel_bottom_y-self.tankr4.position.y))/tank_body_height*speed;
    
    SKAction *rotationr1 = [SKAction moveTo:f_location duration:duration_r1];
    SKAction *rotationfr1 = [SKAction moveTo:f_location duration:duration_fr1];
    SKAction *rotationfr2 = [SKAction moveTo:f_location duration:duration_fr2];
    SKAction *rotationr2 = [SKAction moveTo:f_location duration:duration_r2];
    
    SKAction *rotationr3 = [SKAction moveTo:b_location duration:duration_r3];
    SKAction *rotationbr1 = [SKAction moveTo:b_location duration:duration_br1];
    SKAction *rotationbr2 = [SKAction moveTo:b_location duration:duration_br2];
    SKAction *rotationr4 = [SKAction moveTo:b_location duration:duration_r4];
    
    //move back to top
    SKAction *f_rotation2 = [SKAction moveTo:f_location2 duration:0];
    SKAction *f_rotation3 = [SKAction moveTo:f_location duration:speed];
    SKAction *b_rotation2 = [SKAction moveTo:b_location2 duration:0];
    SKAction *b_rotation3 = [SKAction moveTo:b_location duration:speed];
    
    [self.tankr1 runAction:rotationr1 completion:^(void) {
        [self.tankr1 runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    [self.tankFr runAction:rotationfr1 completion:^(void) {
        [self.tankFr runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    [self.tankFr2 runAction:rotationfr2 completion:^(void) {
        [self.tankFr2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    [self.tankr2 runAction:rotationr2 completion:^(void) {
        [self.tankr2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[f_rotation2,f_rotation3]]]];
    }];
    
    [self.tankr3 runAction:rotationr3 completion:^(void) {
        [self.tankr3 runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
    [self.tankBr runAction:rotationbr1 completion:^(void) {
        [self.tankBr runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
    [self.tankBr2 runAction:rotationbr2 completion:^(void) {
        [self.tankBr2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
    [self.tankr4 runAction:rotationr4 completion:^(void) {
        [self.tankr4 runAction:[SKAction repeatActionForever:[SKAction sequence:@[b_rotation2,b_rotation3]]]];
    }];
}

-(void)stop {
    [super stop];
    
    [tankFl removeAllActions];
    [tankFl2 removeAllActions];
    [tankFr removeAllActions];
    [tankFr2 removeAllActions];
    [tankBl removeAllActions];
    [tankBl2 removeAllActions];
    [tankBr removeAllActions];
    [tankBr2 removeAllActions];
}

@end
