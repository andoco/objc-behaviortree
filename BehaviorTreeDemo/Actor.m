//
//  Actor.m
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Actor.h"

#import "Task.h"

@implementation Actor

- (id)init
{
    self = [super init];
    if (self) {
        _color = [UIColor greenColor];
    }
    return self;
}

-(void) setPosition:(CGPoint)position {
    _position = position;
    self.view.frame = CGRectMake(position.x, position.y, self.view.frame.size.width, self.view.frame.size.width);
}

-(void) update {
    [_root run:[NSMutableDictionary dictionary]];
}

@end
