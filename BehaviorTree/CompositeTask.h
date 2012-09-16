//
//  CompositeTask.h
//  BehaviorTree
//
//  Created by Andrew O'Connor on 15/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Task.h"

@interface CompositeTask : NSObject <Task>

@property (nonatomic, readonly) NSArray *children;

-(void) addChild:(id<Task>)child;

@end
