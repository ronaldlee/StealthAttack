//
//  STAMainMenu.m
//  StealthAttack
//
//  Created by Ronald Lee on 7/12/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAMainMenu.h"
@interface STAMainMenu () {
    
}
@end

@implementation STAMainMenu


@synthesize scene;
@synthesize title1;
@synthesize title2;

@synthesize singlePlayer;

- (id)initWithScale:(float)scale Bounds:(CGRect)bounds Scene:(SKScene*)sk_scene {
    self = [super init];
    
    if (self) {
        scene = sk_scene;
        
        NSString * titleFont = @"GridExerciseGaps";
        //NSString * titleFont = @"Phaser Bank";
//        NSString * titleFont = @"TRON";
        
        
        //title1 = [SKLabelNode labelNodeWithFontNamed:@"Press Start 2P"];
        //title1 = [SKLabelNode labelNodeWithFontNamed:@"Librium"];
        title1 = [SKLabelNode labelNodeWithFontNamed:titleFont];
        
        NSString *title1Str = @"STEALTH";
        title1.text = title1Str;
        title1.fontSize = 28;
        title1.fontColor = [SKColor whiteColor];
        
        CGFloat title_x = ([[UIScreen mainScreen] bounds].size.width)/2;
        CGFloat title_y = [[UIScreen mainScreen] bounds].size.height - 100;
        
        title1.position = CGPointMake(title_x,title_y);
        
        [scene addChild:title1];
        
        //
        title2 = [SKLabelNode labelNodeWithFontNamed:titleFont];
        
        NSString *title2Str = @"ATTACK";
        title2.text = title2Str;
        title2.fontSize = 28;
        title2.fontColor = [SKColor whiteColor];
        
        title_y = title_y - 50;
        
        title2.position = CGPointMake(title_x,title_y);
        
        [scene addChild:title2];
        
        //
        NSString * playFont = @"Press Start 2P";
        
        singlePlayer = [SKLabelNode labelNodeWithFontNamed:playFont];
        
        NSString *singlePlay = @"single player";
        singlePlayer.text = singlePlay;
        singlePlayer.fontSize = 8;
        singlePlayer.fontColor = [SKColor whiteColor];
        singlePlayer.name = @"single_player";
        
        title_y = BOTTOM_HUD_HEIGHT + 200;
        
        singlePlayer.position = CGPointMake(title_x,title_y);
        
        [scene addChild:singlePlayer];
        
        SKAction * hideSinglePlayer = [SKAction runBlock:^(void) {
            singlePlayer.alpha = 0;
        }];
        SKAction * showSinglePlayer = [SKAction runBlock:^(void) {
            singlePlayer.alpha = 1;
        }];
        
        SKAction *wait = [SKAction waitForDuration:0.7];
        SKAction *wait_longer = [SKAction waitForDuration:5];
        [singlePlayer runAction:[SKAction sequence:@[wait_longer,[SKAction repeatActionForever:[SKAction sequence:@[wait,hideSinglePlayer,wait,showSinglePlayer]]]]]];

    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:scene];
        SKNode *node = [scene nodeAtPoint:location];
        
        if ([node.name isEqualToString:@"single_player"]) {
            NSLog(@"single player!!");
        }
    }

}

@end
