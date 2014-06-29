//
//  STAMyScene.h
//  StealthAttack
//

//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface STAMyScene : SKScene<SKPhysicsContactDelegate>

@property (nonatomic) STAButton * fire_button;

@property (nonatomic) STAButton * rotate_c_button;
@property (nonatomic) STAButton * rotate_uc_button;
@property (nonatomic) STAButton * forward_button;
@property (nonatomic) STAButton * backward_button;

@end
