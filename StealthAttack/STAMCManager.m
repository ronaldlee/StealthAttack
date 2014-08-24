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
    
    int oppColorId;
    int oppTankId;
    
    int myColorId;
    int myTankId;
    BOOL isAckColor;
    BOOL isAckTank;
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
    }
    
    return self;
}

-(void) reset {
    [self resetStage];
    oppColorId = 0;
    oppTankId = 0;
    
    myColorId = 0;
    myTankId = 0;
    isAckColor = FALSE;
    isAckTank = FALSE;
}

-(void)resetStage {
    stage = 0;
}

-(void)setStage:(int)p_stage {
    stage = p_stage;
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
    
    if (stage == MULTIPLAY_STAGE_CHOOSE_TANK && ![self isStageChooseTankReady]) {
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *myDictionary = [unarchiver decodeObjectForKey:ENCODE_KEY];
        [unarchiver finishDecoding];
        
        NSNumber* actionId = (NSNumber*)[myDictionary objectForKey:@"action"];
        int actionIdInt = [actionId intValue];
        
        if (actionIdInt == ACTION_SUBMIT_CHOICE) {
            NSNumber* oppColorIdNum = (NSNumber*)[myDictionary objectForKey:@"color"];
            oppColorId = [oppColorIdNum intValue];
            
            NSNumber* oppTankIdNum = (NSNumber*)[myDictionary objectForKey:@"tank"];
            oppTankId = [oppTankIdNum intValue];
            
            [self ackPlayerChoiceTank:oppTankId Color:oppColorId];
        }
        else if (actionIdInt == ACTION_ACK_CHOICE) {
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
        }
    }
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
    
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_SUBMIT_CHOICE],
                                @"tank" : [NSNumber numberWithInt:myTankId],
                                @"color" : [NSNumber numberWithInt:myColorId],};
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

-(void)ackPlayerChoiceTank:(int)tankId Color:(int)colorId {
    myTankId = tankId;
    myColorId = colorId;
    
    NSDictionary* choiceData = @{@"action" : [NSNumber numberWithInt:ACTION_ACK_CHOICE],
                                 @"tank" : [NSNumber numberWithInt:myTankId],
                                 @"color" : [NSNumber numberWithInt:myColorId],};
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
