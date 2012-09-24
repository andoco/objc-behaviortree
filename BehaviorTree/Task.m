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

-(void) start {
    
}

-(RunResult) run:(NSMutableDictionary*)blackboard {
    return Success;
}

-(void) stop {
    
}

@end
