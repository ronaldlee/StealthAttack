//
//  STAButton.m
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAButton.h"

@interface STAButton() {
    float left_corner_x, right_corner_x, top_corner_y, bottom_corner_y;
}
@end

@implementation STAButton
@synthesize button;

- (id)initWithSize:(CGSize)b_size  Name:(NSString*)b_name Alpha:(CGFloat)alpha {
    self = [super init];
    if (self) {
        self.anchorPoint = CGPointMake(0,0);
        
        // Initialize self.
        self.size = b_size;
        
        left_corner_x = top_corner_y = 0;
        right_corner_x = b_size.width;
        bottom_corner_y = b_size.height;
        
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        
        
        //top
        SKShapeNode* border_top = [SKShapeNode node];
        
        CGPathMoveToPoint(pathToDraw, NULL, left_corner_x, top_corner_y);
        CGPathAddLineToPoint(pathToDraw, NULL, right_corner_x, top_corner_y);
        border_top.name = @"border_top";
        border_top.path = pathToDraw;
        border_top.userInteractionEnabled = NO;
        border_top.alpha = alpha;
        [border_top setStrokeColor:BORDER_COLOR];
        [border_top setLineWidth:1];
        [border_top setAntialiased:FALSE];
        [self addChild:border_top];
        
        //left
        SKShapeNode* border_left = [SKShapeNode node];
        
        CGPathMoveToPoint(pathToDraw, NULL, left_corner_x, bottom_corner_y);
        CGPathAddLineToPoint(pathToDraw, NULL, left_corner_x, top_corner_y);
        border_left.name = @"border_left";
        border_left.userInteractionEnabled = NO;
        border_left.path = pathToDraw;
        border_left.alpha = alpha;
        [border_left setStrokeColor:BORDER_COLOR];
        [border_left setLineWidth:1];
        [border_left setAntialiased:FALSE];
        [self addChild:border_left];
        
        //bottom
        SKShapeNode* border_bottom = [SKShapeNode node];
        
        CGPathMoveToPoint(pathToDraw, NULL, left_corner_x, bottom_corner_y);
        CGPathAddLineToPoint(pathToDraw, NULL, right_corner_x, bottom_corner_y);
        border_bottom.name = @"border_bottom";
        border_bottom.userInteractionEnabled = NO;
        border_bottom.path = pathToDraw;
        border_bottom.alpha = alpha;
        [border_bottom setStrokeColor:BORDER_COLOR];
        [border_bottom setLineWidth:1];
        [border_bottom setAntialiased:FALSE];
        [self addChild:border_bottom];
        
        //right
        SKShapeNode* border_right = [SKShapeNode node];
        
        CGPathMoveToPoint(pathToDraw, NULL, right_corner_x, bottom_corner_y);
        CGPathAddLineToPoint(pathToDraw, NULL, right_corner_x, top_corner_y);
        border_right.name = @"border_right";
        border_right.userInteractionEnabled = NO;
        border_right.path = pathToDraw;
        border_right.alpha = alpha;
        [border_right setStrokeColor:BORDER_COLOR];
        [border_right setLineWidth:1];
        [border_right setAntialiased:FALSE];
        [self addChild:border_right];
        
        //==
        
        button = [SKSpriteNode spriteNodeWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.0] size:b_size];
        button.name=b_name;
        button.userInteractionEnabled = NO;
        //        button.position = CGPointMake(0,0);
        button.anchorPoint = CGPointMake(0,0);
        [self addChild:button];
        
    }
    return self;
}


@end
