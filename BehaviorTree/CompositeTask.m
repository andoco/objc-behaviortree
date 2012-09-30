//
//  CompositeTask.m
//  BehaviorTree
//
//  Created by Andrew O'Connor on 15/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "CompositeTask.h"

@implementation CompositeTask

- (id)init
{
    self = [super init];
    if (self) {
        _children = [NSMutableArray array];
    }
    return self;
}

-(id) initWithChildren:(id<Task>)firstArg, ...
{
    self = [self init];
    if (self) {
        va_list args;
        va_start(args, firstArg);
        for (id<Task> arg = firstArg; arg != nil; arg = va_arg(args, id<Task>))
        {
            [self addChild:arg];
        }
        va_end(args);
    }
    return self;
}

-(RunResult) run:(NSMutableDictionary *)blackboard {
    for (id<Task> task in self.children) {
        if (task.status == Ready)
            [task start:blackboard];
        
        RunResult r = [task run:blackboard];
        
        if (r == Success || r == Failure)
            [task stop:blackboard];
        
        [self didReceiveResult:r forTask:task withBlackboard:blackboard];
        
        RunResult returnResult;
        if ([self shouldReturnWithResult:r returnResult:&returnResult])
            return returnResult;
    }
    
    return [self defaultReturnResult];
}

-(void) addChild:(id<Task>)child {
    _children = [_children arrayByAddingObject:child];
}

-(void) didReceiveResult:(RunResult)result forTask:(id<Task>)task withBlackboard:(NSMutableDictionary*)blackboard {
    
}

-(BOOL) shouldReturnWithResult:(RunResult)result returnResult:(RunResult*)returnResult {
    return NO;
}

-(RunResult) defaultReturnResult {
    return Success;
}

@end
