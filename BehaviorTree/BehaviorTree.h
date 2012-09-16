//
//  BehaviorTree.h
//  BehaviorTree
//
//  Created by Andrew O'Connor on 15/09/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Action.h"
#import "Selector.h"
#import "Sequence.h"

@interface BehaviorTree : NSObject {
    @private
    id<Task> root_;
}

-(id) initWithRootTask:(id<Task>)root;
-(void) run;

@end
