//
//  CompositeTask.m
//  BehaviorTree
//
//  Created by Andrew O'Connor on 15/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "CompositeTask.h"

@implementation CompositeTask

@synthesize status;

- (id)init
{
    self = [super init];
    if (self) {
        _children = [NSMutableArray array];
    }
    return self;
}

-(RunResult) run:(NSDictionary *)blackboard {
    return Success;
}

-(void) stop {
    
}

-(void) addChild:(id<Task>)child {
    _children = [_children arrayByAddingObject:child];
}

@end
