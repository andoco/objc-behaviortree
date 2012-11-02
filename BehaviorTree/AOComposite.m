/*
 * objc-behaviortree: http://github.com/andoco/objc-behaviortree
 *
 * Copyright (c) 2012 Andrew O'Connor
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "AOComposite.h"

@implementation AOComposite

- (id)init
{
    self = [super init];
    if (self) {
        _children = [NSMutableArray array];
    }
    return self;
}

-(id) initWithChildren:(id<AOTask>)firstArg, ...
{
    self = [self init];
    if (self) {
        va_list args;
        va_start(args, firstArg);
        for (id<AOTask> arg = firstArg; arg != nil; arg = va_arg(args, id<AOTask>))
        {
            [self addChild:arg];
        }
        va_end(args);
    }
    return self;
}

-(RunResult) run:(NSMutableDictionary *)blackboard {
    [super run:blackboard];
    
    for (id<AOTask> task in self.children) {
        DLog(@"Processing child %@", task);
        
        if (task.status == Ready)
            [task start:blackboard];
        
        RunResult r = [task run:blackboard];
        DLog(@"Child %@ returned result %d", task, r);
        
        switch (r) {
            case Pending:
                task.status = Running;
                break;
            case Success:
            case Failure:
                [task stop:blackboard];
                task.status = Ready;
                break;
            default:
                break;
        }
                
        [self didReceiveResult:r forTask:task withBlackboard:blackboard];
        
        RunResult returnResult;
        if ([self shouldReturnWithResult:r returnResult:&returnResult])
            return returnResult;
    }
    
    return [self defaultReturnResult];
}

-(void) addChild:(id<AOTask>)child {
    _children = [_children arrayByAddingObject:child];
}

-(void) didReceiveResult:(RunResult)result forTask:(id<AOTask>)task withBlackboard:(NSMutableDictionary*)blackboard {
    
}

-(BOOL) shouldReturnWithResult:(RunResult)result returnResult:(RunResult*)returnResult {
    return NO;
}

-(RunResult) defaultReturnResult {
    return Success;
}

@end
