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
//@synthesize startLabel;
@synthesize backButton;
//@synthesize startButton;

@synthesize enemy1;
@synthesize enemy2;
@synthesize enemy3;
@synthesize enemy4;
@synthesize enemy5;
@synthesize enemy6;
@synthesize enemy7;

@synthesize enemy1Button;
@synthesize enemy2Button;
@synthesize enemy3Button;
@synthesize enemy4Button;

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
//        startLabel = [SKLabelNode labelNodeWithFontNamed:font];
//        
//        NSString *start = @">>";
//        startLabel.text = start;
//        startLabel.fontSize = 8;
//        startLabel.fontColor = [SKColor whiteColor];
//        startLabel.name = @"start_label";
//        startLabel.alpha = 0;
//        
//        title_x = [[UIScreen mainScreen] bounds].size.width-20;
//        
//        startLabel.position = CGPointMake(title_x,title_y);
//        
//        [self.scene addChild:startLabel];
//        [startLabel runAction:fadein];
//        
//        CGFloat start_button_orig_x =startLabel.position.x;
//        
//        SKAction * startLabelMoveRight = [SKAction moveToX:start_button_orig_x-5 duration:0.5];
//        SKAction * startLabelMoveLeft = [SKAction moveToX:start_button_orig_x duration:0.2];
//        
//        [startLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[startLabelMoveRight,startLabelMoveLeft]]]];
        
        //
        
//        startButton = [[STAButton alloc] initWithSize:button_size Name:@"start_button" Alpha:0 BGAlpha:0.0 ButtonText:NULL ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false];
//        startButton.userInteractionEnabled = NO;
//        startButton.position = CGPointMake(start_button_orig_x-15,startLabel.position.y-5);
//        [self.scene addChild:startButton];
        
        //enemies to choose from
        CGFloat left_corner_x = self.bounds.origin.x;
        CGFloat top_corner_y = self.bounds.origin.y+self.bounds.size.height;
        CGFloat right_corner_x = self.bounds.origin.x+self.bounds.size.width;
        CGFloat bottom_corner_y = self.bounds.origin.y;
        
        CGRect bounds = CGRectMake(left_corner_x, bottom_corner_y,
                                   right_corner_x-left_corner_x,
                                   top_corner_y-bottom_corner_y);
        
        
        //==enemies
        //4 enemies per row, 2 rows (total 8 enemies)
        //locked => question mark?
        enemy1 = [[STAEnemyTank alloc] initWithScale:self.scale Id:2
                                               BodyColor:TANK_BODY_BLUE
                                           BodyBaseColor:TANK_BODY_BASE_BLUE
                                                      AI:NULL
                                                Category:ENEMY_CATEGORY
                                                  Bounds:bounds];
        
        CGFloat stage_start_y = [[UIScreen mainScreen] bounds].size.height-150;
        
        
        [self.scene addChild:enemy1];
        [enemy1 dance:REGION_MIDDLE_BOTTOM];
        
        //
        enemy2 = [[STAJeep alloc] initWithScale:self.scale Id:2
                                           BodyColor:TANK_BODY_GREEN
                                       BodyBaseColor:TANK_BODY_BASE_GREEN
                                                  AI:NULL
                                            Category:ENEMY_CATEGORY
                                              Bounds:bounds];
        
        [self.scene addChild:enemy2];
        [enemy2 dance:REGION_MIDDLE_BOTTOM];
        
        //
        enemy3 = [[STAShotgunTank alloc] initWithScale:self.scale Id:2
                                      BodyColor:TANK_BODY_RED
                                  BodyBaseColor:TANK_BODY_BASE_RED
                                             AI:NULL
                                       Category:ENEMY_CATEGORY
                                         Bounds:bounds];
        
        [self.scene addChild:enemy3];
        [enemy3 dance:REGION_MIDDLE_BOTTOM];
        
        //
        enemy4 = [[STASniperTank alloc] initWithScale:self.scale Id:2
                                             BodyColor:TANK_BODY_YELLOW
                                         BodyBaseColor:TANK_BODY_BASE_YELLOW
                                                    AI:NULL
                                              Category:ENEMY_CATEGORY
                                                Bounds:bounds];
        
        [self.scene addChild:enemy4];
        [enemy4 dance:REGION_MIDDLE_BOTTOM];
        
        //
        CGFloat total_width = enemy1.max_width + enemy2.max_width + enemy3.max_width + enemy4.max_width + 50*3-10;
        
        CGFloat stage_start_x = ([[UIScreen mainScreen] bounds].size.width - total_width)/2;
        
        enemy1.position = CGPointMake(stage_start_x,stage_start_y);
        
        stage_start_x = enemy1.position.x + enemy1.max_width + 50;
        
        enemy2.position = CGPointMake(stage_start_x,stage_start_y);
        
        stage_start_x = enemy2.position.x + enemy2.max_width + 50;
        
        enemy3.position = CGPointMake(stage_start_x,stage_start_y);
        
        stage_start_x = enemy3.position.x + enemy3.max_width + 50;
        
        enemy4.position = CGPointMake(stage_start_x,stage_start_y);
        
        //=== enemy selection button
        
        button_size = CGSizeMake(40,40);
        enemy1Button = [[STAButton alloc] initWithSize:button_size Name:@"enemy1_button" Alpha:1.0 BGAlpha:0.0 ButtonText:NULL
                                     ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false];
        enemy1Button.userInteractionEnabled = NO;
        enemy1Button.position = CGPointMake(enemy1.position.x - (enemy1.max_width/2) - (button_size.width-enemy1.max_width)/2,
                                            enemy1.position.y - (enemy1.max_height/2) - (button_size.height-enemy1.max_height)/2);
        [self.scene addChild:enemy1Button];
        
        enemy2Button = [[STAButton alloc] initWithSize:button_size Name:@"enemy2_button" Alpha:1.0 BGAlpha:0.0 ButtonText:NULL
                                       ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false];
        enemy2Button.userInteractionEnabled = NO;
        enemy2Button.position = CGPointMake(enemy2.position.x - (enemy2.max_width/2) - (button_size.width-enemy2.max_width)/2,
                                            enemy2.position.y - (enemy2.max_height/2) - (button_size.height-enemy2.max_height)/2);
        [self.scene addChild:enemy2Button];
        
        enemy3Button = [[STAButton alloc] initWithSize:button_size Name:@"enemy3_button" Alpha:1.0 BGAlpha:0.0 ButtonText:NULL
                                       ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false];
        enemy3Button.userInteractionEnabled = NO;
        enemy3Button.position = CGPointMake(enemy3.position.x - (enemy3.max_width/2) - (button_size.width-enemy3.max_width)/2,
                                            enemy3.position.y - (enemy3.max_height/2) - (button_size.height-enemy3.max_height)/2);
        [self.scene addChild:enemy3Button];
        
        enemy4Button = [[STAButton alloc] initWithSize:button_size Name:@"enemy4_button" Alpha:1.0 BGAlpha:0.0 ButtonText:NULL
                                       ButtonTextColor:NULL ButtonTextFont:@"Press Start 2P" ButtonTextFontSize:10 isShowBorder:false];
        enemy4Button.userInteractionEnabled = NO;
        enemy4Button.position = CGPointMake(enemy4.position.x - (enemy4.max_width/2) - (button_size.width-enemy4.max_width)/2,
                                            enemy4.position.y - (enemy4.max_height/2) - (button_size.height-enemy4.max_height)/2);
        [self.scene addChild:enemy4Button];
        
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
//        else if ([node.name isEqualToString:@"start_button"]) {
//            NSLog(@"start_button");
//            
//            STAMyScene* myScene = (STAMyScene*)self.scene;
//            
//            [myScene.currStage cleanup];
//            
//            myScene.currStage = [[STABattleStage alloc ] initWithScale:self.scale Bounds:self.bounds Scene:self.scene];
//        }
        else if ([node.name isEqualToString:@"enemy1_button"]) {
            NSLog(@"enemy1_button");
            
            STAMyScene* myScene = (STAMyScene*)self.scene;
            
            [myScene.currStage cleanup];
            
            myScene.currStage = [[STABattleStage alloc ] initWithScale:self.scale Bounds:self.bounds Scene:self.scene EnemyId:1];
        }
        else if ([node.name isEqualToString:@"enemy2_button"]) {
            NSLog(@"enemy2_button");
            
            STAMyScene* myScene = (STAMyScene*)self.scene;
            
            [myScene.currStage cleanup];
            
            myScene.currStage = [[STABattleStage alloc ] initWithScale:self.scale Bounds:self.bounds Scene:self.scene EnemyId:2];
        }
        else if ([node.name isEqualToString:@"enemy3_button"]) {
            NSLog(@"enemy3_button");
            
            STAMyScene* myScene = (STAMyScene*)self.scene;
            
            [myScene.currStage cleanup];
            
            myScene.currStage = [[STABattleStage alloc ] initWithScale:self.scale Bounds:self.bounds Scene:self.scene EnemyId:3];
        }
        else if ([node.name isEqualToString:@"enemy4_button"]) {
            NSLog(@"enemy4_button");
            
            STAMyScene* myScene = (STAMyScene*)self.scene;
            
            [myScene.currStage cleanup];
            
            myScene.currStage = [[STABattleStage alloc ] initWithScale:self.scale Bounds:self.bounds Scene:self.scene EnemyId:4];
        }
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)cleanup {
    
    [selectOppTitle removeAllActions];
    [backLabel removeAllActions];
//    [startLabel removeAllActions];
    [backButton removeAllActions];
//    [startButton removeAllActions];
    [enemy1Button removeAllActions];
    [enemy1 stop];
    [enemy2Button removeAllActions];
    [enemy2 stop];
    [enemy3Button removeAllActions];
    [enemy3 stop];
    [enemy4Button removeAllActions];
    [enemy4 stop];
    
    
    NSArray* objs = [NSArray arrayWithObjects:selectOppTitle,backLabel,backButton,enemy1Button,enemy1,enemy2Button,enemy2,
                     enemy3Button,enemy3,enemy4Button,enemy4,nil];
    
    [self.scene removeChildrenInArray:objs];
    
}


@end
