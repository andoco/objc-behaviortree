//
//  BehaviorTree.m
//  BehaviorTree
//
//  Created by Andrew O'Connor on 15/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "BehaviorTree.h"

@implementation BehaviorTree

-(id) initWithRootTask:(id<Task>)root
{
    self = [super init];
    if (self) {
        root_ = root;
    }
    return self;
}

-(void) run {
    [root_ start];
    [root_ run:[NSMutableDictionary dictionary]];
    [root_ stop];
}

@end
