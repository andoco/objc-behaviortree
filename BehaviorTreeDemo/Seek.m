//
//  MoveToCollectable.m
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Seek.h"

#import "Food.h"
#import "World.h"

@implementation Seek

- (id)initWithActor:(Actor *)actor
{
    self = [super initWithActor:actor];
    if (self) {
        _rate = 0.1;
    }
    return self;
}

-(RunResult) run:(NSMutableDictionary *)blackboard {
    Actor *target = [blackboard objectForKey:@"target"];
    
    if (!target)
        return Failure;
    
    NSLog(@"Moving to target %@", target);
        
    CGPoint offset = CGPointSubtract(target.position, self.actor.position);
    
    if (CGPointMagnitude(offset) < 10)
        return Success;
    
    CGPoint v = CGPointScale(CGPointNormalize(offset), self.actor.speed);
    
    self.actor.position = CGPointAdd(self.actor.position, v);
    
    return Failure;
}

@end
