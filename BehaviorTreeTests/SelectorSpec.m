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
                
        it(@"should stop running child if preceding child returns Success", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 stubAndReturn:theValue(AOResultFailure)] run:blackboard];

            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 stubAndReturn:theValue(AOResultPending)] run:blackboard];

            [selector addChild:task1];
            [selector addChild:task2];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(AOResultPending)];
            
            // second run setup
            [[task1 stubAndReturn:theValue(AOResultSuccess)] run:blackboard];
            [[task2 should] receive:@selector(stop:)];
            [[theValue([selector run:blackboard]) should] equal:theValue(AOResultSuccess)];
        });
        
        it(@"should stop running child if preceding child returns Pending", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 stubAndReturn:theValue(AOResultFailure)] run:blackboard];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 stubAndReturn:theValue(AOResultPending)] run:blackboard];
            
            [selector addChild:task1];
            [selector addChild:task2];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(AOResultPending)];
            
            // second run setup
            [[task1 stubAndReturn:theValue(AOResultPending)] run:blackboard];
            [[task2 should] receive:@selector(stop:)];
            [[theValue([selector run:blackboard]) should] equal:theValue(AOResultPending)];
        });
        
        context(@"a child is already Running", ^{
            
            __block id task1;
            __block id task2;
            
            beforeEach(^{
                task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
                task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
                
                [selector addChild:task1];
                [selector addChild:task2];
                
                [[task1 stubAndReturn:theValue(AOResultFailure)] run:blackboard];
                [[task2 stubAndReturn:theValue(AOResultPending)] run:blackboard];
                [selector run:blackboard];
            });

            context(@"a child returns Pending", ^{
                
                it(@"should stop already running child if not same as child", ^{
                    [task1 clearStubs];
                    [task2 clearStubs];
                    
                    [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultPending)];
                    [[task2 should] receive:@selector(stop:)];
                    [[task2 should] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];
                    
                    [selector run:blackboard];
                });
                
                it(@"should not stop already running child if same as child", ^{
                    [[task2 shouldNot] receive:@selector(stop:)];
                    [[task2 shouldNot] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];
                    
                    [selector run:blackboard];
                });
            });
            
            context(@"a child returns Success", ^{
                
                it(@"should stop already running child if not same as child", ^{
                    [task1 clearStubs];
                    [task2 clearStubs];
                    
                    [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess)];
                    [[task2 should] receive:@selector(stop:)];
                    [[task2 should] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];
                    
                    [selector run:blackboard];
                });
                
                it(@"should not stop already running child if same as child", ^{
                    [[task2 shouldNot] receive:@selector(stop:)];
                    [[task2 shouldNot] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];
                    
                    [selector run:blackboard];
                });
            });

        });
    });
});

SPEC_END