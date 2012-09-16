//
//  PredatorDetected.m
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "PredatorDetected.h"

#import "Predator.h"

@implementation PredatorDetected

-(RunResult) run:(NSMutableDictionary *)blackboard {
    CGPoint p = self.actor.position;
    Predator *predator = self.actor.world.predator;
    
    if (CGPointMagnitude(CGPointSubtract(predator.position, p)) <= 50) {
        NSLog(@"Predator detected");
        [blackboard setObject:predator forKey:@"target"];
        return Success;
    }
    
    return Failure;
}

@end
