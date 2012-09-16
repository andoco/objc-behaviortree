//
//  Selector.m
//  BehaviorTree
//
//  Created by Andrew O'Connor on 15/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Selector.h"

@interface Selector () {
    id<Task> running_;
}

@end

@implementation Selector

-(void) didReceiveResult:(RunResult)result forTask:(id<Task>)task {
    if (result == Success || result == Pending) {
        if (running_)
            [running_ stop];
        
        if (result == Pending)
            running_ = task;
        else
            running_ = nil;
    }
}

-(BOOL) shouldReturnWithResult:(RunResult)result returnResult:(RunResult*)returnResult {
    if (result == Success || result == Pending) {
        *returnResult = result;
        return YES;
    }
    
    return NO;
}

-(RunResult) defaultReturnResult {
    return Failure;
}

@end
