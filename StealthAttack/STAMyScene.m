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
    
    BOOL isGameOver;
}

//@property (nonatomic) STATank * player;
//@property (nonatomic) STATank * enemy;

@end

@implementation STAMyScene

//@synthesize fire_button;
//@synthesize rotate_c_button;
//@synthesize rotate_uc_button;
//@synthesize forward_button;
//@synthesize backward_button;

@synthesize currStage;

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
        isGameOver = false;
        
        [self createSceneContents];
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        left_corner_x = BORDER_SIDE_MARGIN;
        top_corner_y = [[UIScreen mainScreen] bounds].size.height - TOP_HUD_HEIGHT;
        right_corner_x = [[UIScreen mainScreen] bounds].size.width - BORDER_SIDE_MARGIN;
        bottom_corner_y = BOTTOM_HUD_HEIGHT;
        
        scale = [UIScreen mainScreen].scale;
        
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self setupStageBorders];

        
        /*
        //===
        CGSize button_size = CGSizeMake(50,50);
        
        fire_button = [[STAButton alloc] initWithSize:button_size Name:@"fire_button"];
        fire_button.userInteractionEnabled = NO;
        fire_button.position = CGPointMake(left_corner_x, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self addChild:fire_button];
        
        button_size = CGSizeMake(50,50);
        rotate_uc_button = [[STAButton alloc] initWithSize:button_size Name:@"rotate_uc_button"];
        rotate_uc_button.userInteractionEnabled = NO;
        rotate_uc_button.position = CGPointMake(left_corner_x+100, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self addChild:rotate_uc_button];
        
        button_size = CGSizeMake(50,50);
        rotate_c_button = [[STAButton alloc] initWithSize:button_size Name:@"rotate_c_button"];
        rotate_c_button.userInteractionEnabled = NO;
        rotate_c_button.position = CGPointMake(left_corner_x+150, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self addChild:rotate_c_button];
        
        button_size = CGSizeMake(50,50);
        forward_button = [[STAButton alloc] initWithSize:button_size Name:@"forward_button"];
        forward_button.userInteractionEnabled = NO;
        forward_button.position = CGPointMake(left_corner_x+200, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self addChild:forward_button];
        
        button_size = CGSizeMake(50,50);
        backward_button = [[STAButton alloc] initWithSize:button_size Name:@"backward_button"];
        backward_button.userInteractionEnabled = NO;
        backward_button.position = CGPointMake(left_corner_x+250, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self addChild:backward_button];
        
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
        
        //==enemy
        self.enemy = [[STAEnemyTank alloc] initWithScale:scale];
        
        stage_start_x = ([[UIScreen mainScreen] bounds].size.width-PLAYER_WIDTH)/2 +
        [self.player getAnchorOffsetX];
        stage_start_y = player_bottom_border_y+20+200;
        
        self.enemy.position = CGPointMake(stage_start_x,stage_start_y);
        
        [self.enemy setBorderBounds:bounds];
        
        [self addChild:self.enemy];
         */
        
        currStage = [[STAMainMenu alloc ]initWithScale:scale
                                                Bounds:CGRectMake(left_corner_x,bottom_corner_y,
                                                                  right_corner_x-left_corner_x,
                                                                  top_corner_y-bottom_corner_y)
                                                Scene:self];
        
//        for(NSString *fontfamilyname in [UIFont familyNames])
//        {
//            NSLog(@"Family:'%@'",fontfamilyname);
//            for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//            {
//                NSLog(@"\tfont:'%@'",fontName);
//            }
//            NSLog(@"~~~~~~~~");
//        }
        
    }
    return self;
}

-(void)setupStageBorders {
    
    CGFloat border_width = right_corner_x-left_corner_x;
    CGFloat border_height = top_corner_y-bottom_corner_y;
    
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    
    //top
//    SKShapeNode* border_top = [SKShapeNode node];
//    
//    CGPathMoveToPoint(pathToDraw, NULL, left_corner_x, top_corner_y);
//    CGPathAddLineToPoint(pathToDraw, NULL, right_corner_x, top_corner_y);
//    
//    border_top.path = pathToDraw;
//    [border_top setStrokeColor:BORDER_COLOR];
//    [border_top setLineWidth:1];
//    [border_top setAntialiased:FALSE];
    
    SKSpriteNode* border_top = [SKSpriteNode spriteNodeWithColor:BORDER_COLOR
                                                               size:CGSizeMake(border_width,1)];
    border_top.position = CGPointMake(left_corner_x, top_corner_y);
    border_top.anchorPoint = CGPointMake(0,0);
    
    border_top.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(border_width*scale, 1)];
    border_top.physicsBody.affectedByGravity = NO;
    border_top.physicsBody.categoryBitMask = WALL_CATEGORY;
    border_top.physicsBody.contactTestBitMask = PLAYER_CATEGORY;
    border_top.physicsBody.collisionBitMask = PLAYER_CATEGORY;
    border_top.physicsBody.resting = TRUE;
    border_top.physicsBody.dynamic = FALSE;
    border_top.physicsBody.restitution = 0;
    
    [self addChild:border_top];
    
    //left
//    SKShapeNode* border_left = [SKShapeNode node];
//    
//    CGPathMoveToPoint(pathToDraw, NULL, left_corner_x, bottom_corner_y);
//    CGPathAddLineToPoint(pathToDraw, NULL, left_corner_x, top_corner_y);
//    
//    border_left.path = pathToDraw;
//    [border_left setStrokeColor:BORDER_COLOR];
//    [border_left setLineWidth:1];
//    [border_left setAntialiased:FALSE];
    
    
    SKSpriteNode* border_left = [SKSpriteNode spriteNodeWithColor:BORDER_COLOR
                                                               size:CGSizeMake(1,border_height)];
    border_left.position = CGPointMake(left_corner_x, bottom_corner_y);
    border_left.anchorPoint = CGPointMake(0,0);
    
    border_left.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, border_height*scale)];
    border_left.physicsBody.affectedByGravity = NO;
    border_left.physicsBody.categoryBitMask = WALL_CATEGORY;
    border_left.physicsBody.contactTestBitMask = PLAYER_CATEGORY;
    border_left.physicsBody.collisionBitMask = PLAYER_CATEGORY;
    border_left.physicsBody.resting = TRUE;
    border_left.physicsBody.dynamic = FALSE;
    border_left.physicsBody.restitution = 0;
    
    [self addChild:border_left];
    
    //bottom
//    SKShapeNode* border_bottom = [SKShapeNode node];
//    CGPathMoveToPoint(pathToDraw, NULL, left_corner_x, bottom_corner_y);
//    CGPathAddLineToPoint(pathToDraw, NULL, right_corner_x, bottom_corner_y);
//    
//    border_bottom.path = pathToDraw;
//    [border_bottom setStrokeColor:BORDER_COLOR];
//    [border_bottom setLineWidth:1];
//    [border_bottom setAntialiased:FALSE];
    
    SKSpriteNode* border_bottom = [SKSpriteNode spriteNodeWithColor:BORDER_COLOR
                                                               size:CGSizeMake(border_width,1)];
    border_bottom.position = CGPointMake(left_corner_x, bottom_corner_y);
    border_bottom.anchorPoint = CGPointMake(0,0);
    
    border_bottom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(border_width*scale, 1)];
    border_bottom.physicsBody.affectedByGravity = NO;
    border_bottom.physicsBody.categoryBitMask = WALL_CATEGORY;
    border_bottom.physicsBody.contactTestBitMask = PLAYER_CATEGORY;
    border_bottom.physicsBody.collisionBitMask = PLAYER_CATEGORY;
    border_bottom.physicsBody.resting = TRUE;
    border_bottom.physicsBody.dynamic = FALSE;
    border_bottom.physicsBody.restitution = 0;
    
    [self addChild:border_bottom];
    
    //right
//    SKShapeNode* border_right = [SKShapeNode node];
//    
//    CGPathMoveToPoint(pathToDraw, NULL, right_corner_x, bottom_corner_y);
//    CGPathAddLineToPoint(pathToDraw, NULL, right_corner_x, top_corner_y);
//    
//    border_right.path = pathToDraw;
//    [border_right setStrokeColor:BORDER_COLOR];
//    [border_right setLineWidth:1];
//    [border_right setAntialiased:FALSE];
    
    
    SKSpriteNode* border_right = [SKSpriteNode spriteNodeWithColor:BORDER_COLOR
                                                             size:CGSizeMake(1,border_height)];
    border_right.position = CGPointMake(right_corner_x-1, bottom_corner_y);
    border_right.anchorPoint = CGPointMake(0,0);
    
    border_right.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, border_height*scale)];
    border_right.physicsBody.affectedByGravity = NO;
    border_right.physicsBody.categoryBitMask = WALL_CATEGORY;
    border_right.physicsBody.contactTestBitMask = PLAYER_CATEGORY;
    border_right.physicsBody.collisionBitMask = PLAYER_CATEGORY;
    border_right.physicsBody.resting = TRUE;
    border_right.physicsBody.dynamic = FALSE;
    
    [self addChild:border_right];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (currStage != nil) {
        [currStage touchesBegan:touches withEvent:event];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (currStage != nil) {
        [currStage touchesEnded:touches withEvent:event];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

//- (void)didEndContact:(SKPhysicsContact *)contact {
//    if ((contact.bodyA.categoryBitMask & PLAYER_CATEGORY)!=0) {
//        
//        STATank *player = (STATank*)contact.bodyA.node;
//        
//        if ((contact.bodyB.categoryBitMask & PLAYER_CATEGORY) != 0) {
//            STATank *player2 = (STATank*)contact.bodyB.node;
////            [player stop];
////            [player2 stop];
//        }
//        else if ((contact.bodyB.categoryBitMask & ENEMY_CATEGORY) != 0) {
//            STAEnemyTank *player2 = (STAEnemyTank*)contact.bodyB.node;
////            [player stop];
////            [player2 stop];
//        }
//    }
//}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"did contact");
    
    
    if ((contact.bodyA.categoryBitMask & PLAYER_CATEGORY)!=0) {
        
        STATank *player = (STATank*)contact.bodyA.node;
        
        if ((contact.bodyB.categoryBitMask & ENEMY_CATEGORY) != 0) {
            STATank *enemy = (STATank*)contact.bodyB.node;
            
            NSLog(@"contact!: player and monster");
//            [player contactWith:enemy];
        }
        else if ((contact.bodyB.categoryBitMask & WALL_CATEGORY) != 0) {
            NSLog(@"hit wall");
            [player stopMovement];
        }
        else if ((contact.bodyB.categoryBitMask & MISSLE_CATEGORY) != 0) {
            NSLog(@"hit missle");
            STABullet * bullet = (STABullet*)contact.bodyB.node;
            if (bullet.ownerId != player.playerId && !isGameOver) {
                isGameOver = true;
                [player explode];
                
                STATank* tank = ((STABattleStage*)currStage).enemy;
                [tank fadeInNow];
                [bullet removeFromParent];
            }
        }
    }
    else if ((contact.bodyA.categoryBitMask & ENEMY_CATEGORY) != 0) {
        STATank* enemy = (STATank*)contact.bodyA.node;
        
        if ((contact.bodyB.categoryBitMask & MISSLE_CATEGORY) != 0) {
            STABullet* bullet = (STABullet*)contact.bodyB.node;
            
            NSLog(@"missle hit monster");
            if (bullet.ownerId != enemy.playerId && !isGameOver) {
                isGameOver = true;
                [enemy explode];
                
                STATank* tank = ((STABattleStage*)currStage).player;
                [tank stop];
                [tank stopFadeOut];
                [tank fadeInNow];
//                [tank dance];
                [bullet removeFromParent];
            }
        }
        else if ((contact.bodyB.categoryBitMask & ENEMY_CATEGORY) != 0) {
            STATank* enemy2 = (STATank*)contact.bodyB.node;
            
            SKAction *wait = [SKAction waitForDuration:1];
            SKAction* stop=[SKAction runBlock:^(void) {
                [enemy2 stopVelocity];
            }];
            SKAction* restore=[SKAction runBlock:^(void) {
                [enemy2 restoreVelocity];
            }];
            
//            [enemy2 runAction:[SKAction sequence:@[wait,stop,wait,stop,wait,stop]]];
        }
    }
    else if ((contact.bodyA.categoryBitMask & MISSLE_CATEGORY) != 0) {
        STABullet* bullet = (STABullet*)contact.bodyA.node;
        
        if ((contact.bodyB.categoryBitMask & PLAYER_CATEGORY) != 0) {
            STATank* player = (STATank*)contact.bodyB.node;
            
            NSLog(@"missle hit player");
            if (bullet.ownerId != player.playerId && !isGameOver) {
                isGameOver = true;
                [player explode];
                
                STATank* tank = ((STABattleStage*)currStage).enemy;
                [tank fadeInNow];
                [bullet removeFromParent];
            }
        }
    }
    else if ((contact.bodyA.categoryBitMask & WALL_CATEGORY) != 0) {
        NSLog(@"hit wall!");
        if ((contact.bodyB.categoryBitMask & PLAYER_CATEGORY) != 0) {
            STATank *player = (STATank*)contact.bodyB.node;
            
            NSLog(@"contact!: wall contact player");
            [player stopMovement];
        }
    }
    
}

- (void) createSceneContents
{
    self.scaleMode = SKSceneScaleModeAspectFit;
//    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
//    self.physicsBody.friction = 0.0f;
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
