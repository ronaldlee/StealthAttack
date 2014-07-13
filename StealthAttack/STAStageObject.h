//
//  STAStageObject.h
//  StealthAttack
//
//  Created by Ronald Lee on 7/6/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STAStageObject <NSObject>

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)cleanup;

@end
