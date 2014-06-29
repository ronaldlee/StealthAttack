//
//  STAMyScene.m
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAMyScene.h"

@interface STAMyScene () {
    UILongPressGestureRecognizer* longPressGestureRecognizer;
    
    float scale;
    float left_corner_x, right_corner_x, top_corner_y, bottom_corner_y;
    float player_bottom_border_y, player_top_border_y, player_left_border_x, player_right_border_x;
}

@property (nonatomic) STATank * player;
@end

@implementation STAMyScene

@synthesize fire_button;
@synthesize rotate_c_button;
@synthesize rotate_uc_button;
@synthesize forward_button;
@synthesize backward_button;

//-(void) didMoveToView:(SKView *)view {
//    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    
//    [view addGestureRecognizer:longPressGestureRecognizer];
//}
//
//-(void)willMoveFromView:(SKView*)view {
//    [view removeGestureRecognizer:longPressGestureRecognizer];
//}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        left_corner_x = BORDER_SIDE_MARGIN;
        top_corner_y = [[UIScreen mainScreen] bounds].size.height - TOP_HUD_HEIGHT;
        right_corner_x = [[UIScreen mainScreen] bounds].size.width - BORDER_SIDE_MARGIN;
        bottom_corner_y = BOTTOM_HUD_HEIGHT;
        
        scale = [UIScreen mainScreen].scale;
        
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self setupStageBorders];

        
        
        //===
        CGSize button_size = CGSizeMake(50,50);
        
        fire_button = [[STAButton alloc] initWithSize:button_size Name:@"fire_button"];
        fire_button.userInteractionEnabled = NO;
        fire_button.position = CGPointMake(left_corner_x, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self addChild:fire_button];
        
        button_size = CGSizeMake(50,50);
        rotate_c_button = [[STAButton alloc] initWithSize:button_size Name:@"rotate_c_button"];
        rotate_c_button.userInteractionEnabled = NO;
        rotate_c_button.position = CGPointMake(left_corner_x+100, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self addChild:rotate_c_button];
        
        button_size = CGSizeMake(50,50);
        rotate_uc_button = [[STAButton alloc] initWithSize:button_size Name:@"rotate_uc_button"];
        rotate_uc_button.userInteractionEnabled = NO;
        rotate_uc_button.position = CGPointMake(left_corner_x+150, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self addChild:rotate_uc_button];
        
        button_size = CGSizeMake(50,50);
        forward_button = [[STAButton alloc] initWithSize:button_size Name:@"forward_button"];
        forward_button.userInteractionEnabled = NO;
        forward_button.position = CGPointMake(left_corner_x+200, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self addChild:forward_button];
        
        //==
        self.player = [[STATank alloc] initWithScale:scale];
    
        player_bottom_border_y = bottom_corner_y + [self.player getAnchorOffsetY]+PIXEL_WIDTHHEIGHT+1;//+PIXEL_WIDTHHEIGHT+1;
        player_top_border_y = top_corner_y-PIXEL_WIDTHHEIGHT*2*scale-3;
        player_left_border_x = left_corner_x+3;
        player_right_border_x = right_corner_x-11;
        
        CGRect bounds = CGRectMake(player_left_border_x, player_bottom_border_y,
                                   player_right_border_x-player_left_border_x,
                                   player_top_border_y-player_bottom_border_y);
        
        
        CGFloat stage_start_x = ([[UIScreen mainScreen] bounds].size.width-PLAYER_WIDTH)/2 +
                                [self.player getAnchorOffsetX];
        CGFloat stage_start_y = player_bottom_border_y+20;
        
        self.player.position = CGPointMake(stage_start_x,stage_start_y);
        
        [self.player setBorderBounds:bounds];
        
        [self addChild:self.player];

        
    }
    return self;
}

-(void)setupStageBorders {
    
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    
    //top
    SKShapeNode* border_top = [SKShapeNode node];
    
    CGPathMoveToPoint(pathToDraw, NULL, left_corner_x, top_corner_y);
    CGPathAddLineToPoint(pathToDraw, NULL, right_corner_x, top_corner_y);
    
    border_top.path = pathToDraw;
    [border_top setStrokeColor:BORDER_COLOR];
    [border_top setLineWidth:1];
    [border_top setAntialiased:FALSE];
    [self addChild:border_top];
    
    //left
    SKShapeNode* border_left = [SKShapeNode node];
    
    CGPathMoveToPoint(pathToDraw, NULL, left_corner_x, bottom_corner_y);
    CGPathAddLineToPoint(pathToDraw, NULL, left_corner_x, top_corner_y);
    
    border_left.path = pathToDraw;
    [border_left setStrokeColor:BORDER_COLOR];
    [border_left setLineWidth:1];
    [border_left setAntialiased:FALSE];
    [self addChild:border_left];
    
    //bottom
    SKShapeNode* border_bottom = [SKShapeNode node];
    
    CGPathMoveToPoint(pathToDraw, NULL, left_corner_x, bottom_corner_y);
    CGPathAddLineToPoint(pathToDraw, NULL, right_corner_x, bottom_corner_y);
    
    border_bottom.path = pathToDraw;
    [border_bottom setStrokeColor:BORDER_COLOR];
    [border_bottom setLineWidth:1];
    [border_bottom setAntialiased:FALSE];
    [self addChild:border_bottom];
    
    //right
    SKShapeNode* border_right = [SKShapeNode node];
    
    CGPathMoveToPoint(pathToDraw, NULL, right_corner_x, bottom_corner_y);
    CGPathAddLineToPoint(pathToDraw, NULL, right_corner_x, top_corner_y);
    
    border_right.path = pathToDraw;
    [border_right setStrokeColor:BORDER_COLOR];
    [border_right setLineWidth:1];
    [border_right setAntialiased:FALSE];
    [self addChild:border_right];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
        if ([node.name isEqualToString:@"fire_button"]) {
            NSLog(@"fire!!");
            
            [self.player toggleFiring];
            
            if ([self.player isFiring]) {
                SKAction* shootBulletAction = [SKAction runBlock:^{
//                    BORDER cur_border = [self.player getCurrentBorder];
                    CGPoint location = [self.player position];
                    STABullet *bullet = [[STABullet alloc]initWithScale:1.0];
                    
                    bullet.position = CGPointMake(location.x,location.y+self.player.size.height/2);
                    //bullet.position = location;
                    bullet.zPosition = 1;
                    //                bullet.scale = 0.8;
                    
                    SKAction *action = Nil;
                    SKAction *remove = [SKAction removeFromParent];
                    float flight_distance = 2000;
                    CGFloat bullet_speed = 10;
                    
//                    if (cur_border == BORDER_TOP) {
//                        action = [SKAction moveToY:-(flight_distance-self.frame.size.height) duration:bullet_speed];
//                    }
//                    else if (cur_border == BORDER_BOTTOM) {
//                        action = [SKAction moveToY:flight_distance duration:bullet_speed];
//                    }
//                    else if (cur_border == BORDER_LEFT) {
//                        action = [SKAction moveToX:flight_distance duration:bullet_speed];
//                    }
//                    else if (cur_border == BORDER_RIGHT) {
//                        action = [SKAction moveToX:-(flight_distance-self.frame.size.width) duration:bullet_speed];
//                    }
                    
                    [bullet runAction:[SKAction sequence:@[action,remove]]];
                    
                    [self addChild:bullet];
                }];// queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
                
                SKAction *wait = [SKAction waitForDuration:0.4];
                SKAction *sequence = [SKAction sequence:@[shootBulletAction, wait]];
                [self runAction:[SKAction repeatActionForever:sequence]];
            }
            else {
                [self removeAllActions];
            }
            
            return;
        }
        else if ([node.name isEqualToString:@"rotate_c_button"]) {
            NSLog(@"rotate c!!");
            [self.player rotateClockwise];
        }
        else if ([node.name isEqualToString:@"rotate_uc_button"]) {
            NSLog(@"rotate uc!!");
            [self.player rotateCounterClockwise];
        }
        else if ([node.name isEqualToString:@"forward_button"]) {
            NSLog(@"forward!!");
            [self.player moveForward];
        }
        
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.player stop];
    
    NSLog(@"touch end: rotate: %f",self.player.zRotation);
   
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if ((contact.bodyA.categoryBitMask & PLAYER_CATEGORY)!=0) {
        
        STATank *player = (STATank*)contact.bodyA.node;
        
        if ((contact.bodyB.categoryBitMask & ENEMY_CATEGORY) != 0) {
            STAEnemyTank *enemy = (STAEnemyTank*)contact.bodyB.node;
            
            NSLog(@"contact!: player and monster");
            [player contactWith:enemy];
        }
    }
    else if ((contact.bodyA.categoryBitMask & ENEMY_CATEGORY) != 0) {
        STAEnemyTank* enemyBody = (STAEnemyTank*)contact.bodyA.node;
        
        if ((contact.bodyB.categoryBitMask & MISSLE_CATEGORY) != 0) {
            //STABullet* missileBody = (STABullet*)contact.bodyB.node;
            
            NSLog(@"missle hit monster");
            [enemyBody explode];
        }
    }
    else if ((contact.bodyA.categoryBitMask & MISSLE_CATEGORY) != 0) {
        //STABullet* missileBody = (STABullet*)contact.bodyA.node;
        
        if ((contact.bodyB.categoryBitMask & ENEMY_CATEGORY) != 0) {
            STAEnemyTank* enemyBody = (STAEnemyTank*)contact.bodyB.node;
            
            NSLog(@"missle hit monster");
            [enemyBody explode];
        }
    }
}

//- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer {
//    
//    CGPoint location = [recognizer locationInView:self.view];
//    
//    NSLog(@"logn pressss: count: %d, x: %f, y:%f",i++, location.x, location.y);
//    
//    //need to convert the location's Y to be upside down since spritenode y start from bottom
//    location = CGPointMake(location.x,[[UIScreen mainScreen] bounds].size.height - location.y);
//    SKNode *node = [self nodeAtPoint:location];
//    
//    NSLog(@"logn pressss rotate button: x: %f, y:%f", self.rotate_c_button.position.x,self.rotate_c_button.position.y);
//    
//    if ([node.name isEqualToString:@"rotate_c_button"]) {
//        NSLog(@"long press rotate c button");
//        [self.player rotateClockwise];
//    }
//}

@end
