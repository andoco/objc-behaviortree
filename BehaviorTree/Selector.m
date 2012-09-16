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

-(RunResult) run:(NSMutableDictionary *)blackboard {
    for (id<Task> task in self.children) {
        RunResult r = [task run:blackboard];
        
        if (r == Success || r == Pending) {
            if (running_)
                [running_ stop];
            
            if (r == Pending)
                running_ = task;
            
            return r;
        }        
    }
    
    return Failure;
}

@end
