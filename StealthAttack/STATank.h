//
//  STATank.h
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface STATank : SKNode<STAGameObject>

@property int playerId;

@property (nonatomic) CGFloat scaled_width;
@property (nonatomic) CGFloat scaled_height;

@property (nonatomic) CGFloat anchoroffset_x;
@property (nonatomic) CGFloat anchoroffset_y;

@property (nonatomic) CGFloat wheel_origin_y;
@property (nonatomic) CGFloat wheel_bottom_y;

@property (nonatomic) CGFloat wheel_height;
@property (nonatomic) CGFloat wheel_diff;

@property (nonatomic) SKSpriteNode * tankA;
@property (nonatomic) SKSpriteNode * tankB;
@property (nonatomic) SKSpriteNode * tankC;
@property (nonatomic) SKSpriteNode * tankD;
@property (nonatomic) SKSpriteNode * tankE;
@property (nonatomic) SKSpriteNode * tankF;
@property (nonatomic) SKSpriteNode * tankG;

@property (nonatomic) SKSpriteNode * tankl1;
@property (nonatomic) SKSpriteNode * tankl2;
@property (nonatomic) SKSpriteNode * tankl3;
@property (nonatomic) SKSpriteNode * tankl4;

@property (nonatomic) SKSpriteNode * tankr1;
@property (nonatomic) SKSpriteNode * tankr2;
@property (nonatomic) SKSpriteNode * tankr3;
@property (nonatomic) SKSpriteNode * tankr4;

@property (nonatomic) UIColor *tankBodyColor;
@property (nonatomic) UIColor *tankBodyBaseColor;

-(void)setBorderBounds:(CGRect)p_bounds;
-(id)initWithScale:(CGFloat)scale Id:(int)t_id BodyColor:(UIColor*)b_color BodyBaseColor:(UIColor*)bb_color;

-(void)moveForward;
-(void)moveBackward;
-(void)rotateClockwise;
-(void)rotateCounterClockwise;
-(void)stop;

-(void)toggleFiring;
-(BOOL)isFiring;
-(void)toggleVisibilty;

-(CGFloat)getAnchorOffsetX;
-(CGFloat)getAnchorOffsetY;

-(void)stopMovement;

-(CGFloat)getAdjRotation;

-(int)getWidthInPixels;
-(int)getHeightInPixels;

-(void)buildTankBody;
-(void)buildTankWheels;

-(void)stopVelocity;

-(void)restoreVelocity;

@end
