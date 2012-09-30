//
//  Concurrent.m
//  BehaviorTree
//
//  Created by Andrew O'Connor on 23/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Concurrent.h"

@interface Concurrent () {
    id<Task> running_;
}

@end

@implementation Concurrent

-(id) initWithLimit:(NSInteger)limit
{
    self = [super init];
    if (self) {
        _failureLimit = limit;
    }
    return self;
}

-(void) start:(NSMutableDictionary*)blackboard {
    [super start:blackboard];
    _numFailed = 0;
}

-(void) didReceiveResult:(RunResult)result forTask:(id<Task>)task withBlackboard:(NSMutableDictionary*)blackboard {
    if (result == Failure)
        _numFailed++;
    
    running_ = result == Pending ? task : nil;
}

-(RunResult) defaultReturnResult {
    if (running_)
        return Pending;
    
    return _failureLimit == 0 || _numFailed < _failureLimit ? Success : Failure;
}

@end
