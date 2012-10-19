//
//  Flee.m
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Flee.h"

@implementation Flee

-(RunResult) run:(NSMutableDictionary *)blackboard {
    Actor *target = [blackboard objectForKey:@"target"];
        
    //NSLog(@"Fleeing target %@", target);
    
    CGPoint offset = CGPointSubtract(target.position, self.actor.position);
        
    CGPoint v = CGPointScale(CGPointNormalize(offset), -self.actor.speed);
    
    self.actor.position = CGPointAdd(self.actor.position, v);
    
    return Success;
}

@end
