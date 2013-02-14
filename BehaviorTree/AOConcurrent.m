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

#import "AOConcurrent.h"

@interface AOConcurrent () {
    NSMutableSet *running_;
}

@end

@implementation AOConcurrent

- (id)init
{
    self = [super init];
    if (self) {
        _failureLimit = 0;
        running_ = [NSMutableSet set];        
    }
    return self;
}

-(id) initWithLimit:(NSInteger)limit
{
    self = [self init];
    if (self) {
        _failureLimit = limit;
        running_ = [NSMutableSet set];
    }
    return self;
}

-(void) start:(id)blackboard {
    [super start:blackboard];
    [running_ removeAllObjects];
    _numFailed = 0;
}

-(void) didReceiveResult:(AOResult)result forTask:(id<AOTask>)task withBlackboard:(id)blackboard {
    if (result == AOResultFailure)
        _numFailed++;
    
    if (result == AOResultSuccess || result == AOResultFailure)
        [running_ removeObject:task];
    else if (result == AOResultPending)
        [running_ addObject:task];
}

-(AOResult) defaultReturnResult {
    if (running_.count > 0)
        return AOResultPending;
    
    return _failureLimit == 0 || _numFailed < _failureLimit ? AOResultSuccess : AOResultFailure;
}

@end
