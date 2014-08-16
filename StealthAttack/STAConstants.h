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

extern UIColor* TANK_BODY_GREEN;
extern UIColor* TANK_BODY_BASE_GREEN;
extern UIColor* TANK_BODY_RED;
extern UIColor* TANK_BODY_BASE_RED;
extern UIColor* TANK_BODY_YELLOW;
extern UIColor* TANK_BODY_BASE_YELLOW;
extern UIColor* TANK_BODY_BLUE;
extern UIColor* TANK_BODY_BASE_BLUE;


@end
