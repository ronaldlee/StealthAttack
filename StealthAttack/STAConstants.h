//
//  STAConstants.h
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAConstants : NSObject

extern float const PIXEL_WIDTHHEIGHT;
extern float const PLAYER_WIDTH;
extern float const PLAYER_HEIGHT;
extern float const PIXEL_WIDTHHEIGHT_x2;
extern float const PIXEL_WIDTHHEIGHT_x3;

#define PLAYER_COLOR [UIColor whiteColor]
#define BORDER_COLOR [UIColor whiteColor]

extern float const BOTTOM_HUD_HEIGHT;
extern float const TOP_HUD_HEIGHT;

extern CGFloat const SPEED;
extern float const BORDER_SIDE_MARGIN;

typedef enum {
    BORDER_TOP,
    BORDER_LEFT,
    BORDER_BOTTOM,
    BORDER_RIGHT,
}BORDER;

#define DEGREES_TO_RADIANS(degrees) ((M_PI*degrees)/180)

extern const uint32_t MISSLE_CATEGORY;
extern const uint32_t PLAYER_CATEGORY;
extern const uint32_t ENEMY_CATEGORY;
extern const uint32_t WALL_CATEGORY;

extern const uint32_t APPROACH_PROB_KEY;
extern const uint32_t WARNSHOT_PROB_KEY;
extern const uint32_t EVADE_PROB_KEY;
extern const uint32_t DONTMOVE_PROB_KEY;
extern const uint32_t STUPID_PROB_KEY;

extern const uint32_t DISTANCE_LONG;
extern const uint32_t DISTANCE_MID;
extern const uint32_t DISTANCE_SHORT;


extern const uint32_t REGION_LEFT_BOTTOM;
extern const uint32_t REGION_LEFT_MIDDLE;
extern const uint32_t REGION_LEFT_TOP;

extern const uint32_t REGION_MIDDLE_BOTTOM;
extern const uint32_t REGION_MIDDLE_MIDDLE;
extern const uint32_t REGION_MIDDLE_TOP;

extern const uint32_t REGION_RIGHT_BOTTOM;
extern const uint32_t REGION_RIGHT_MIDDLE;
extern const uint32_t REGION_RIGHT_TOP;

extern const BOOL IS_ENABLE_STEALTH;

extern UIColor* TANK_BODY_WHITE;
extern UIColor* TANK_BODY_BASE_WHITE;
extern UIColor* TANK_BODY_GREEN;
extern UIColor* TANK_BODY_BASE_GREEN;
extern UIColor* TANK_BODY_RED;
extern UIColor* TANK_BODY_BASE_RED;
extern UIColor* TANK_BODY_YELLOW;
extern UIColor* TANK_BODY_BASE_YELLOW;
extern UIColor* TANK_BODY_BLUE;
extern UIColor* TANK_BODY_BASE_BLUE;

extern const int ACTION_ACK_CHOICE;
extern const int ACTION_SUBMIT_CHOICE;
extern const int ACTION_SEND_READY_BATTLE_STAGE;
extern const int ACTION_ACK_READY_BATTLE_STAGE;

extern const int ACTION_SEND_BATTLE_STAGE_UI_READY;
extern const int ACTION_ACK_BATTLE_STAGE_UI_READY;

//tank actions
extern const int ACTION_ROTATE_C_BUTTON_PRESSED;
extern const int ACTION_ACK_ROTATE_C_BUTTON_PRESSED;

extern const int ACTION_ROTATE_UC_BUTTON_PRESSED;
extern const int ACTION_ACK_ROTATE_UC_BUTTON_PRESSED;

extern const int ACTION_FORWARD_BUTTON_PRESSED;
extern const int ACTION_ACK_FORWARD_BUTTON_PRESSED;
extern const int ACTION_BACKWARD_BUTTON_PRESSED;
extern const int ACTION_ACK_BACKWARD_BUTTON_PRESSED;

extern const int ACTION_FIRE_BUTTON_PRESSED;
extern const int ACTION_ACK_FIRE_BUTTON_PRESSED;

extern const int ACTION_STOP;
extern const int ACTION_ACK_STOP;

extern const int ACTION_ADJ;
//

extern const NSString* ENCODE_KEY;

extern const int MULTIPLAY_STAGE_CHOOSE_TANK;
extern const int MULTIPLAY_STAGE_BATTLE;
extern const int MULTIPLAY_STAGE_BATTLE_START;


@end
