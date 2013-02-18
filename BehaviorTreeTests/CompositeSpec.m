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
#import "AOComposite.h"

SPEC_BEGIN(CompositeSpec)

describe(@"Composite", ^{
    __block AOComposite *task;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        task = [[AOComposite alloc] init];
    });

    context(@"when initialized", ^{
        it(@"children should be empty", ^{
            [task.children shouldNotBeNil];
            [[theValue(task.children.count) should] equal:theValue(0)];
        });
    });
    
    context(@"when child added", ^{
        it(@"should be added to children", ^{
            id action1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            id action2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            
            [task addChild:action1];
            [task addChild:action2];
            
            [[theValue(task.children.count) should] equal:theValue(2)];
            [[[task.children objectAtIndex:0] should] equal:action1];
            [[[task.children objectAtIndex:1] should] equal:action2];
        });
    });
    
    context(@"when child added using variadic method", ^{
        it(@"should be added to children", ^{
            id action1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            id action2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            
            [task addChildren:action1, action2, nil];
            
            [[theValue(task.children.count) should] equal:theValue(2)];
            [[[task.children objectAtIndex:0] should] equal:action1];
            [[[task.children objectAtIndex:1] should] equal:action2];
        });
    });    
    
    context(@"when initialized with children", ^{
        
        it(@"arguments should be added to children", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            
            task = [[AOComposite alloc] initWithChildren:task1, task2, nil];

            [[theValue(task.children.count) should] equal:theValue(2)];
        });
    });
    
    context(@"when run", ^{
                
        beforeEach(^{
            blackboard = [NSMutableDictionary dictionary];
        });
        
        it(@"Should return all child tasks from tasksToRun method", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            
            [task addChildren:task1, task2, nil];
            
            [[theValue([task tasksToRun].count) should] equal:theValue(2)];
        });
        
        it(@"Should only visit tasks returned by tasksToRun template method", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 stubAndReturn:theValue(AOStatusReady)] status];
            [[task1 shouldNot] receive:@selector(start:)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 stubAndReturn:theValue(AOStatusReady)] status];
            [[task2 should] receive:@selector(start:)];

            id task3 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task3 stubAndReturn:theValue(AOStatusReady)] status];
            [[task3 shouldNot] receive:@selector(start:)];

            [task addChildren:task1, task2, task3, nil];
            
            [task stub:@selector(tasksToRun) andReturn:[NSIndexSet indexSetWithIndex:1]];
            [task run:blackboard];
        });
        
        it(@"should start tasks with status Ready", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 stubAndReturn:theValue(AOStatusReady)] status];
            [[task1 should] receive:@selector(start:)];
            
            [task addChild:task1];
            
            [task run:blackboard];
        });
        
        it(@"should not start tasks with status Running", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 stubAndReturn:theValue(AOStatusRunning)] status];
            [[task1 shouldNot] receive:@selector(start)];
            
            [task addChild:task1];
            
            [task run:blackboard];
        });
                        
        context(@"child task returns Success", ^{
            
            __block id task1;
            
            beforeEach(^{
                task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
                [[task1 stubAndReturn:theValue(AOStatusReady)] status];
                [[task1 stubAndReturn:theValue(AOResultSuccess)] run:blackboard];
                [task addChild:task1];
            });
            
            it(@"should stop task", ^{
                [[task1 should] receive:@selector(stop:)];
                [task run:blackboard];
            });

            it(@"should change task status to Ready", ^{
                [[task1 should] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];
                [task run:blackboard];
            });
        });

        context(@"child task returns Failure", ^{
            
            __block id task1;
            
            beforeEach(^{
                task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
                [[task1 stubAndReturn:theValue(AOStatusReady)] status];
                [[task1 stubAndReturn:theValue(AOResultFailure)] run:blackboard];
                [task addChild:task1];
            });
            
            it(@"should stop task", ^{
                [[task1 should] receive:@selector(stop:)];
                [task run:blackboard];
            });
            
            it(@"should change task status to Ready", ^{
                [[task1 should] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];
                [task run:blackboard];
            });
        });

        context(@"child task returns Pending", ^{
            
            __block id task1;
            
            beforeEach(^{
                task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
                [[task1 stubAndReturn:theValue(AOStatusReady)] status];
                [[task1 stubAndReturn:theValue(AOResultPending)] run:blackboard];
                [task addChild:task1];
            });
            
            it(@"should not stop task", ^{
                [[task1 shouldNot] receive:@selector(stop:)];
                [task run:blackboard];
            });

            it(@"should change task status to Running", ^{
                [[task1 should] receive:@selector(setStatus:) withArguments:theValue(AOStatusRunning)];
                [task run:blackboard];
            });
        });

    });
    
    context(@"when stopped", ^{

        it(@"should stop running children and set child status to Ready", ^{
            
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 stubAndReturn:theValue(AOStatusRunning)] status];
            [[task1 should] receive:@selector(stop:) withArguments:blackboard];
            [[task1 should] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 stubAndReturn:theValue(AOStatusReady)] status];
            [[task2 shouldNot] receive:@selector(stop:) withArguments:blackboard];

            id task3 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task3 stubAndReturn:theValue(AOStatusRunning)] status];
            [[task3 should] receive:@selector(stop:) withArguments:blackboard];
            [[task3 should] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];

            [task addChildren:task1, task2, task3, nil];
            
            [task stop:blackboard];
        });
        
    });
});

SPEC_END