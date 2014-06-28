//
//  STAGameObject.h
//  StealthAttack
//
//  Created by Ronald Lee on 6/28/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STAGameObject <NSObject>

-(void)contactWith:(id<STAGameObject>)gameObj;
-(void)explode;

@end
