//
//  ActorAction.m
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "ActorAction.h"

@implementation ActorAction

-(id) initWithActor:(Actor*)actor {
    if ((self = [super init])) {
        _actor = actor;
    }
    return self;
}

@end
