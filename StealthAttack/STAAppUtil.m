//
//  STAAppUtil.m
//  StealthAttack
//
//  Created by Ronald Lee on 8/23/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAAppUtil.h"

@implementation STAAppUtil

+(UIStoryboard*)getStoryboard {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    return [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
}

@end
