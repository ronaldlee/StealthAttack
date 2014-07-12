//
//  STASinglePlayerSelectOpponent.m
//  StealthAttack
//
//  Created by Ronald Lee on 7/12/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STASinglePlayerSelectOpponent.h"

@implementation STASinglePlayerSelectOpponent

@synthesize selectOppTitle;

- (id)initWithScale:(float)sk_scale Bounds:(CGRect)bounds Scene:(SKScene*)sk_scene {
    self = [super initWithScale:sk_scale Bounds:bounds Scene:sk_scene];
    
    if (self) {
        
        CGFloat title_x = ([[UIScreen mainScreen] bounds].size.width)/2;
        
        NSString * font = @"Press Start 2P";
        
        selectOppTitle = [SKLabelNode labelNodeWithFontNamed:font];
        
        NSString *singlePlay = @"Select Your Opponent";
        selectOppTitle.text = singlePlay;
        selectOppTitle.fontSize = 8;
        selectOppTitle.fontColor = [SKColor whiteColor];
        
        CGFloat title_y = [[UIScreen mainScreen] bounds].size.height - 100;
        
        selectOppTitle.position = CGPointMake(title_x,title_y);
        
        [self.scene addChild:selectOppTitle];
        
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self.scene];
        SKNode *node = [self.scene nodeAtPoint:location];
        
        if ([node.name isEqualToString:@"enemy_tank1"]) {
            NSLog(@"enemy_tank1");
        }
        else if ([node.name isEqualToString:@"enemy_tank2"]) {
            NSLog(@"enemy_tank2");
        }
        else if ([node.name isEqualToString:@"enemy_tank3"]) {
            NSLog(@"enemy_tank3");
        }
    }
}

-(void)cleanup {
}


@end
