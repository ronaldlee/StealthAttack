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
    
    SKLabelNode* labelNode;
    BOOL isShowBorder;
}
@end

@implementation STAButton

@synthesize button;
@synthesize isDoneRecharge;


- (id)initWithSize:(CGSize)b_size  Name:(NSString*)b_name Alpha:(CGFloat)alpha BGAlpha:(CGFloat)bg_alpha
        ButtonText:(NSString*)button_text ButtonTextColor:(SKColor*)bt_color ButtonTextFont:(NSString*)bt_font
ButtonTextFontSize:(int)font_size
      isShowBorder:(BOOL)p_isShowBorder{
    self = [super init];
    if (self) {
        isShowBorder = p_isShowBorder;
        isDoneRecharge= true;
        self.anchorPoint = CGPointMake(0,0);
        
        // Initialize self.
        self.size = b_size;
        
        left_corner_x = top_corner_y = 0;
        right_corner_x = b_size.width;
        bottom_corner_y = b_size.height;
        
        if (isShowBorder) {
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
        }
        
        //==
        
        button = [SKSpriteNode spriteNodeWithColor:[[UIColor whiteColor] colorWithAlphaComponent:bg_alpha] size:b_size];
        button.name=b_name;
        button.userInteractionEnabled = NO;
        //        button.position = CGPointMake(0,0);
        button.anchorPoint = CGPointMake(0,0);
        [self addChild:button];
        
        //==
        if (button_text != NULL) {
            NSString * font = bt_font;//@"GridExerciseGaps";
            labelNode = [SKLabelNode labelNodeWithFontNamed:font];
            
            NSString *cdStr = button_text;
            labelNode.text = cdStr;
            labelNode.fontSize = font_size;
            labelNode.fontColor = bt_color;
            labelNode.name = b_name;
            
            CGFloat label_x = self.size.width/2;
            CGFloat label_y = self.size.height-10;
            
            labelNode.position = CGPointMake(label_x,label_y);
            
            [self addChild:labelNode];
        }
        
    }
    return self;
}

-(void)recharge {
    isDoneRecharge = false;
    button.alpha = 0.0;
    SKAction* fadeIn = [SKAction fadeInWithDuration:5];
    [button runAction:fadeIn completion:^() {
        
        labelNode.alpha = 0.0;
        SKAction* flash = [SKAction runBlock:^() {
            labelNode.alpha = 1.0;
            isDoneRecharge = true;
        }];
        
        SKAction *wait = [SKAction waitForDuration:0.1];
        [button runAction:[SKAction sequence:@[wait,flash]]];
        
    }];
}

-(void)flashText {
    SKAction *wait = [SKAction waitForDuration:0.05];
    SKAction* showText = [SKAction runBlock:^() {
        labelNode.alpha = 1.0;
    }];
    SKAction* hideText = [SKAction runBlock:^() {
        labelNode.alpha = 0.0;
    }];
    
//    SKAction *wait = [SKAction waitForDuration:ai.thinkSpeed];
//    [self.brainNode runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait,aiAction]]]];
    
    [button runAction:[SKAction repeatActionForever:[SKAction sequence:@[hideText,wait,showText,wait]]]];
}

-(void)stopFlashText {
    [button removeAllActions];
    labelNode.alpha = 1.0;
}

-(void)setText:(NSString*)text {
    if (labelNode == nil) return;
    
    labelNode.text = text;
}


@end
