//
//  STAMCManager.h
//  StealthAttack
//
//  Created by Ronald Lee on 8/18/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface STAMCManager : NSObject<MCSessionDelegate>

@property (nonatomic,strong)MCPeerID * peerID;
@property (nonatomic,strong)MCSession*session;
@property (nonatomic,strong)MCBrowserViewController *browser;
@property (nonatomic,strong)MCAdvertiserAssistant *advertiser;
@property (nonatomic)BOOL isServer;

-(void)setupPeerAndSessionWithDisplayName:(NSString*)displayName;
-(void)setupMCBrowser;
-(void)advertiseSelf:(BOOL)shouldAdvertise;

-(void)reset;

-(void)resetStage;
-(void)setStage:(int)stage;
-(int)getStage;
-(void)setOppTank:(STATank*)tank;

-(BOOL)isStageChooseTankReady;
-(BOOL)isStageBattleReady;

-(void)submitPlayerChoiceTank:(int)myTankId Color:(int)myColorId Scale:(CGFloat)myScale;

-(void)sendBattleStageUIReady;

-(void)setStageObj:(STAStage*)stage;

-(void)sendRotateC;
-(void)sendRotateUC;
-(void)sendForward;
-(void)sendBackward;
-(void)sendFire;
-(void)sendStopX:(CGFloat)x Y:(CGFloat)y R:(CGFloat)r;
-(void)sendAdjX:(CGFloat)x Y:(CGFloat)y R:(CGFloat)r;

@end
