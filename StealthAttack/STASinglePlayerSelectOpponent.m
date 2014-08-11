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
@synthesize backLabel;
@synthesize startLabel;
@synthesize backButton;
@synthesize startButton;

- (id)initWithScale:(float)sk_scale Bounds:(CGRect)bounds Scene:(SKScene*)sk_scene {
    self = [super initWithScale:sk_scale Bounds:bounds Scene:sk_scene];
    
    if (self) {
//        STAMyScene* myScene = (STAMyScene*)self.scene;
//        [myScene.currStage cleanup];
        
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
        backLabel = [SKLabelNode labelNodeWithFontNamed:font];
        
        NSString *back = @"<<";
        backLabel.text = back;
        backLabel.fontSize = 8;
        backLabel.fontColor = [SKColor whiteColor];
        backLabel.name = @"back_label";
        backLabel.alpha = 0;
        
        title_y = [[UIScreen mainScreen] bounds].size.height-50;
        
        backLabel.position = CGPointMake(20,title_y);
        
        [self.scene addChild:backLabel];
        [backLabel runAction:fadein];
        
        CGFloat back_button_orig_x =backLabel.position.x;
        
        SKAction * backLabelMoveRight = [SKAction moveToX:back_button_orig_x+5 duration:0.5];
        SKAction * backLabelMoveLeft = [SKAction moveToX:back_button_orig_x duration:0.2];
        
        [backLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[backLabelMoveRight,backLabelMoveLeft]]]];
        
        //
        CGSize button_size = CGSizeMake(30,20);
        
        backButton = [[STAButton alloc] initWithSize:button_size Name:@"back_button" Alpha:0 BGAlpha:0.0 ButtonText:NULL
                                     ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false];
        backButton.userInteractionEnabled = NO;
        backButton.position = CGPointMake(back_button_orig_x-10,backLabel.position.y-5);
        [self.scene addChild:backButton];
        
        //
        startLabel = [SKLabelNode labelNodeWithFontNamed:font];
        
        NSString *start = @">>";
        startLabel.text = start;
        startLabel.fontSize = 8;
        startLabel.fontColor = [SKColor whiteColor];
        startLabel.name = @"start_label";
        startLabel.alpha = 0;
        
        title_x = [[UIScreen mainScreen] bounds].size.width-20;
        
        startLabel.position = CGPointMake(title_x,title_y);
        
        [self.scene addChild:startLabel];
        [startLabel runAction:fadein];
        
        CGFloat start_button_orig_x =startLabel.position.x;
        
        SKAction * startLabelMoveRight = [SKAction moveToX:start_button_orig_x-5 duration:0.5];
        SKAction * startLabelMoveLeft = [SKAction moveToX:start_button_orig_x duration:0.2];
        
        [startLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[startLabelMoveRight,startLabelMoveLeft]]]];
        
        //
        
        startButton = [[STAButton alloc] initWithSize:button_size Name:@"start_button" Alpha:0 BGAlpha:0.0 ButtonText:NULL ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false];
        startButton.userInteractionEnabled = NO;
        startButton.position = CGPointMake(start_button_orig_x-15,startLabel.position.y-5);
        [self.scene addChild:startButton];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch single play");
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
                                 initWithScale:self.scale Bounds:self.bounds Scene:self.scene];
        }
        else if ([node.name isEqualToString:@"start_button"]) {
            NSLog(@"start_button");
            
            STAMyScene* myScene = (STAMyScene*)self.scene;
            
            [myScene.currStage cleanup];
            
            myScene.currStage = [[STABattleStage alloc ] initWithScale:self.scale Bounds:self.bounds Scene:self.scene];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)cleanup {
    
    [selectOppTitle removeAllActions];
    [backLabel removeAllActions];
    [startLabel removeAllActions];
    [backButton removeAllActions];
    [startButton removeAllActions];
    
    
    NSArray* objs = [NSArray arrayWithObjects:selectOppTitle,backLabel,startLabel,backButton,startButton,nil];
    
    [self.scene removeChildrenInArray:objs];
    
}


@end
