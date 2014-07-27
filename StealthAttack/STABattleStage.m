//
//  STABattleStage.m
//  StealthAttack
//
//  Created by Ronald Lee on 7/12/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STABattleStage.h"
@interface STABattleStage () {

    UIColor* tankBodyGreen;
    UIColor* tankBodyBaseGreen;
    UIColor* tankBodyRed;
    UIColor* tankBodyBaseRed;
    UIColor* tankBodyYellow;
    UIColor* tankBodyBaseYellow;
    UIColor* tankBodyBlue;
    UIColor* tankBodyBaseBlue;
}
@end

@implementation STABattleStage

@synthesize player;
@synthesize enemy;
@synthesize fire_button;
@synthesize rotate_c_button;
@synthesize rotate_uc_button;
@synthesize forward_button;
@synthesize backward_button;


- (id)initWithScale:(float)sk_scale Bounds:(CGRect)bounds Scene:(SKScene*)sk_scene {
    self = [super initWithScale:sk_scale Bounds:bounds Scene:sk_scene];
    
    if (self) {
//        STAMyScene* myScene = (STAMyScene*)self.scene;
//        [myScene.currStage cleanup];
        tankBodyGreen = [UIColor greenColor];
        tankBodyBaseGreen = [UIColor colorWithRed:(70.0f/255.0f) green:(130.0f/255.0f) blue:(17.0f/255.0f) alpha:1.0];
        
        tankBodyRed = [UIColor redColor];
        tankBodyBaseRed = [UIColor colorWithRed:(157.0f/255.0f) green:(28.0f/255.0f) blue:(28.0f/255.0f) alpha:1.0];
        
        tankBodyYellow = [UIColor yellowColor];
        tankBodyBaseYellow = [UIColor colorWithRed:(186.0f/255.0f) green:(184.0f/255.0f) blue:(4.0f/255.0f) alpha:1.0];
        
        tankBodyBlue = [UIColor blueColor];
        tankBodyBaseBlue = [UIColor colorWithRed:(4.0f/255.0f) green:(45.0f/255.0f) blue:(144.0f/255.0f) alpha:1.0];
        //==
        
        CGSize button_size = CGSizeMake(50,50);
        
        CGFloat left_corner_x = self.bounds.origin.x;
        CGFloat top_corner_y = self.bounds.origin.y+self.bounds.size.height;
        CGFloat right_corner_x = self.bounds.origin.x+self.bounds.size.width;
        CGFloat bottom_corner_y = self.bounds.origin.y;
        
        fire_button = [[STAButton alloc] initWithSize:button_size Name:@"fire_button" Alpha:1];
        fire_button.userInteractionEnabled = NO;
        fire_button.position = CGPointMake(left_corner_x, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self.scene addChild:fire_button];

        button_size = CGSizeMake(50,50);
        rotate_uc_button = [[STAButton alloc] initWithSize:button_size Name:@"rotate_uc_button" Alpha:1];
        rotate_uc_button.userInteractionEnabled = NO;
        rotate_uc_button.position = CGPointMake(left_corner_x+100, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self.scene addChild:rotate_uc_button];
        
        button_size = CGSizeMake(50,50);
        rotate_c_button = [[STAButton alloc] initWithSize:button_size Name:@"rotate_c_button" Alpha:1];
        rotate_c_button.userInteractionEnabled = NO;
        rotate_c_button.position = CGPointMake(left_corner_x+150, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self.scene addChild:rotate_c_button];
        
        button_size = CGSizeMake(50,50);
        forward_button = [[STAButton alloc] initWithSize:button_size Name:@"forward_button" Alpha:1];
        forward_button.userInteractionEnabled = NO;
        forward_button.position = CGPointMake(left_corner_x+200, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self.scene addChild:forward_button];
        
        button_size = CGSizeMake(50,50);
        backward_button = [[STAButton alloc] initWithSize:button_size Name:@"backward_button" Alpha:1];
        backward_button.userInteractionEnabled = NO;
        backward_button.position = CGPointMake(left_corner_x+250, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self.scene addChild:backward_button];

//        //==
        self.player = [[STATank alloc] initWithScale:self.scale Id:1
                                           BodyColor:tankBodyYellow
                                       BodyBaseColor:tankBodyBaseYellow
                                                  AI:NULL
                                       RotationSpeed:3];

        CGFloat player_bottom_border_y = bottom_corner_y + [self.player getAnchorOffsetY]+PIXEL_WIDTHHEIGHT+1;//+PIXEL_WIDTHHEIGHT+1;
        CGFloat player_top_border_y = top_corner_y-PIXEL_WIDTHHEIGHT*2*self.scale-3;
        CGFloat player_left_border_x = left_corner_x+3;
        CGFloat player_right_border_x = right_corner_x-11;
        
        CGRect bounds = CGRectMake(player_left_border_x, player_bottom_border_y,
                                   player_right_border_x-player_left_border_x,
                                   player_top_border_y-player_bottom_border_y);

        
//        CGFloat stage_start_x = ([[UIScreen mainScreen] bounds].size.width-PLAYER_WIDTH)/2 + [self.player getAnchorOffsetX];
//        CGFloat stage_start_y = player_bottom_border_y+20;
        CGFloat stage_start_x = player_right_border_x - 20;
        CGFloat stage_start_y = player_bottom_border_y+20;
        
        self.player.position = CGPointMake(stage_start_x,stage_start_y);
//        [self.player updateLastPositionData];
        
        [self.player setBorderBounds:bounds];
        
        [self.scene addChild:self.player];
        
        //==enemy
        self.enemy = [[STAEnemyTank alloc] initWithScale:self.scale Id:2
                                               BodyColor:tankBodyBlue
                                           BodyBaseColor:tankBodyBaseBlue
                                                      AI:[[STAAI alloc] initWithStage:self]
                                           RotationSpeed:3];
        [self.enemy setBattleStage:self];
        
//        stage_start_x = ([[UIScreen mainScreen] bounds].size.width-PLAYER_WIDTH)/2 + [self.player getAnchorOffsetX];
        stage_start_x = player_left_border_x + 20;
        stage_start_y = player_top_border_y-20;
        
        self.enemy.position = CGPointMake(stage_start_x,stage_start_y);
        
        [self.enemy setBorderBounds:bounds];
        
        [self.scene addChild:self.enemy];
    }
    
    return self;
}

-(void) fireBullet:(STATank*)tank {
    NSLog(@"fire bullet");
    [tank updateLastPositionData];
    SKAction* shootBulletAction = [SKAction runBlock:^{
        CGPoint location = [tank position];
        STABullet *bullet = [[STABullet alloc]initWithScale:1.0];
        
        //need to position at the tip of the tank's turret..
        
        //bullet.position = location;
        bullet.zPosition = 1;
        
        //bullet.scale = 0.8;
        
        CGFloat velocity_x = cos([tank getAdjRotation])*100;
        CGFloat velocity_y = sin([tank getAdjRotation])*100;
        
        CGFloat radius = PLAYER_WIDTH;
        CGFloat x = cos([tank getAdjRotation])*radius + tank.position.x;
        CGFloat y = sin([tank getAdjRotation])*radius + tank.position.y;
        
        bullet.position = CGPointMake(x,y);
        
        bullet.zRotation = [tank getAdjRotation];
        
        bullet.physicsBody.velocity = CGVectorMake(velocity_x, velocity_y);
        
        bullet.ownerId = tank.playerId;
        
        [self.scene addChild:bullet];
        tank.fireCount++;
        
    }];// queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    [self.scene runAction:shootBulletAction];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch battle stage");
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self.scene];
        SKNode *node = [self.scene nodeAtPoint:location];
        
        if ([node.name isEqualToString:@"fire_button"]) {
            NSLog(@"fire!!");
            
            [self fireBullet:self.player];
//            
//            [self.player toggleFiring];
//            
//            if ([self.player isFiring]) {
//                [self.player updateLastPositionData];
//                SKAction* shootBulletAction = [SKAction runBlock:^{
//                    //                    BORDER cur_border = [self.player getCurrentBorder];
//                    CGPoint location = [self.player position];
//                    STABullet *bullet = [[STABullet alloc]initWithScale:1.0];
//                    
//                    //need to position at the tip of the tank's turret..
//                    
//                    //bullet.position = location;
//                    bullet.zPosition = 1;
//                    
//                    //bullet.scale = 0.8;
//                    
//                    CGFloat velocity_x = cos([self.player getAdjRotation])*100;
//                    CGFloat velocity_y = sin([self.player getAdjRotation])*100;
//                    
//                    CGFloat radius = PLAYER_WIDTH;
//                    CGFloat x = cos([self.player getAdjRotation])*radius +
//                    self.player.position.x;
//                    CGFloat y = sin([self.player getAdjRotation])*radius +
//                    self.player.position.y;
//                    
//                    //                    bullet.position = CGPointMake(location.x,location.y+self.player.size.height/2);
//                    bullet.position = CGPointMake(x,y);
//                    
//                    //                    NSLog(@"x: %f, y: %f", x,y);
//                    
//                    bullet.zRotation = [self.player getAdjRotation];
//                    
//                    bullet.physicsBody.velocity = CGVectorMake(velocity_x, velocity_y);
//                    
//                    bullet.ownerId = self.player.playerId;
//                    
//                    [self.scene addChild:bullet];
//                }];// queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
//                
//                SKAction *wait = [SKAction waitForDuration:0.4];
//                SKAction *sequence = [SKAction sequence:@[shootBulletAction, wait]];
//                [self.scene runAction:[SKAction repeatActionForever:sequence]];
//            }
//            else {
//                [self.scene removeAllActions];
//            }
            
            return;
        }
        else if ([node.name isEqualToString:@"rotate_c_button"]) {
            [self.player rotateClockwise];
        }
        else if ([node.name isEqualToString:@"rotate_uc_button"]) {
            [self.player rotateCounterClockwise];
        }
        else if ([node.name isEqualToString:@"forward_button"]) {
            [self.player moveForward];
        }
        else if ([node.name isEqualToString:@"backward_button"]) {
            [self.player moveBackward];
        }
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.player stop];
}

-(void)cleanup {
    [player removeAllActions];
    [enemy removeAllActions];
    
    [fire_button removeAllActions];
    [rotate_c_button removeAllActions];
    [rotate_uc_button removeAllActions];
    [forward_button removeAllActions];
    [backward_button removeAllActions];
    
    NSArray* objs = [NSArray arrayWithObjects:player,enemy,fire_button,rotate_c_button,rotate_uc_button,forward_button,backward_button,nil];
    
    [self.scene removeChildrenInArray:objs];
}

@end
