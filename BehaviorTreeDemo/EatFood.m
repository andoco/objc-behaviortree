//
//  EatFood.m
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "EatFood.h"

#import "Food.h"
#import "World.h"

@implementation EatFood

-(RunResult) run:(NSMutableDictionary *)blackboard {
    Food *food = [blackboard objectForKey:@"target"];
    
    //NSLog(@"Eating food %@", food);
    [food.view removeFromSuperview];
    [food.world.food removeObject:food];
    
    return Success;
}

@end
