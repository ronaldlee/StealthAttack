//
//  STATank.h
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface STATank : SKSpriteNode<STAGameObject>

@property (nonatomic) SKSpriteNode * tankA;
@property (nonatomic) SKSpriteNode * tankB;
@property (nonatomic) SKSpriteNode * tankC;
@property (nonatomic) SKSpriteNode * tankD;
@property (nonatomic) SKSpriteNode * tankE;
@property (nonatomic) SKSpriteNode * tankF;
@property (nonatomic) SKSpriteNode * tankG;

-(void)setBorderBounds:(CGRect)p_bounds;
-(id)initWithScale:(CGFloat)scale;

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

@end
