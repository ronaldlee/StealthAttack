//
//  STAAppDelegate.h
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STAMCManager;
@interface STAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) STAMCManager *mcManager;

@end
