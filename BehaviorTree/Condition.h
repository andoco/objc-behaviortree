//
//  Condition.h
//  BehaviorTree
//
//  Created by Andrew O'Connor on 24/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Task.h"

@interface Condition : Task

-(id) initWithTask:(id<Task>)task;
-(BOOL) evaluate:(NSMutableDictionary*)blackboard;

@end
