//
//  Action.m
//  BehaviorTree
//
//  Created by Andrew O'Connor on 15/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Action.h"

@implementation Action

@synthesize status;

-(RunResult) run:(NSDictionary *)blackboard {
    return Success;
}

-(void) stop {
    
}

@end
