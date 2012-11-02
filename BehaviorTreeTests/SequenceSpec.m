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
#import "AOSequence.h"

SPEC_BEGIN(SequenceSpec)

describe(@"Sequence", ^{
    __block AOSequence *sequence;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        sequence = [[AOSequence alloc] init];
        blackboard = [NSMutableDictionary dictionary];
    });
    
    context(@"when run", ^{
        
        it(@"should run children until child returns Failure", ^{
            
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess)];

            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(AOResultFailure)];

            id task3 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task3 shouldNot] receive:@selector(run:)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            [sequence addChild:task3];
            
            [sequence run:blackboard];
        });
        
        it(@"should return Success if no child returns Failure", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(AOResultSuccess)];
        });
        
        it(@"should return Failure if any child returns Failure", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess)];

            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(AOResultFailure)];

            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(AOResultFailure)];
        });
        
        it(@"should return Pending if child returns Pending", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(AOResultPending)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(AOResultPending)];
        });
                
        it(@"should stop running child if preceding child returns Failure", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess) withCount:2];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(AOResultPending)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(AOResultPending)];
            
            // second run setup
            [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultFailure)];
            [[task2 should] receive:@selector(stop:)];
            [[theValue([sequence run:blackboard]) should] equal:theValue(AOResultFailure)];
        });
        
        it(@"should stop running child if preceding child returns Pending", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess) withCount:2];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(AOResultPending)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(AOResultPending)];
            
            // second run setup
            [[task1 should] receive:@selector(run:) andReturn:theValue(AOStatusRunning)];
            [[task2 should] receive:@selector(stop:)];
            [[theValue([sequence run:blackboard]) should] equal:theValue(AOResultFailure)];
        });
        
        context(@"a child is already Running", ^{
            
            __block id task1;
            __block id task2;
            
            beforeEach(^{
                task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
                task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
                
                [sequence addChild:task1];
                [sequence addChild:task2];
                
                [[task1 stubAndReturn:theValue(AOResultSuccess)] run:blackboard];
                [[task2 stubAndReturn:theValue(AOResultPending)] run:blackboard];
                [sequence run:blackboard];
            });
            
            context(@"a child returns Pending", ^{
                
                it(@"should stop already running child if not same as child", ^{
                    [task1 clearStubs];
                    [task2 clearStubs];
                    
                    [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultPending)];
                    [[task2 should] receive:@selector(stop:)];
                    [[task2 should] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];
                    
                    [sequence run:blackboard];
                });
                
                it(@"should not stop already running child if same as child", ^{
                    [[task2 shouldNot] receive:@selector(stop:)];
                    [[task2 shouldNot] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];
                    
                    [sequence run:blackboard];
                });
            });
            
            context(@"a child returns Failure", ^{
                
                it(@"should stop already running child if not same as child", ^{
                    [task1 clearStubs];
                    [task2 clearStubs];
                    
                    [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess)];
                    [[task2 should] receive:@selector(stop:)];
                    [[task2 should] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];
                    
                    [sequence run:blackboard];
                });
                
                it(@"should not stop already running child if same as child", ^{
                    [[task2 shouldNot] receive:@selector(stop:)];
                    [[task2 shouldNot] receive:@selector(setStatus:) withArguments:theValue(AOStatusReady)];
                    
                    [sequence run:blackboard];
                });
            });

        });

    });
});

SPEC_END