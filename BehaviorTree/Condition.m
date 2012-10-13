//
//  Condition.m
//  BehaviorTree
//
//  Created by Andrew O'Connor on 24/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Condition.h"

@implementation Condition

-(id) initWithTask:(id<Task>)task
{
    self = [super init];
    if (self) {
        _task = task;
    }
    return self;
}

-(void) start:(NSMutableDictionary*)blackboard {
    [super start:blackboard];
    [_task start:blackboard];
}

-(void) stop:(NSMutableDictionary*)blackboard {
    [super stop:blackboard];
    [_task stop:blackboard];
}

-(RunResult) run:(NSMutableDictionary *)blackboard {
    if (![self evaluate:blackboard])
        return Failure;
    
    return [_task run:blackboard];
}

-(BOOL) evaluate:(NSMutableDictionary*)blackboard {
    return YES;
}

@end
