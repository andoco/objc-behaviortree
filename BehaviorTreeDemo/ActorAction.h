//
//  ActorAction.h
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Action.h"
#import "Actor.h"
#import "World.h"

@interface ActorAction : Action

@property (nonatomic, readonly) Actor *actor;
-(id) initWithActor:(Actor*)actor;

@end
