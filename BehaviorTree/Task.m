//
//  Task.m
//  BehaviorTree
//
//  Created by Andrew O'Connor on 24/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Task.h"

@implementation Task

@synthesize status;

-(void) start:(NSMutableDictionary*)blackboard {
    DLog(@"Starting %@", self);
}

-(RunResult) run:(NSMutableDictionary*)blackboard {
    DLog(@"Running %@", self);
    return Success;
}

-(void) stop:(NSMutableDictionary*)blackboard {
    DLog(@"Stopping %@", self);    
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<%@: %p, status=%d>", NSStringFromClass(self.class), self, self.status];
}

@end
