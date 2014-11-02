//
//  STAMCManager.m
//  StealthAttack
//
//  Created by Ronald Lee on 8/18/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAMCManager.h"
@interface STAMCManager () // Class extension

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (nonatomic, strong) MCNearbyServiceBrowser *serviceBrowser;

@property (nonatomic, strong) NSMutableOrderedSet *discoveredPeersOrderedSet;
@property (nonatomic, strong) NSMutableOrderedSet *connectingPeersOrderedSet;
@property (nonatomic, strong) NSMutableOrderedSet *disconnectedPeersOrderedSet;
@end

@interface STAMCManager() {
    
    int stage;
    int msgId;
    
    int oppColorId;
    int oppTankId;
    double oppScale;
    
    int myColorId;
    int myTankId;
    double myScale;
    BOOL isAckColor;
    BOOL isAckTank;
    BOOL isAckScale;
    
    BOOL isReadyBattleStage;
    BOOL isAckReadyBattleStage;
    BOOL isOppReadyBattleStage;
    //
    
    BOOL isBattleStageUIReady;
    BOOL isAckBattleStageUIReady;
    BOOL isOppBattleStageUIReady;
    BOOL isOppReplayOK;
    BOOL isAckReplayOK;
    
    STATank* oppTank;
    
    STAStage* curStage;
    
    BOOL isStealthOn;
    
    int isPlayerWonLocal;
    int isPlayerWonRemote;
    
//    (void(^)(BOOL accept, MCSession *session)) tempInvitationHandler;
    
    void (^ tempInvitationHandler)(BOOL accept, MCSession *session);
    
    MCPeerID* tempRemotePeerID;
    
}
@end

@implementation STAMCManager

static NSString * const kMCSessionServiceType = @"stasessionp2p";

-(id)init {
    self = [super init];
    
    if (self) {
        isStealthOn = true;
        _session = nil;
        
//        _browser = nil;
//        _advertiser = nil;
        
        
        isPlayerWonLocal = -1;
        isPlayerWonRemote = -1;
        
        _peerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
        
        _discoveredPeersOrderedSet = [[NSMutableOrderedSet alloc] init];
        _connectingPeersOrderedSet = [[NSMutableOrderedSet alloc] init];
        _disconnectedPeersOrderedSet = [[NSMutableOrderedSet alloc] init];
        
        
//        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//        
//        // Register for notifications
//        [defaultCenter addObserver:self
//                          selector:@selector(startServices)
//                              name:UIApplicationWillEnterForegroundNotification
//                            object:nil];
//        
//        [defaultCenter addObserver:self
//                          selector:@selector(stopServices)
//                              name:UIApplicationDidEnterBackgroundNotification
//                            object:nil];
        
//        _displayName = self.session.myPeerID.displayName;
        
        [self reset];
    }
    
    return self;
}

-(void)setOppTank:(STATank*)tank {
    oppTank = tank;
}

-(void)setIsPlayerWonLocal:(int)flag {
    if (isPlayerWonLocal == -1) { //not yet set by other end!
        isPlayerWonLocal = flag;
        
        BOOL isPlayerWonLocalBool = [[NSNumber numberWithInt:isPlayerWonLocal] boolValue];
        
        [self sendGameOverIsIWon:isPlayerWonLocalBool];
    }
//    else {
//        if (stage == MULTIPLAY_STAGE_BATTLE_START) {
//            STAMultiPlayBattleStage* mstage = (STAMultiPlayBattleStage*)curStage;
//            isOppBattleStageUIReady = FALSE;
//            isAckBattleStageUIReady = FALSE;
//            
//            [mstage showGameOver:isPlayerWonLocal];
//            
//            stage = MULTIPLAY_STAGE_BATTLE_END;
//        }
//    }
}

-(void)resetMC {
    _peerID = nil;
    _session = nil;
//    _browser = nil;
//    _advertiser = nil;
}

-(void) reset {
    [self resetStage];
    
    [self resetFlags];
    
    [self cancelConnectPeers];
}

-(void)resetFlags {
    oppColorId = 0;
    oppTankId = 0;
    oppScale = 0.0;
    
    myColorId = 0;
    myTankId = 0;
    myScale = 0.0;
    isAckColor = FALSE;
    isAckTank = FALSE;
    isAckScale = FALSE;
    
    isReadyBattleStage = false;
    isAckReadyBattleStage = false;
    isOppReadyBattleStage = false;
    
    isBattleStageUIReady = false;
    isAckBattleStageUIReady = false;
    isOppBattleStageUIReady = false;
    isOppReplayOK = false;
    isAckReplayOK = false;
    
    isPlayerWonLocal = -1;
    isPlayerWonRemote = -1;
}

-(void)resetStage {
    stage = 0;
}

-(void)setStage:(int)p_stage {
    stage = p_stage;
}

-(int)getStage {
    return stage;
}

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName{
//    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    
    //If there is no PeerID save, create one and save it
    NSMutableString* peerIdKey = [NSMutableString stringWithString:@"stealthattk_peerid_"];
    [peerIdKey appendString:displayName];
    
    if ([[NSUserDefaults standardUserDefaults] dataForKey:peerIdKey] == nil)
    {
        _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver
                              archivedDataWithRootObject:_peerID] forKey:peerIdKey];
    }
    else
    {
        _peerID = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
                                                  dataForKey:peerIdKey]];
    }
    
    if (_session == nil) { //this will keep the connected device to be displayed.
        _session = [[MCSession alloc] initWithPeer:_peerID];
        _session.delegate = self;
    }
    
}

-(void)cancelConnectPeers{
    if (_session == nil) return;
    
    NSArray *connectedPeers = _session.connectedPeers;
    for (MCPeerID* peer in connectedPeers) {
        [_session cancelConnectPeer:peer];
    }
    
    [NSThread sleepForTimeInterval:2];
    
    NSLog(@"boo");
}
//
//-(void)setupMCBrowser{
//    _browser = [[MCBrowserViewController alloc] initWithServiceType:@"chat-files" session:_session];
//}

//-(void)advertiseSelf:(BOOL)shouldAdvertise{
//    if (shouldAdvertise) {
//        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat-files"
//                                                           discoveryInfo:nil
//                                                                 session:_session];
//        [_advertiser start];
//    }
//    else{
//        [_advertiser stop];
//        _advertiser = nil;
//    }
//}

//-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
//    NSDictionary *dict = @{@"peerID": peerID,
//                           @"state" : [NSNumber numberWithInt:state]
//                           };
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
//                                                        object:nil
//                                                      userInfo:dict];
//}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    if (IS_SHOW_RECEIVE_DATA) NSLog(@"didReceiveData");
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *myDictionary = [unarchiver decodeObjectForKey:ENCODE_KEY];
    [unarchiver finishDecoding];
    
    NSNumber* actionId = (NSNumber*)[myDictionary objectForKey:@"action"];
    int actionIdInt = [actionId intValue];
    if (IS_SHOW_RECEIVE_DATA) NSLog(@"didReceiveData: stage: %d, actionId: %d",stage,actionIdInt);
    
    if (stage == MULTIPLAY_STAGE_CHOOSE_TANK) {
        if (actionIdInt == ACTION_SUBMIT_CHOICE) {
            STAMultiPlayerSelect* mstage = (STAMultiPlayerSelect*)curStage;
            
//            NSLog(@"action submit choice");
            NSNumber* oppColorIdNum = (NSNumber*)[myDictionary objectForKey:@"color"];
            oppColorId = [oppColorIdNum intValue];
            
            NSNumber* oppTankIdNum = (NSNumber*)[myDictionary objectForKey:@"tank"];
            oppTankId = [oppTankIdNum intValue];
            
            NSNumber* oppScaleNum = (NSNumber*)[myDictionary objectForKey:@"scale"];
            oppScale = [oppScaleNum doubleValue];
            
            NSNumber* oppIsStealthOnNum = (NSNumber*)[myDictionary objectForKey:@"isStealthOn"];
            isStealthOn = [oppIsStealthOnNum boolValue];
            
//            NSNumber* oppMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
//            int oppMsgId = [oppMsgIdNum intValue];
            
            [mstage showOppIsReady];
            
            [self ackPlayerChoiceTank:oppTankId Color:oppColorId Scale:oppScale MsgId:[[myDictionary objectForKey:@"id"] intValue]];
            
            if ([self isStageChooseTankReady]) {
                [self sendReadyBattleStage];
            }
            else {
                if ([mstage isReadyButtonPressed]) {
                    [self submitPlayerChoiceTank:myTankId Color:myColorId Scale:GAME_AREA_SCALE
                                     IsStealthOn:isStealthOn];
                }
            }
        }
        else if (actionIdInt == ACTION_ACK_CHOICE) {
            NSLog(@"action ack choice");
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            if (ackMsgId == msgId) {
                NSLog(@"action ack choice: ackMsgId match");
                NSNumber* ackColorIdNum = (NSNumber*)[myDictionary objectForKey:@"color"];
                int ackColorId = [ackColorIdNum intValue];
                
                if (ackColorId == myColorId) {
                    isAckColor = TRUE;
                }
                NSNumber* ackTankIdNum = (NSNumber*)[myDictionary objectForKey:@"tank"];
                int ackTankId = [ackTankIdNum intValue];
                
                if (ackTankId == myTankId) {
                    isAckTank = TRUE;
                }
                NSNumber * ackScaleNum = (NSNumber*)[myDictionary objectForKey:@"scale"];
                double ackScale = [ackScaleNum doubleValue];
                
                //if (fabs(ackScale - myScale) < 0.001) {
                if (ackScale == myScale) {
                    isAckScale= TRUE;
                }
                
                if ([self isStageChooseTankReady]) {
                    [self sendReadyBattleStage];
                }
            }
            else {
                //ack msg id not match!
            }
        }
        else if (actionIdInt == ACTION_SEND_READY_BATTLE_STAGE) {
            NSLog(@"action send ready battle stage");
            STAMultiPlayerSelect* mstage = (STAMultiPlayerSelect*)curStage;
            
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            isOppReadyBattleStage = TRUE;
            
            [self ackReadyBattleStage:ackMsgId];
            
            if ([self isStageBattleReady]) {
                NSLog(@"action send ready battle stage: battle ready");
                
                //go to Battle Stage
                stage = MULTIPLAY_STAGE_BATTLE;
                
                
                [mstage goToBattleStageMyTank:myTankId MyColor:myColorId MyScale:myScale
                                    OppTankId:oppTankId OppColor:oppColorId OppScale:oppScale
                                  IsStealthOn:isStealthOn];
            }
        }
        else if (actionIdInt == ACTION_ACK_READY_BATTLE_STAGE) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
//            if (ackMsgId == msgId) {
                isAckReadyBattleStage = TRUE;
//            }
            
            if ([self isStageBattleReady]) {
                //go to Battle Stage
                stage = MULTIPLAY_STAGE_BATTLE;
                STAMultiPlayerSelect* mstage = (STAMultiPlayerSelect*)curStage;
                [mstage goToBattleStageMyTank:myTankId MyColor:myColorId MyScale:myScale
                                    OppTankId:oppTankId OppColor:oppColorId OppScale:oppScale
                                  IsStealthOn:isStealthOn];
            }
        }
        else if (actionIdInt == ACTION_MULTIPLAY_SELECT_BACK) {
            
            STAMultiPlayerSelect* mstage = (STAMultiPlayerSelect*)curStage;
            [mstage showOppLeft];
        }
    }
    else if (stage == MULTIPLAY_STAGE_BATTLE) {
        
        if (actionIdInt == ACTION_SEND_BATTLE_STAGE_UI_READY) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            isOppBattleStageUIReady = TRUE;
            [self ackBattleStageUIReady:ackMsgId];
            
            if ([self isStageBattleStageUIReady]) {
                stage = MULTIPLAY_STAGE_BATTLE_START;
                STAMultiPlayBattleStage* mstage = (STAMultiPlayBattleStage*)curStage;
                [mstage startCountDown];
            }
        }
        else if (actionIdInt == ACTION_ACK_BATTLE_STAGE_UI_READY) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
//            if (ackMsgId == msgId) {
                isAckBattleStageUIReady = TRUE;
//            }
            
            if ([self isStageBattleStageUIReady]) {
                stage = MULTIPLAY_STAGE_BATTLE_START;
                STAMultiPlayBattleStage* mstage = (STAMultiPlayBattleStage*)curStage;
                [mstage startCountDown];
            }
        }
    }
    else if (stage == MULTIPLAY_STAGE_BATTLE_START) {
        //opp tank's actions
        STAMultiPlayBattleStage* mstage = (STAMultiPlayBattleStage*)curStage;
        if (actionIdInt == ACTION_ROTATE_C_BUTTON_PRESSED) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            [self ackRotateC:ackMsgId];
            [mstage enemyRotateC];
        }
        else if (actionIdInt == ACTION_ACK_ROTATE_C_BUTTON_PRESSED) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
//            if (ackMsgId == msgId) {
                [mstage playerRotateC];
//            }
        }
        else if (actionIdInt == ACTION_ROTATE_UC_BUTTON_PRESSED) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            [self ackRotateUC:ackMsgId];
            [mstage enemyRotateUC];
        }
        else if (actionIdInt == ACTION_ACK_ROTATE_UC_BUTTON_PRESSED) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
//            if (ackMsgId == msgId) {
                [mstage playerRotateUC];
//            }
        }
        else if (actionIdInt == ACTION_FORWARD_BUTTON_PRESSED) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            [self ackForeward:ackMsgId];
            
            if (!IS_TEST_GAMEOVER_SYNC) {
                [mstage enemyForward];
            }
        }
        else if (actionIdInt == ACTION_ACK_FORWARD_BUTTON_PRESSED) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
//            if (ackMsgId == msgId) {
                [mstage playerForward];
//            }
        }
        else if (actionIdInt == ACTION_BACKWARD_BUTTON_PRESSED) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            [self ackBackward:ackMsgId];
            [mstage enemyBackward];
        }
        else if (actionIdInt == ACTION_ACK_BACKWARD_BUTTON_PRESSED) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
//            if (ackMsgId == msgId) {
                [mstage playerBackward];
//            }
        }
        else if (actionIdInt == ACTION_FIRE_BUTTON_PRESSED) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            [self ackFire:ackMsgId];
            [mstage enemyFire];
        }
        else if (actionIdInt == ACTION_ACK_FIRE_BUTTON_PRESSED) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
//            if (ackMsgId == msgId) {
                [mstage playerFire];
//            }
        }
        else if (actionIdInt == ACTION_STOP) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
//            NSNumber* xNum = (NSNumber*)[myDictionary objectForKey:@"x"];
//            CGFloat x = [xNum floatValue];
//            NSNumber* yNum = (NSNumber*)[myDictionary objectForKey:@"y"];
//            CGFloat y = [yNum floatValue];
//            NSNumber* rNum = (NSNumber*)[myDictionary objectForKey:@"r"];
//            CGFloat r = [rNum floatValue];
            
//            [mstage adjEnemyX:x Y:y R:r];
            [self ackStop:ackMsgId];
            [mstage enemyStop];
        }
        else if (actionIdInt == ACTION_ACK_STOP) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
//            if (ackMsgId == msgId) {
                [mstage playerStop];
//            }
        }
        else if (actionIdInt == ACTION_ADJ) {
            
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            NSNumber* xNum = (NSNumber*)[myDictionary objectForKey:@"x"];
            CGFloat x = [xNum floatValue];
            NSNumber* yNum = (NSNumber*)[myDictionary objectForKey:@"y"];
            CGFloat y = [yNum floatValue];
            NSNumber* rNum = (NSNumber*)[myDictionary objectForKey:@"r"];
            CGFloat r = [rNum floatValue];
            
            if (!IS_TEST_GAMEOVER_SYNC) {
                [mstage adjEnemyX:x Y:y R:r];
            }
        }
        else if (actionIdInt == ACTION_GAMEOVER) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            NSNumber* isIWonNum = (NSNumber*)[myDictionary objectForKey:@"isIWon"];
            BOOL isOpponentWon = [isIWonNum boolValue];
            isPlayerWonRemote = [[NSNumber numberWithBool:!isOpponentWon]intValue];
            
            if (isPlayerWonLocal == -1) {
                isPlayerWonLocal = isPlayerWonRemote;
  
                [mstage showGameOver:isPlayerWonLocal];
                
                stage = MULTIPLAY_STAGE_BATTLE_END;
                
                [self ackGameOver:ackMsgId IsPlayerWon:[isIWonNum intValue]];
            }
            else {
                //if isPlayerWonLocal is set, compare with remote and see.
                if (isPlayerWonRemote == isPlayerWonLocal) {
                    [mstage showGameOver:isPlayerWonLocal];
                    
                    stage = MULTIPLAY_STAGE_BATTLE_END;
                }
                else { //draw
                    [mstage showGameOver:GAME_OVER_DRAW];
                    
                    stage = MULTIPLAY_STAGE_BATTLE_END;
                    
                    [self ackGameOver:ackMsgId IsPlayerWon:GAME_OVER_DRAW];
                }
            }
            
        }
        else if (actionIdInt == ACTION_ACK_GAMEOVER) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            NSNumber* isPlayerWonNum = (NSNumber*)[myDictionary objectForKey:@"isPlayerWon"];
            int isPlayerWon = [isPlayerWonNum intValue];
            
            [mstage showGameOver:isPlayerWon];
            
            stage = MULTIPLAY_STAGE_BATTLE_END;
        }
        
    }
    else if (stage == MULTIPLAY_STAGE_BATTLE_END) {
        //can show REPLAY/BACK message
        STAMultiPlayBattleStage* mstage = (STAMultiPlayBattleStage*)curStage;
        if (actionIdInt == ACTION_GAMEOVER) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            NSNumber* isIWonNum = (NSNumber*)[myDictionary objectForKey:@"isIWon"];
            BOOL isOpponentWon = [isIWonNum boolValue];
            isPlayerWonRemote = [[NSNumber numberWithBool:!isOpponentWon]intValue];
            
            if (isPlayerWonLocal == -1) {
                isPlayerWonLocal = isPlayerWonRemote;
                [mstage showGameOver:isPlayerWonLocal];
                
                stage = MULTIPLAY_STAGE_BATTLE_END;
                
                [self ackGameOver:ackMsgId IsPlayerWon:[isIWonNum intValue]];
            }
            else {
                //if isPlayerWonLocal is set, compare with remote and see.
                if (isPlayerWonRemote == isPlayerWonLocal) {
                    [mstage showGameOver:isPlayerWonLocal];
                    
                    stage = MULTIPLAY_STAGE_BATTLE_END;
                }
                else { //draw
                    [mstage showGameOver:GAME_OVER_DRAW];
                    
                    stage = MULTIPLAY_STAGE_BATTLE_END;
                    
                    [self ackGameOver:ackMsgId IsPlayerWon:GAME_OVER_DRAW];
                }
            }
        }
        else if (actionIdInt == ACTION_ACK_GAMEOVER) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            NSNumber* isPlayerWonNum = (NSNumber*)[myDictionary objectForKey:@"isPlayerWon"];
            int isPlayerWon = [isPlayerWonNum intValue];
            
            [mstage showGameOver:isPlayerWon];
            
            stage = MULTIPLAY_STAGE_BATTLE_END;
        }
        else if (actionIdInt == ACTION_REPLAY) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            isOppReplayOK = true;
            
            [mstage showOppRematch];
            
            [self ackReplay:ackMsgId];
            
            if ([self isAllReplayOK]) {
                
                isOppBattleStageUIReady = FALSE;
                isAckBattleStageUIReady = FALSE;
                isOppReplayOK = false;
                isAckReplayOK = false;
                isPlayerWonLocal = -1;
                isPlayerWonRemote = -1;
                stage = MULTIPLAY_STAGE_BATTLE;
                STAMultiPlayBattleStage* mstage = (STAMultiPlayBattleStage*)curStage;
                [mstage reset];
            }
        }
        else if (actionIdInt == ACTION_ACK_REPLAY) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            isAckReplayOK = true;
            if ([self isAllReplayOK]) {
                
                isOppBattleStageUIReady = FALSE;
                isAckBattleStageUIReady = FALSE;
                isOppReplayOK = false;
                isAckReplayOK = false;
                isPlayerWonLocal = -1;
                isPlayerWonRemote = -1;
                stage = MULTIPLAY_STAGE_BATTLE;
                STAMultiPlayBattleStage* mstage = (STAMultiPlayBattleStage*)curStage;
                [mstage reset];
            }
        }
        else if (actionIdInt == ACTION_BACK) {
            [mstage showOppBack];
        }
    }
//    else {
//        else if (actionIdInt == ACTION_ACK_MULTIPLAY_SELECT_BACK) {
//            
//            STAMultiPlayerSelect* mstage = (STAMultiPlayerSelect*)curStage;
//            [mstage showOppLeft];
//        }
//    }
    
}

-(BOOL)isAllReplayOK {
    return isOppReplayOK && isAckReplayOK;
}

-(BOOL)isStageBattleStageUIReady {
    return isOppBattleStageUIReady && isAckBattleStageUIReady;
}

-(BOOL)isStageBattleReady{
    return isOppReadyBattleStage && isAckReadyBattleStage;
}

-(BOOL)isStageChooseTankReady {
    return oppColorId != 0 && oppTankId != 0 && myColorId != 0 && myTankId != 0 &&
           oppScale != 0.0 && myScale != 0.0 &&
            isAckColor && isAckTank && isAckScale;
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

//===


-(void)submitPlayerChoiceTank:(int)tankId Color:(int)colorId Scale:(double)scale IsStealthOn:(BOOL)isStealthOn{
    myTankId = tankId;
    myColorId = colorId;
    myScale = scale;
    msgId++;
    
    NSLog(@"submitPlayerChoiceTank");
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_SUBMIT_CHOICE],
                                @"tank" : [NSNumber numberWithInt:myTankId],
                                @"color" : [NSNumber numberWithInt:myColorId],
                                @"scale" : [NSNumber numberWithDouble:myScale],
                                @"isStealthOn" : [NSNumber numberWithBool:isStealthOn],
                                @"id": [NSNumber numberWithInt:msgId] };
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)ackPlayerChoiceTank:(int)p_tankId Color:(int)p_colorId Scale:(double)p_scale MsgId:(int)p_msgId {
    
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ACK_CHOICE],
                                 @"tank" : [NSNumber numberWithInt:p_tankId],
                                 @"color" : [NSNumber numberWithInt:p_colorId],
                                 @"scale" : [NSNumber numberWithDouble:p_scale],
                                 @"id" : [NSNumber numberWithInt:p_msgId]};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)sendReadyBattleStage {
    NSLog(@"sendReadyBattleStage");
    
    msgId++;
    isReadyBattleStage = TRUE;
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_SEND_READY_BATTLE_STAGE],
                                 @"id" : [NSNumber numberWithInt:msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)ackReadyBattleStage:(int)p_msgId {
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ACK_READY_BATTLE_STAGE],
                                 @"id" : [NSNumber numberWithInt:p_msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)sendBattleStageUIReady {
    msgId++;
    isReadyBattleStage = TRUE;
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_SEND_BATTLE_STAGE_UI_READY],
                                 @"id" : [NSNumber numberWithInt:msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)ackBattleStageUIReady:(int)p_msgId {
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ACK_BATTLE_STAGE_UI_READY],
                                 @"id" : [NSNumber numberWithInt:p_msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

//
-(void)sendRotateC {
    msgId++;
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ROTATE_C_BUTTON_PRESSED],
                                 @"id" : [NSNumber numberWithInt:msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)ackRotateC:(int)p_msgId {
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ACK_ROTATE_C_BUTTON_PRESSED],
                                 @"id" : [NSNumber numberWithInt:p_msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)sendRotateUC {
    msgId++;
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ROTATE_UC_BUTTON_PRESSED],
                                 @"id" : [NSNumber numberWithInt:msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}
-(void)ackRotateUC:(int)p_msgId {
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ACK_ROTATE_UC_BUTTON_PRESSED],
                                 @"id" : [NSNumber numberWithInt:p_msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)sendForward {
    msgId++;
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_FORWARD_BUTTON_PRESSED],
                                 @"id" : [NSNumber numberWithInt:msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}
-(void)ackForeward:(int)p_msgId {
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ACK_FORWARD_BUTTON_PRESSED],
                                 @"id" : [NSNumber numberWithInt:p_msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}
-(void)sendBackward {
    msgId++;
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_BACKWARD_BUTTON_PRESSED],
                                 @"id" : [NSNumber numberWithInt:msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}
-(void)ackBackward:(int)p_msgId {
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ACK_BACKWARD_BUTTON_PRESSED],
                                 @"id" : [NSNumber numberWithInt:p_msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}
-(void)sendFire {
    msgId++;
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_FIRE_BUTTON_PRESSED],
                                 @"id" : [NSNumber numberWithInt:msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}
-(void)ackFire:(int)p_msgId {
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ACK_FIRE_BUTTON_PRESSED],
                                 @"id" : [NSNumber numberWithInt:p_msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}
-(void)sendStop {  //X:(CGFloat)x Y:(CGFloat)y R:(CGFloat)r {
    msgId++;
//    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_STOP],
//                                 @"id" : [NSNumber numberWithInt:msgId],
//                                 @"x" : [NSNumber numberWithFloat:x],
//                                 @"y" : [NSNumber numberWithFloat:y],
//                                 @"r" : [NSNumber numberWithFloat:r],};
    
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_STOP],
                                 @"id" : [NSNumber numberWithInt:msgId],};
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)sendAdjX:(CGFloat)x Y:(CGFloat)y R:(CGFloat)r {
    msgId++;
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ADJ],
                                 @"id" : [NSNumber numberWithInt:msgId],
                                 @"x" : [NSNumber numberWithFloat:x],
                                 @"y" : [NSNumber numberWithFloat:y],
                                 @"r" : [NSNumber numberWithFloat:r],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)ackStop:(int)p_msgId {
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ACK_STOP],
                                 @"id" : [NSNumber numberWithInt:p_msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)sendReplay {
    msgId++;
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_REPLAY],
                                 @"id" : [NSNumber numberWithInt:msgId]};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)sendGameOverIsIWon:(BOOL)isIWon {
    msgId++;
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_GAMEOVER],
                                 @"id" : [NSNumber numberWithInt:msgId],
                                 @"isIWon": [NSNumber numberWithBool:isIWon]};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    if (isPlayerWonRemote != -1) return;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)ackGameOver:(int)p_msgId IsPlayerWon:(int)IsPlayerWon{
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ACK_GAMEOVER],
                                 @"id" : [NSNumber numberWithInt:p_msgId],
                                 @"isPlayerWon" : [NSNumber numberWithInt:IsPlayerWon]};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}


-(void)ackReplay:(int)p_msgId {
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ACK_REPLAY],
                                 @"id" : [NSNumber numberWithInt:p_msgId],};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)sendBack {
    msgId++;
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_BACK],
                                 @"id" : [NSNumber numberWithInt:msgId]};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self resetFlags];
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)sendMultiPlaySelectBack {
    msgId++;
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_MULTIPLAY_SELECT_BACK],
                                 @"id" : [NSNumber numberWithInt:msgId]};
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:choiceData forKey:ENCODE_KEY];
    [archiver finishEncoding];
    
    NSArray *allPeers = self.session.connectedPeers;
    NSError *error;
    
    [self resetFlags];
    
    [self.session sendData:data
                   toPeers:allPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

//
-(void)setStageObj:(STAStage*)p_stage {
    curStage = p_stage;
}

#pragma mark - Override property accessors

- (NSArray *)connectedPeers
{
    return self.session.connectedPeers;
}

- (NSArray *)connectingPeers
{
    return [self.connectingPeersOrderedSet array];
}

- (NSArray *)disconnectedPeers
{
    return [self.disconnectedPeersOrderedSet array];
}

- (NSArray *)discoveredPeers
{
    return [self.discoveredPeersOrderedSet array];
}

-(void)disconnect
{
    [self.session disconnect];
}

#pragma mark - Memory management

- (void)dealloc
{
    // Unregister for notifications on deallocation.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Nil out delegates
    _session.delegate = nil;
    _serviceAdvertiser.delegate = nil;
    _serviceBrowser.delegate = nil;
}
#pragma mark - Private methods

- (void)setupSession
{
    // Create the session that peers will be invited/join into.
    _session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
    
    _displayName = self.session.myPeerID.displayName;
    
    // Create the service advertiser
    _serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peerID
                                                           discoveryInfo:nil
                                                             serviceType:kMCSessionServiceType];
    self.serviceAdvertiser.delegate = self;
    
    // Create the service browser
    _serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerID
                                                       serviceType:kMCSessionServiceType];
    self.serviceBrowser.delegate = self;
}

- (void)teardownSession
{
    [self.session disconnect];
    [self.connectingPeersOrderedSet removeAllObjects];
    [self.disconnectedPeersOrderedSet removeAllObjects];
    [self.discoveredPeersOrderedSet removeAllObjects];
}

- (void)startServices
{
    [self setupSession];
    [self.serviceAdvertiser startAdvertisingPeer];
    [self.serviceBrowser startBrowsingForPeers];
}

- (void)stopServices
{
    [self.serviceBrowser stopBrowsingForPeers];
    [self.serviceAdvertiser stopAdvertisingPeer];
    [self teardownSession];
}

- (void)updateDelegate
{
    [self.delegate sessionDidChangeState];
}

- (NSString *)stringForPeerConnectionState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateConnected:
            return @"Connected";
            
        case MCSessionStateConnecting:
            return @"Connecting";
            
        case MCSessionStateNotConnected:
            return @"Not Connected";
    }
}

#pragma mark - MCSessionDelegate protocol conformance

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"Peer [%@] changed state to %@", peerID.displayName, [self stringForPeerConnectionState:state]);
    
    switch (state)
    {
        case MCSessionStateConnecting:
        {
            [self.connectingPeersOrderedSet addObject:peerID];
            [self.disconnectedPeersOrderedSet removeObject:peerID];
            break;
        }
            
        case MCSessionStateConnected:
        {
            [self.connectingPeersOrderedSet removeObject:peerID];
            [self.disconnectedPeersOrderedSet removeObject:peerID];
            break;
        }
            
        case MCSessionStateNotConnected:
        {
            [self.connectingPeersOrderedSet removeObject:peerID];
            [self.disconnectedPeersOrderedSet addObject:peerID];
            break;
        }
    }
    
    [self updateDelegate];
}

#pragma mark - MCNearbyServiceBrowserDelegate protocol conformance

// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSString *remotePeerName = peerID.displayName;
    
    NSLog(@"Browser found %@", remotePeerName);
    
    MCPeerID *myPeerID = self.session.myPeerID;
    
    BOOL shouldInvite = ([myPeerID.displayName compare:remotePeerName] != NSOrderedSame);
    
    if (shouldInvite)
    {
        NSLog(@"Inviting %@", remotePeerName);
        
        [_discoveredPeersOrderedSet addObject:peerID];
        
        //        [browser invitePeer:peerID toSession:self.session withContext:nil timeout:30.0];
    }
    else
    {
        NSLog(@"Not inviting %@", remotePeerName);
    }
    
    [self updateDelegate];
}

- (void) invitePeer:(MCPeerID *)peerID {
    [_serviceBrowser invitePeer:peerID toSession:self.session withContext:nil timeout:30.0];
    
    [self updateDelegate];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"lostPeer %@", peerID.displayName);
    
    [self.connectingPeersOrderedSet removeObject:peerID];
    [self.disconnectedPeersOrderedSet addObject:peerID];
    
    [self updateDelegate];
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"didNotStartBrowsingForPeers: %@", error);
}

#pragma mark - MCNearbyServiceAdvertiserDelegate protocol conformance

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    NSLog(@"didReceiveInvitationFromPeer %@", peerID.displayName);
    
    tempInvitationHandler = invitationHandler;
    tempRemotePeerID = peerID;
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invite"
                                                    message:@"Accept invite from?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes",nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1) {
        NSLog(@"OK Tapped. Hello World!");
        
        tempInvitationHandler(YES, self.session);
        
        [self.connectingPeersOrderedSet addObject:tempRemotePeerID];
        [self.disconnectedPeersOrderedSet removeObject:tempRemotePeerID];
        
        [self updateDelegate];
    }
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"didNotStartAdvertisingForPeers: %@", error);
}


@end
