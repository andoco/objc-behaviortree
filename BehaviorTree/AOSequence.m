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

#import "AOSequence.h"

@interface AOSequence () {
    id<AOTask> running_;
}

@end

@implementation AOSequence

-(void) didReceiveResult:(AOResult)result forTask:(id<AOTask>)task withBlackboard:(id)blackboard {
    if (result == AOResultFailure || result == AOResultPending) {
        if (running_ && running_ != task) {
            [running_ stop:(id)blackboard];
            running_.status = AOStatusReady;
        }
        
        if (result == AOResultPending)
            running_ = task;
        else
            running_ = nil;
    }
}

-(BOOL) shouldReturnWithResult:(AOResult)result returnResult:(AOResult*)returnResult {
    if (result == AOResultFailure || result == AOResultPending) {
        *returnResult = result;
        return YES;
    }
    
    return NO;
}

-(AOResult) defaultReturnResult {
    return AOResultSuccess;
}

@end
