//
//  Sequence.m
//  BehaviorTree
//
//  Created by Andrew O'Connor on 15/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Sequence.h"

@implementation Sequence

-(RunResult) run:(NSMutableDictionary *)blackboard {
    for (id<Task> task in self.children) {
        RunResult r = [task run:blackboard];
        if (r == Failure || r == Pending) {
            return r;
        }
    }
    
    return Success;
}

@end
