//
//  STABullet.h
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface STABullet : SKSpriteNode<STAGameObject>

@property (nonatomic) SKSpriteNode * bullet;

- (id)initWithScale:(CGFloat)scale;


-(void)setBorderBounds:(CGRect)p_bounds;

@end
