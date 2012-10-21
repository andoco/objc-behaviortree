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

#import "Action.h"
#import "Sequence.h"

SPEC_BEGIN(SequenceSpec)

describe(@"Sequence", ^{
    __block Sequence *sequence;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        sequence = [[Sequence alloc] init];
        blackboard = [NSMutableDictionary dictionary];
    });
    
    context(@"when run", ^{
        
        it(@"should run children until child returns Failure", ^{
            
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];

            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Failure)];

            id task3 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task3 shouldNot] receive:@selector(run:)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            [sequence addChild:task3];
            
            [sequence run:blackboard];
        });
        
        it(@"should return Success if no child returns Failure", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Success)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(Success)];
        });
        
        it(@"should return Failure if any child returns Failure", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];

            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Failure)];

            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(Failure)];
        });
        
        it(@"should return Pending if child returns Pending", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Pending)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(Pending)];
        });
                
        it(@"should stop running child if preceding child returns Failure", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success) withCount:2];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Pending)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(Pending)];
            
            // second run setup
            [[task1 should] receive:@selector(run:) andReturn:theValue(Failure)];
            [[task2 should] receive:@selector(stop:)];
            [[theValue([sequence run:blackboard]) should] equal:theValue(Failure)];
        });
        
        it(@"should stop running child if preceding child returns Pending", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success) withCount:2];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Pending)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(Pending)];
            
            // second run setup
            [[task1 should] receive:@selector(run:) andReturn:theValue(Running)];
            [[task2 should] receive:@selector(stop:)];
            [[theValue([sequence run:blackboard]) should] equal:theValue(Failure)];
        });
    });
});

SPEC_END