//
//  TargetPrey.m
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "TargetPrey.h"

#import "Prey.h"

@implementation TargetPrey

-(RunResult) run:(NSMutableDictionary*)blackboard {
    Prey *target = self.actor.world.prey;
    [blackboard setObject:target forKey:@"target"];
    
    return Success;
}

@end
