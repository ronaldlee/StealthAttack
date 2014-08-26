//
//  STAButton.h
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface STAButton : SKSpriteNode


@property (nonatomic) SKSpriteNode * button;
@property (nonatomic) BOOL isDoneRecharge;

- (id)initWithSize:(CGSize)b_size Scale:(CGFloat)scale Name:(NSString*)b_name Alpha:(CGFloat)alpha
           BGAlpha:(CGFloat)bg_alpha
        ButtonText:(NSString*)button_text ButtonTextColor:(SKColor*)bt_color ButtonTextFont:(NSString*)bt_font
ButtonTextFontSize:(int)font_size
      isShowBorder:(BOOL)p_isShowBorder
           BGColor:(UIColor*)bg_color;

- (id)initWithSize:(CGSize)size Scale:(CGFloat)scale Name:(NSString*)name Alpha:(CGFloat)alpha BGAlpha:(CGFloat)bg_alpha
        ButtonText:(NSString*)button_text ButtonTextColor:(SKColor*)bt_color ButtonTextFont:(NSString*)bt_font
ButtonTextFontSize:(int)font_size
      isShowBorder:(BOOL)isShowBorder;

-(void)recharge;

-(void)flashText;

-(void)stopFlashText;

-(void)setText:(NSString*)text;

-(void)showBorder:(BOOL)isShowBorder;

@end
