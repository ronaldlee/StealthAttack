//
//  STABullet.m
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STABullet.h"
@interface STABullet() {
    float bottom_border_y, top_border_y, left_border_x, right_border_x;
    BORDER player_current_border;
    float scale;
    
    float max_width, max_height;
    
    CGFloat fly_duration;
    
    float start_x, start_y;
    CGRect bounds;
    CGFloat move_speed;
    float scaled_pixel_width;
    float scaled_pixel_height;
}
@end

@implementation STABullet

- (id)initWithScale:(CGFloat)f_scale {
    self = [super init];
    if (self) {
        // Initialize self.
        
        scale = f_scale;
        
        player_current_border = BORDER_BOTTOM;
        
        CGFloat scaled_width = PIXEL_WIDTHHEIGHT*scale;
        CGFloat scaled_height = PIXEL_WIDTHHEIGHT*scale;
        
        self.size = CGSizeMake(scaled_width, scaled_height);
        
        self.bullet = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.bullet];
        self.bullet.position = CGPointMake(scaled_width,scaled_height-3*scale);
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = MISSLE_CATEGORY;
        self.physicsBody.contactTestBitMask = ENEMY_CATEGORY | PLAYER_CATEGORY;
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.linearDamping = 0;
        
    }
    return self;
}

-(void)setBorderBounds:(CGRect)p_bounds {
    bounds = p_bounds;
    
    left_border_x = bounds.origin.x;
    right_border_x = left_border_x+bounds.size.width;
    bottom_border_y = bounds.origin.y;
    top_border_y = bottom_border_y+bounds.size.height;
}

@end
