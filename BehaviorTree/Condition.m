//
//  Condition.m
//  BehaviorTree
//
//  Created by Andrew O'Connor on 24/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Condition.h"

@implementation Condition {
    id<Task> task_;
}

-(id) initWithTask:(id<Task>)task
{
    self = [super init];
    if (self) {
        task_ = task;
    }
    return self;
}

-(void) start {
    [super start];
    [task_ start];
}

-(void) stop {
    [super stop];
    [task_ stop];
}

-(RunResult) run:(NSMutableDictionary *)blackboard {
    if (![self evaluate:blackboard])
        return Failure;
    
    return [task_ run:blackboard];
}

-(BOOL) evaluate:(NSMutableDictionary*)blackboard {
    return YES;
}

@end
