//
//  STAConstants.m
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAConstants.h"

@implementation STAConstants

float const PIXEL_WIDTHHEIGHT =3;
float const PIXEL_WIDTHHEIGHT_x2 = PIXEL_WIDTHHEIGHT*2;
float const PIXEL_WIDTHHEIGHT_x3 = PIXEL_WIDTHHEIGHT*3;

float const PLAYER_WIDTH = PIXEL_WIDTHHEIGHT*3;
float const PLAYER_HEIGHT = PIXEL_WIDTHHEIGHT*3;

float const BOTTOM_HUD_HEIGHT = 100;
float const TOP_HUD_HEIGHT = 30;

const CGFloat SPEED = 100;
float const BORDER_SIDE_MARGIN=2;

const uint32_t MISSLE_CATEGORY  =  0x1 << 0;
const uint32_t PLAYER_CATEGORY   =  0x1 << 1;
const uint32_t ENEMY_CATEGORY    =  0x1 << 2;
const uint32_t WALL_CATEGORY = 0x1 << 3;


const uint32_t REVEALED_APPROACH_PROB_KEY = 1;
const uint32_t REVEALED_WARNSHOT_PROB_KEY = 2;
const uint32_t REVEALED_EVADE_PROB_KEY = 3;
const uint32_t REVEALED_DONTMOVE_PROB_KEY = 4;
const uint32_t REVEALED_STUPID_PROB_KEY = 5;

@end
