//
//  Sequence.m
//  BehaviorTree
//
//  Created by Andrew O'Connor on 15/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Sequence.h"

@interface Sequence () {
    id<Task> running_;
}

@end

@implementation Sequence

-(void) didReceiveResult:(RunResult)result forTask:(id<Task>)task {
    if (result == Failure || result == Pending) {
        if (running_)
            [running_ stop];
        
        if (result == Pending)
            running_ = task;
        else
            running_ = nil;
    }
}

-(BOOL) shouldReturnWithResult:(RunResult)result returnResult:(RunResult*)returnResult {
    if (result == Failure || result == Pending) {
        *returnResult = result;
        return YES;
    }
    
    return NO;
}

-(RunResult) defaultReturnResult {
    return Success;
}

@end
