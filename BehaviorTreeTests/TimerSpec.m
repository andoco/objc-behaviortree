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

#import "Kiwi.h"

#import "AOTask.h"
#import "AOTimer.h"

SPEC_BEGIN(TimerSpec)

describe(@"Timer", ^{
    
    __block AOTimer *task;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        task = [[AOTimer alloc] initWithTaskId:@"1"];
        task.time = 1;
        blackboard = [NSMutableDictionary dictionary];
    });
    
    context(@"when started", ^{
        it(@"should set currentTime to 0 in blackboard", ^{
            [task start:blackboard];
            id val = blackboard[AOTimerCurrentTimeBlackboardKey];
            [[val shouldNot] beNil];
            [[theValue([val floatValue]) should] equal:theValue(0.0)];
        });
    });
        
    context(@"when currentTime less than time", ^{
        beforeEach(^{
            blackboard[AOTimerCurrentTimeBlackboardKey] = [NSNumber numberWithFloat:0];
        });
        it(@"willStart should return NO", ^{
            [[theValue([task willStart:blackboard]) should] equal:theValue(NO)];
        });
        it(@"willRun should return NO", ^{
            [[theValue([task willRun:blackboard]) should] equal:theValue(NO)];
        });
        it(@"willStop should return NO", ^{
            [[theValue([task willStop:blackboard]) should] equal:theValue(NO)];
        });
        it(@"evaluateResult should return Pending", ^{
            [[theValue([task evaluateResult:AOResultSuccess withBlackboard:blackboard andDidRun:NO]) should] equal:theValue(AOResultPending)];
        });
        it(@"evaluateResult should add delta time to current time in blackboard", ^{
            blackboard[task.deltaKey] = [NSNumber numberWithFloat:0.5];
            [task evaluateResult:AOResultSuccess withBlackboard:blackboard andDidRun:NO];
            [[theValue([blackboard[AOTimerCurrentTimeBlackboardKey] floatValue]) should] equal:theValue(0.5)];
        });
    });
    
    context(@"when currentTime greater or equal to time", ^{
        beforeEach(^{
            blackboard[AOTimerCurrentTimeBlackboardKey] = [NSNumber numberWithFloat:1];
        });
        it(@"willStart should return YES", ^{
            [[theValue([task willStart:blackboard]) should] equal:theValue(YES)];
        });
        it(@"willRun should return YES", ^{
            [[theValue([task willRun:blackboard]) should] equal:theValue(YES)];
        });
        it(@"willStop should return YES", ^{
            [[theValue([task willStop:blackboard]) should] equal:theValue(YES)];
        });
        it(@"evaluateResult should return decorated task result", ^{
            AOResult decoratedTaskResult = AOResultFailure;
            [[theValue([task evaluateResult:decoratedTaskResult withBlackboard:blackboard andDidRun:YES]) should] equal:theValue(decoratedTaskResult)];
        });
    });
});

SPEC_END