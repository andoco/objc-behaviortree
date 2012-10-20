//
//  Concurrent.h
//  BehaviorTree
//
//  Created by Andrew O'Connor on 23/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "Composite.h"

@interface Concurrent : Composite

@property (nonatomic, assign) NSInteger failureLimit;
@property (nonatomic, readonly) NSInteger numFailed;

-(id) initWithLimit:(NSInteger)limit;

@end
