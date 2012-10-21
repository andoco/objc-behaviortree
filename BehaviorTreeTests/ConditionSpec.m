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

#import "Condition.h"
#import "Task.h"

SPEC_BEGIN(ConditionSpec)

describe(@"Condition", ^{
    __block Condition *condition;
    __block id task;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        task = [KWMock nullMockForProtocol:@protocol(Task)];
        condition = [[Condition alloc] initWithTask:task];
    });
    
    context(@"when started", ^{
        
        it(@"should not start task", ^{
            [[task shouldNot] receive:@selector(start:)];
            [condition start:blackboard];
        });
        
    });
    
    context(@"when stopped", ^{
        
        it(@"should not stop task if task is not Running", ^{
            [[task should] receive:@selector(status) andReturn:theValue(Ready)];
            [[task shouldNot] receive:@selector(stop:)];
            [condition stop:blackboard];
        });

        it(@"should stop task if task is Running", ^{
            [[task should] receive:@selector(status) andReturn:theValue(Running)];
            [[task should] receive:@selector(stop:)];
            [condition stop:blackboard];
        });

    });
    
    context(@"when run", ^{
        
        it(@"should call evaluate with blackboard", ^{
            [blackboard setObject:@"testVal" forKey:@"testKey"];
            [[condition should] receive:@selector(evaluate:) withArguments:blackboard];
            [condition run:blackboard];
        });
        
        context(@"and evaluates to NO", ^{
            
            beforeEach(^{
                [[condition should] receive:@selector(evaluate:) andReturn:theValue(NO)];
            });
            
            it(@"should return Failure", ^{
                [[theValue([condition run:blackboard]) should] equal:theValue(Failure)];
            });
            
            it(@"should not start task", ^{
                [[task shouldNot] receive:@selector(start:)];
                [condition run:blackboard];
            });
            
            it(@"should not run task", ^{
                [[task shouldNot] receive:@selector(run:)];
                [condition run:blackboard];
            });
        });
        
        context(@"and evaluates to YES", ^{

            beforeEach(^{
                [[condition should] receive:@selector(evaluate:) andReturn:theValue(YES)];
            });

            it(@"should start task", ^{
                [[task should] receive:@selector(start:)];
                [condition run:blackboard];
            });

            it(@"should run task", ^{
                [[task should] receive:@selector(run:)];
                [condition run:blackboard];
            });
            
            context(@"when task returns Success", ^{
                
                beforeEach(^{
                    [[task should] receive:@selector(run:) andReturn:theValue(Success)];
                });
                
                it(@"should set task status to Ready", ^{
                    [[task should] receive:@selector(setStatus:) withArguments:theValue(Ready)];
                    [condition run:blackboard];
                });
                
                it(@"should return Success", ^{
                    [[theValue([condition run:blackboard]) should] equal:theValue(Success)];
                });
                
            });
            
            context(@"when task returns Failure", ^{

                beforeEach(^{
                    [[task should] receive:@selector(run:) andReturn:theValue(Failure)];
                });
                
                it(@"should set task status to Ready", ^{
                    [[task should] receive:@selector(setStatus:) withArguments:theValue(Ready)];
                    [condition run:blackboard];
                });

                it(@"should return Failure", ^{
                    [[theValue([condition run:blackboard]) should] equal:theValue(Failure)];
                });

            });
            
            context(@"when task returns Pending", ^{

                beforeEach(^{
                    [[task should] receive:@selector(run:) andReturn:theValue(Pending)];
                });
                
                it(@"should set task status to Running", ^{
                    [[task should] receive:@selector(setStatus:) withArguments:theValue(Running)];
                    [condition run:blackboard];
                });

                it(@"should return Pending", ^{
                    [[theValue([condition run:blackboard]) should] equal:theValue(Pending)];
                });

            });

        });
        
    });
});

SPEC_END