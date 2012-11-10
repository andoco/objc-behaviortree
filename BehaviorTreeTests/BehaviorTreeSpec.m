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
#import "AOBehaviorTree.h"

SPEC_BEGIN(BehaviorTreeSpec)

describe(@"BehaviorTree", ^{
    __block AOBehaviorTree *tree;
    __block id task;
    
    beforeEach(^{
        task = [KWMock nullMockForProtocol:@protocol(AOTask)];
        tree = [[AOBehaviorTree alloc] initWithRootTask:task];
    });
    
    context(@"when run without blackboard", ^{
        
        it(@"should run root task with empty blackboard", ^{
            [[task stubAndReturn:theValue(AOStatusReady)] status];
            [[task should] receive:@selector(run:)];
            [tree run];
        });
        
    });

    context(@"when run", ^{
        __block NSMutableDictionary *blackboard;
        
        beforeEach(^{
            blackboard = [NSMutableDictionary dictionary];
        });

        it(@"should start root task if task status is Ready", ^{
            [[task stubAndReturn:theValue(AOStatusReady)] status];
            [[task should] receive:@selector(start:) withArguments:blackboard];
            [tree runWithBlackboard:blackboard];
        });
        
        it(@"should not start root task if task status is Running", ^{
            [[task stubAndReturn:theValue(AOStatusRunning)] status];
            [[task shouldNot] receive:@selector(start:) withArguments:blackboard];
            [tree runWithBlackboard:blackboard];
        });
        
        it(@"should run root task", ^{
            [[task should] receive:@selector(run:) withArguments:blackboard];
            [tree runWithBlackboard:blackboard];
        });
        
        context(@"and result is Success", ^{
                        
            beforeEach(^{
                [[task stubAndReturn:theValue(AOResultSuccess)] run:blackboard];
            });
            
            it(@"should stop root task", ^{
                [[task should] receive:@selector(stop:) withArguments:blackboard];
                [tree runWithBlackboard:blackboard];
            });
            
            it(@"should change root task status to Ready", ^{
                [[task should] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];
                [tree runWithBlackboard:blackboard];
            });

        });
        
        context(@"and result is Failure", ^{
            
            beforeEach(^{
                [[task stubAndReturn:theValue(AOResultFailure)] run:blackboard];
            });
            
            it(@"should stop root task", ^{
                [[task should] receive:@selector(stop:) withArguments:blackboard];
                [tree runWithBlackboard:blackboard];
            });
            
            it(@"should change root task status to Ready", ^{
                [[task should] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];
                [tree runWithBlackboard:blackboard];
            });
            
        });

        context(@"and result is Pending", ^{
            
            beforeEach(^{
                [[task stubAndReturn:theValue(AOResultPending)] run:blackboard];
            });
            
            it(@"should not stop root task", ^{
                [[task shouldNot] receive:@selector(stop:) withArguments:blackboard];
                [tree runWithBlackboard:blackboard];
            });
            
            it(@"should change root task status to Running", ^{
                [[task should] receive:@selector(setStatus:) withArguments:theValue(AOStatusRunning)];
                [tree runWithBlackboard:blackboard];
            });
            
        });
        
    });
    
});

SPEC_END