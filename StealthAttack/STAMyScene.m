//
//  STAMyScene.m
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAMyScene.h"

@interface STAMyScene () {
    float scale;
    float left_corner_x, right_corner_x, top_corner_y, bottom_corner_y;
    float player_bottom_border_y, player_top_border_y, player_left_border_x, player_right_border_x;
}

@property (nonatomic) STATank * player;
@end

@implementation STAMyScene

@synthesize fire_button;

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
        
        player_bottom_border_y = bottom_corner_y+PIXEL_WIDTHHEIGHT+1;
        player_top_border_y = top_corner_y-PIXEL_WIDTHHEIGHT*2*scale-3;
        player_left_border_x = left_corner_x+3;
        player_right_border_x = right_corner_x-11;
        
        CGRect bounds = CGRectMake(player_left_border_x, player_bottom_border_y,
                                   player_right_border_x-player_left_border_x,
                                   player_top_border_y-player_bottom_border_y);
        
        
        //===
        CGSize button_size = CGSizeMake(50,50);
        
        fire_button = [[STAButton alloc] initWithSize:button_size Name:@"fire_button"];
        fire_button.userInteractionEnabled = NO;
        fire_button.position = CGPointMake(left_corner_x, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self addChild:fire_button];
        
        //==
        self.player = [[STATank alloc] initWithScale:scale];
        self.player.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width-PLAYER_WIDTH)/2,
                                           player_bottom_border_y);
        
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
        
    }
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


@end
