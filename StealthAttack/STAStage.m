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

- (id)initWithScale:(float)scale Bounds:(CGRect)bounds Scene:(SKScene*)sk_scene {
    self = [super init];
    
    if (self) {
        scene = sk_scene;
        
    }
    
    return self;
}

@end
