//
//  BehaviorTree.h
//  BehaviorTree
//
//  Created by Andrew O'Connor on 15/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Action.h"
#import "Concurrent.h"
#import "Condition.h"
#import "Selector.h"
#import "Sequence.h"

@interface BehaviorTree : NSObject

@property (nonatomic, readonly) id<Task> root;

-(id) initWithRootTask:(id<Task>)root;
-(void) run;
-(void) runWithBlackboard:(NSMutableDictionary*)blackboard;

@end
