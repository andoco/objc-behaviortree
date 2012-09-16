//
//  Task.h
//  BehaviorTree
//
//  Created by Andrew O'Connor on 15/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Ready,
    Running
} TaskStatus;

typedef enum {
    Success,
    Failure,
    Pending
} RunResult;

@protocol Task <NSObject>

@property (nonatomic, readonly) TaskStatus status;

-(RunResult) run:(NSMutableDictionary*)blackboard;
-(void) stop;

@end
