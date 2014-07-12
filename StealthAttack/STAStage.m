//
//  STAStage.m
//  StealthAttack
//
//  Created by Ronald Lee on 7/6/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAStage.h"

@implementation STAStage

@synthesize scene;
@synthesize scale;
@synthesize bounds;

- (id)initWithScale:(float)sk_scale Bounds:(CGRect)sk_bounds Scene:(SKScene*)sk_scene {
    self = [super init];
    
    if (self) {
        scale = sk_scale;
        scene = sk_scene;
        bounds = sk_bounds;
        
    }
    
    return self;
}

@end
