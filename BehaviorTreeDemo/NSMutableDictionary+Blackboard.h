//
//  NSMutableDictionary+Blackboard.h
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/11/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Actor;
@class World;

@interface NSMutableDictionary (Blackboard)

@property (nonatomic, weak) World *world;
@property (nonatomic, weak) Actor *actor;

@end
