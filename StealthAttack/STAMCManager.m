//
//  STAMCManager.m
//  StealthAttack
//
//  Created by Ronald Lee on 8/18/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "STAMCManager.h"

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
    
    STATank* oppTank;
    
    STAStage* curStage;
    
}
@end

@implementation STAMCManager
-(id)init {
    self = [super init];
    
    if (self) {
        _peerID = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
        
        [self reset];
    }
    
    return self;
}

-(void)setOppTank:(STATank*)tank {
    oppTank = tank;
}

-(void) reset {
    [self resetStage];
    oppColorId = 0;
    oppTankId = 0;
    
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
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
}

-(void)setupMCBrowser{
    _browser = [[MCBrowserViewController alloc] initWithServiceType:@"chat-files" session:_session];
}

-(void)advertiseSelf:(BOOL)shouldAdvertise{
    if (shouldAdvertise) {
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat-files"
                                                           discoveryInfo:nil
                                                                 session:_session];
        [_advertiser start];
    }
    else{
        [_advertiser stop];
        _advertiser = nil;
    }
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSDictionary *dict = @{@"peerID": peerID,
                           @"state" : [NSNumber numberWithInt:state]
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSLog(@"didReceiveData");
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *myDictionary = [unarchiver decodeObjectForKey:ENCODE_KEY];
    [unarchiver finishDecoding];
    
    NSNumber* actionId = (NSNumber*)[myDictionary objectForKey:@"action"];
    int actionIdInt = [actionId intValue];
    NSLog(@"didReceiveData: stage: %d, actionId: %d",stage,actionIdInt);
    
    if (stage == MULTIPLAY_STAGE_CHOOSE_TANK) {
        if (actionIdInt == ACTION_SUBMIT_CHOICE) {
            NSLog(@"action submit choice");
            NSNumber* oppColorIdNum = (NSNumber*)[myDictionary objectForKey:@"color"];
            oppColorId = [oppColorIdNum intValue];
            
            NSNumber* oppTankIdNum = (NSNumber*)[myDictionary objectForKey:@"tank"];
            oppTankId = [oppTankIdNum intValue];
            
            NSNumber* oppScaleNum = (NSNumber*)[myDictionary objectForKey:@"scale"];
            oppScale = [oppScaleNum doubleValue];
            
//            NSNumber* oppMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
//            int oppMsgId = [oppMsgIdNum intValue];
            
            [self ackPlayerChoiceTank:oppTankId Color:oppColorId Scale:oppScale MsgId:[[myDictionary objectForKey:@"id"] intValue]];
            
            if ([self isStageChooseTankReady]) {
                [self sendReadyBattleStage];
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
            
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            isOppReadyBattleStage = TRUE;
            [self ackReadyBattleStage:ackMsgId];
            
            if ([self isStageBattleReady]) {
                NSLog(@"action send ready battle stage: battle ready");
                
                //go to Battle Stage
                stage = MULTIPLAY_STAGE_BATTLE;
                
                STAMultiPlayerSelect* mstage = (STAMultiPlayerSelect*)curStage;
                [mstage goToBattleStageMyTank:myTankId MyColor:myColorId MyScale:myScale
                                    OppTankId:oppTankId OppColor:oppColorId OppScale:oppScale];
            }
        }
        else if (actionIdInt == ACTION_ACK_READY_BATTLE_STAGE) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            if (ackMsgId == msgId) {
                isAckReadyBattleStage = TRUE;
            }
            
            if ([self isStageBattleReady]) {
                //go to Battle Stage
                stage = MULTIPLAY_STAGE_BATTLE;
                STAMultiPlayerSelect* mstage = (STAMultiPlayerSelect*)curStage;
                [mstage goToBattleStageMyTank:myTankId MyColor:myColorId MyScale:myScale
                                    OppTankId:oppTankId OppColor:oppColorId OppScale:oppScale];
            }
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
            
            if (ackMsgId == msgId) {
                isAckBattleStageUIReady = TRUE;
            }
            
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
            [mstage enemyForward];
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
            NSLog(@"adj");
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            NSNumber* xNum = (NSNumber*)[myDictionary objectForKey:@"x"];
            CGFloat x = [xNum floatValue];
            NSNumber* yNum = (NSNumber*)[myDictionary objectForKey:@"y"];
            CGFloat y = [yNum floatValue];
            NSNumber* rNum = (NSNumber*)[myDictionary objectForKey:@"r"];
            CGFloat r = [rNum floatValue];
            
            [mstage adjEnemyX:x Y:y R:r];
        }
    }
    
}

-(BOOL)isStageBattleStageUIReady {
    return isOppBattleStageUIReady && isAckBattleStageUIReady;
}

-(BOOL)isStageBattleReady{
    return isOppReadyBattleStage && isAckReadyBattleStage;
}

-(BOOL)isStageChooseTankReady {
    return oppColorId != 0 && oppTankId != 0 && myColorId != 0 && myTankId != 0 && oppScale != 0.0 && myScale != 0.0 &&
            isAckColor && isAckTank && isAckScale;
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

//===


-(void)submitPlayerChoiceTank:(int)tankId Color:(int)colorId Scale:(double)scale {
    myTankId = tankId;
    myColorId = colorId;
    myScale = scale;
    msgId++;
    
    NSLog(@"submitPlayerChoiceTank");
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_SUBMIT_CHOICE],
                                @"tank" : [NSNumber numberWithInt:myTankId],
                                @"color" : [NSNumber numberWithInt:myColorId],
                                @"scale" : [NSNumber numberWithDouble:myScale],
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

//
-(void)setStageObj:(STAStage*)p_stage {
    curStage = p_stage;
}


@end
