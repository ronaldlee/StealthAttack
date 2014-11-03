//
//  STAMCManager.h
//  StealthAttack
//
//  Created by Ronald Lee on 8/18/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@protocol STASessionControllerDelegate;

@interface STAMCManager : NSObject<MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) id<STASessionControllerDelegate> delegate;

//@property (nonatomic,strong)MCPeerID * peerID;
//@property (nonatomic,strong)MCSession*session;

//@property (nonatomic,strong)MCBrowserViewController *browser;
//@property (nonatomic,strong)MCAdvertiserAssistant *advertiser;

@property (nonatomic, readonly) NSArray *connectedPeers;
@property (nonatomic, readonly) NSArray *connectingPeers;
@property (nonatomic, readonly) NSArray *disconnectedPeers;
@property (nonatomic, readonly) NSArray *discoveredPeers;
@property (nonatomic, readonly) NSString *displayName;

@property (nonatomic)BOOL isServer;

-(void)setupPeerAndSessionWithDisplayName:(NSString*)displayName;
//-(void)setupMCBrowser;
//-(void)advertiseSelf:(BOOL)shouldAdvertise;

-(void)reset;

-(void)resetStage;
-(void)setStage:(int)stage;
-(int)getStage;
-(void)setOppTank:(STATank*)tank;
-(void)setIsPlayerWonLocal:(int)flag;

-(BOOL)isStageChooseTankReady;
-(BOOL)isStageBattleReady;

-(void)submitPlayerChoiceTank:(int)myTankId Color:(int)myColorId Scale:(double)myScale IsStealthOn:(BOOL)isStealthOn;

-(void)sendBattleStageUIReady;

-(void)setStageObj:(STAStage*)stage;

-(void)sendRotateC;
-(void)sendRotateUC;
-(void)sendForward;
-(void)sendBackward;
-(void)sendFire;
-(void)sendStop; //X:(CGFloat)x Y:(CGFloat)y R:(CGFloat)r;
-(void)sendAdjX:(CGFloat)x Y:(CGFloat)y R:(CGFloat)r;
-(void)sendGameOverIsIWon:(BOOL)isIWon;
-(void)sendReplay;
-(void)sendBack;
-(void)sendMultiPlaySelectBack;

-(void)resetMC;
-(void)cancelConnectPeers;
-(void)disconnect;
-(void)broadcast;

-(void)setListenOk:(BOOL)isListenOk;

//
- (NSString *)stringForPeerConnectionState:(MCSessionState)state;
- (void)startServices;
- (void) invitePeer:(MCPeerID *)peerID;

@end


// Delegate methods for SessionController
@protocol STASessionControllerDelegate <NSObject>

// Session changed state - connecting, connected and disconnected peers changed
- (void)sessionDidChangeStateForPeer:(MCPeerID *)peerID state:(MCSessionState)state;

@end
