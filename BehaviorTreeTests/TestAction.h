//
//  TestAction.h
//  BehaviorTree
//
//  Created by Andrew O'Connor on 13/10/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Action.h"

@interface TestAction : Action

@property (nonatomic, strong) NSString *stringProperty;
@property (nonatomic, assign) NSInteger intProperty;
@property (nonatomic, assign) BOOL boolProperty;
@property (nonatomic, strong) Class classProperty;

@end
