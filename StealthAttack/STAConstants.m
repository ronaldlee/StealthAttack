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


const uint32_t APPROACH_PROB_KEY = 1;
const uint32_t WARNSHOT_PROB_KEY = 2;
const uint32_t EVADE_PROB_KEY = 3;
const uint32_t DONTMOVE_PROB_KEY = 4;
const uint32_t STUPID_PROB_KEY = 5;

const uint32_t DISTANCE_LONG = 1;
const uint32_t DISTANCE_MID = 2;
const uint32_t DISTANCE_SHORT = 3;


const uint32_t REGION_LEFT_BOTTOM = 1;
const uint32_t REGION_LEFT_MIDDLE = 2;
const uint32_t REGION_LEFT_TOP = 3;

const uint32_t REGION_MIDDLE_BOTTOM = 4;
const uint32_t REGION_MIDDLE_MIDDLE = 5;
const uint32_t REGION_MIDDLE_TOP = 6;

const uint32_t REGION_RIGHT_BOTTOM = 7;
const uint32_t REGION_RIGHT_MIDDLE = 8;
const uint32_t REGION_RIGHT_TOP = 9;

const BOOL IS_ENABLE_STEALTH = true;

UIColor* TANK_BODY_WHITE;
UIColor* TANK_BODY_BASE_WHITE;
UIColor* TANK_BODY_GREEN;
UIColor* TANK_BODY_BASE_GREEN;
UIColor* TANK_BODY_RED;
UIColor* TANK_BODY_BASE_RED;
UIColor* TANK_BODY_YELLOW;
UIColor* TANK_BODY_BASE_YELLOW;
UIColor* TANK_BODY_BLUE;
UIColor* TANK_BODY_BASE_BLUE;

const int ACTION_SUBMIT_CHOICE = 11;
const int ACTION_SEND_READY_BATTLE_STAGE = 12;
const int ACTION_SEND_BATTLE_STAGE_UI_READY = 13;

const int ACTION_ACK_CHOICE = 100011;
const int ACTION_ACK_READY_BATTLE_STAGE = 100012;
const int ACTION_ACK_BATTLE_STAGE_UI_READY = 100013;

const NSString* ENCODE_KEY = @"wooowowowos";

const int MULTIPLAY_STAGE_CHOOSE_TANK = 1;
const int MULTIPLAY_STAGE_BATTLE = 2;
const int MULTIPLAY_STAGE_BATTLE_START = 3;

@end
