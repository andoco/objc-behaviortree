//
//  Target.m
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "TargetFood.h"

#import "Food.h"

@implementation TargetFood

-(RunResult) run:(NSMutableDictionary*)blackboard {
    if (self.actor.world.food.count == 0)
        return Failure;
    
    Food *food = [self.actor.world.food objectAtIndex:0];
    [blackboard setObject:food forKey:@"target"];
    
    return Success;
}

@end
