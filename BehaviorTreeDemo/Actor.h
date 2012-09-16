//
//  Actor.h
//  BehaviorTreeDemo
//
//  Created by Andrew O'Connor on 16/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Task;
@class World;

@interface Actor : NSObject

@property (nonatomic, strong) World *world;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) UIColor *color;
@property (nonatomic, strong) id<Task> root;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign) CGFloat speed;

-(void) update;

@end
