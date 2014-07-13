//
//  STAButton.h
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface STAButton : SKSpriteNode


@property (nonatomic) SKSpriteNode * button;

- (id)initWithSize:(CGSize)size Name:(NSString*)name Alpha:(CGFloat)alpha;

@end
