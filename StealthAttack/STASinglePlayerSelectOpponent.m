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
@synthesize backButton;

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
        selectOppTitle.alpha = 0;
        
        [self.scene addChild:selectOppTitle];
        
        SKAction * fadein = [SKAction fadeInWithDuration:0.5];
        [selectOppTitle runAction:fadein];
        
        //
        backButton = [SKLabelNode labelNodeWithFontNamed:font];
        
        NSString *back = @"<<";
        backButton.text = back;
        backButton.fontSize = 8;
        backButton.fontColor = [SKColor whiteColor];
        backButton.name = @"back_button";
        backButton.alpha = 0;
        
        title_y = [[UIScreen mainScreen] bounds].size.height-50;
        
        backButton.position = CGPointMake(20,title_y);
        
        [self.scene addChild:backButton];
        [backButton runAction:fadein];
        
        CGFloat back_button_orig_x =backButton.position.x;
        
        SKAction * backButtonMoveRight = [SKAction moveToX:back_button_orig_x+5 duration:0.5];
        SKAction * backButtonMoveLeft = [SKAction moveToX:back_button_orig_x duration:0.2];
        
        [backButton runAction:[SKAction repeatActionForever:[SKAction sequence:@[backButtonMoveRight,backButtonMoveLeft]]]];
        
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
        else if ([node.name isEqualToString:@"back_button"]) {
            NSLog(@"back_button");
            
            STAMyScene* myScene = (STAMyScene*)self.scene;
            
            [myScene.currStage cleanup];
            
            myScene.currStage = [[STAMainMenu alloc ]
                                 initWithScale:self.scale Bounds:CGRectMake(0,0,0,0) Scene:self.scene];
        }
    }
}

-(void)cleanup {
    
    [selectOppTitle removeAllActions];
    [selectOppTitle removeFromParent];
    
    [backButton removeAllActions];
    [backButton removeFromParent];
    
}


@end
