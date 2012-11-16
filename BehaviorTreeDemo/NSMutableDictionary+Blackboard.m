//
//  NSMutableDictionary+Blackboard.m
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/11/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "NSMutableDictionary+Blackboard.h"

@implementation NSMutableDictionary (Blackboard)

-(void) setWorld:(World *)world {
    [self setObject:world forKey:@"world"];
}

-(World*) world {
    return [self objectForKey:@"world"];
}

-(void) setActor:(Actor*)actor {
    [self setObject:actor forKey:@"actor"];
}

-(Actor*) actor {
    return [self objectForKey:@"actor"];
}

@end
