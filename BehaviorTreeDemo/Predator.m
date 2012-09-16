//
//  Predator.m
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Predator.h"

#import "BehaviorTree.h"
#import "Seek.h"
#import "TargetPrey.h"

@implementation Predator

- (id)init
{
    self = [super init];
    if (self) {
        self.color = [UIColor redColor];
        self.speed = 1;
                
        id hunt = [[Sequence alloc] init];
        [hunt addChild:[[TargetPrey alloc] initWithActor:self]];
        [hunt addChild:[[Seek alloc] initWithActor:self]];
        
        self.root = hunt;

    }
    return self;
}

@end
