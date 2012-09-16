//
//  MoveToCollectable.h
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "ActorAction.h"

@class World;

@interface Seek : ActorAction

@property (nonatomic, assign) CGFloat rate;

@end
