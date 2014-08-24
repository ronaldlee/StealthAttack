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
    
    int myColorId;
    int myTankId;
    BOOL isAckColor;
    BOOL isAckTank;
    
    BOOL isReadyBattleStage;
    BOOL isAckReadyBattleStage;
    BOOL isOppReadyBattleStage;
    //
    
    BOOL isBattleStageUIReady;
    BOOL isAckBattleStageUIReady;
    BOOL isOppBattleStageUIReady;
    
    STATank* oppTank;
    
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
        
        isAckColor = false;
        isAckTank = false;
        
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
    isAckColor = FALSE;
    isAckTank = FALSE;
    
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
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *myDictionary = [unarchiver decodeObjectForKey:ENCODE_KEY];
    [unarchiver finishDecoding];
    
    NSNumber* actionId = (NSNumber*)[myDictionary objectForKey:@"action"];
    int actionIdInt = [actionId intValue];
    
    if (stage == MULTIPLAY_STAGE_CHOOSE_TANK) {
        if (actionIdInt == ACTION_SUBMIT_CHOICE) {
            NSNumber* oppColorIdNum = (NSNumber*)[myDictionary objectForKey:@"color"];
            oppColorId = [oppColorIdNum intValue];
            
            NSNumber* oppTankIdNum = (NSNumber*)[myDictionary objectForKey:@"tank"];
            oppTankId = [oppTankIdNum intValue];
            
            NSNumber* oppMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int oppMsgId = [oppTankIdNum intValue];
            
            [self ackPlayerChoiceTank:oppTankId Color:oppColorId MsgId:oppMsgId];
            
            if ([self isStageChooseTankReady]) {
                [self sendReadyBattleStage];
            }
        }
        else if (actionIdInt == ACTION_ACK_CHOICE) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            if (ackMsgId == msgId) {
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
                
                if ([self isStageChooseTankReady]) {
                    [self sendReadyBattleStage];
                }
            }
            else {
                //ack msg id not match!
            }
        }
        else if (actionIdInt == ACTION_SEND_READY_BATTLE_STAGE) {
            NSNumber* ackMsgIdNum = (NSNumber*)[myDictionary objectForKey:@"id"];
            int ackMsgId = [ackMsgIdNum intValue];
            
            isOppReadyBattleStage = TRUE;
            [self ackReadyBattleStage:ackMsgId];
            
            if ([self isStageBattleReady]) {
                //go to Battle Stage
                stage = MULTIPLAY_STAGE_BATTLE;
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
            }
        }
    }
    else if (stage == MULTIPLAY_STAGE_BATTLE_START) {
        //opp tank's actions
    }
    
}

-(BOOL)isStageBattleStageUIReady {
    return isOppBattleStageUIReady && isAckBattleStageUIReady;
}

-(BOOL)isStageBattleReady{
    return isOppReadyBattleStage && isAckReadyBattleStage;
}

-(BOOL)isStageChooseTankReady {
    return oppColorId != 0 && oppTankId != 0 && myColorId != 0 && myTankId != 0 && isAckColor && isAckTank;
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

//===


-(void)submitPlayerChoiceTank:(int)tankId Color:(int)colorId {
    myTankId = tankId;
    myColorId = colorId;
    msgId++;
    
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_SUBMIT_CHOICE],
                                @"tank" : [NSNumber numberWithInt:myTankId],
                                @"color" : [NSNumber numberWithInt:myColorId],
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

-(void)ackPlayerChoiceTank:(int)tankId Color:(int)colorId MsgId:(int)p_msgId {
    
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ACK_CHOICE],
                                 @"tank" : [NSNumber numberWithInt:myTankId],
                                 @"color" : [NSNumber numberWithInt:myColorId],
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

@end
