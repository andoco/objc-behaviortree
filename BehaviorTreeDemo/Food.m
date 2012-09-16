//
//  Collectable.m
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Food.h"

@implementation Food

- (id)init
{
    self = [super init];
    if (self) {
        self.color = [UIColor greenColor];
    }
    return self;
}

@end
