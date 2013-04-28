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

#import "AOAction.h"
#import "AOSelector.h"

SPEC_BEGIN(SelectorSpec)

describe(@"Selector", ^{
    __block AOSelector *selector;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        selector = [[AOSelector alloc] init];
        blackboard = [NSMutableDictionary dictionary];
    });
    
    context(@"when run", ^{
        
        it(@"should indices of all children from tasksToRun method", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [selector addChildren:task1, task2, nil];

            [[[selector tasksToRun] should] equal:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, selector.children.count)]];
        });
        
        it(@"should run children until child returns Success", ^{
            
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 shouldNot] receive:@selector(run:)];
            
            [selector addChild:task1];
            [selector addChild:task2];
            
            [selector run:blackboard];
        });
        
        it(@"should return Success if any child returns Success", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [task1 stub:@selector(run:) andReturn:theValue(AOResultFailure)];

            id task2 = [AOAction mock];
            [task1 stub:@selector(run:) andReturn:theValue(AOResultSuccess)];
            
            [selector addChild:task1];
            [selector addChild:task2];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(AOResultSuccess)];
        });
        
        it(@"should return Failure if no child returns Success", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [task1 stub:@selector(run:) andReturn:theValue(AOResultFailure)];
            
            [selector addChild:task1];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(AOResultFailure)];
        });
        
        it(@"should return Pending if any child returns Pending", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [task1 stub:@selector(run:) andReturn:theValue(AOResultFailure)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [task2 stub:@selector(run:) andReturn:theValue(AOResultPending)];
            
            [selector addChild:task1];
            [selector addChild:task2];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(AOResultPending)];
        });
                
        context(@"a child is already Running", ^{
            
            __block id task1;
            __block id task2;
            __block id task3;
            
            beforeEach(^{
                task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
                task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
                task3 = [KWMock nullMockForProtocol:@protocol(AOTask)];
                
                [selector addChildren:task1, task2, task3, nil];
                
                [[task1 stubAndReturn:theValue(AOResultFailure)] run:blackboard];
                [[task2 stubAndReturn:theValue(AOResultPending)] run:blackboard];
                [selector run:blackboard];
            });
            
            it(@"should return children from index of running task from tasksToRun method", ^{
                [[[selector tasksToRun] should] equal:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]];
            });

            context(@"running child is the last child", ^{
                
                beforeEach(^{
                    [[task2 stubAndReturn:theValue(AOResultFailure)] run:blackboard];
                    [[task3 stubAndReturn:theValue(AOResultPending)] run:blackboard];
                    [selector run:blackboard];
                });
                
                context(@"running child returns Success", ^{
                    
                    beforeEach(^{
                        [[task3 stubAndReturn:theValue(AOResultSuccess)] run:blackboard];
                        [selector run:blackboard];
                    });
                    
                    it(@"tasksToRun should return all children on next run", ^{
                        [[theValue(selector.tasksToRun.count) should] equal:theValue(selector.children.count)];
                    });
                    
                });
                
                context(@"running child returns Failure", ^{
                    
                    beforeEach(^{
                        [[task3 stubAndReturn:theValue(AOResultFailure)] run:blackboard];
                        [selector run:blackboard];
                    });
                    
                    it(@"tasksToRun should return all children on next run", ^{
                        [[theValue(selector.tasksToRun.count) should] equal:theValue(selector.children.count)];
                    });
                    
                });
                
                
            });
            

        });
    });
    
    context(@"when stopped", ^{
        context(@"and child running", ^{
            it(@"tasksToRun should return all children", ^{
                id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
                [task1 stub:@selector(run:) andReturn:theValue(AOResultFailure)];
                
                id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
                [task2 stub:@selector(run:) andReturn:theValue(AOResultPending)];
                
                [selector addChildren:task1, task2, nil];
                
                [selector run:blackboard];
                [selector stop:blackboard];
                
                [[[selector tasksToRun] should] equal:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, selector.children.count)]];
            });
        });
    });

});

SPEC_END