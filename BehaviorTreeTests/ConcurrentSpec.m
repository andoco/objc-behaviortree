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
#import "AOConcurrent.h"

SPEC_BEGIN(ConcurrentSpec)

describe(@"Concurrent", ^{
    __block AOConcurrent *concurrent;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        concurrent = [[AOConcurrent alloc] init];
        blackboard = [NSMutableDictionary dictionary];
    });
    
    context(@"when run", ^{
        
        it(@"should run all children", ^{
            
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(AOResultFailure)];
            
            id task3 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task3 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess)];
            
            [concurrent addChild:task1];
            [concurrent addChild:task2];
            [concurrent addChild:task3];
            
            [concurrent run:blackboard];
        });
                
        it(@"should increment numFailedChildren for each failed child", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(AOResultFailure)];
                        
            [concurrent addChild:task1];
            [concurrent addChild:task2];
            
            [concurrent run:blackboard];
            
            [[theValue(concurrent.numFailed) should] equal:theValue(1)];
        });
        
        it(@"should reset numFailedChildren when started", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(AOResultSuccess)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(AOResultFailure)];
            
            [concurrent addChild:task1];
            [concurrent addChild:task2];
            
            [concurrent run:blackboard];
            
            [concurrent start:blackboard];
            
            [[theValue(concurrent.numFailed) should] equal:theValue(0)];
        });

        it(@"should return Success if failureLimit is zero and has failed children", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [task1 stub:@selector(run:) andReturn:theValue(AOResultFailure)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [task2 stub:@selector(run:) andReturn:theValue(AOResultSuccess)];
            
            [concurrent addChild:task1];
            [concurrent addChild:task2];
            
            [[theValue([concurrent run:blackboard]) should] equal:theValue(AOResultSuccess)];
        });

        it(@"should return Failure if failed children is greater than or equal to failure limit", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [task1 stub:@selector(run:) andReturn:theValue(AOResultFailure)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [task2 stub:@selector(run:) andReturn:theValue(AOResultSuccess)];
            
            [concurrent addChild:task1];
            [concurrent addChild:task2];
            concurrent.failureLimit = 1;
            
            [[theValue([concurrent run:blackboard]) should] equal:theValue(AOResultFailure)];
        });

        it(@"should return Success if failed children is less than failure limit", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [task1 stub:@selector(run:) andReturn:theValue(AOResultFailure)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [task1 stub:@selector(run:) andReturn:theValue(AOResultSuccess)];
            
            [concurrent addChild:task1];
            [concurrent addChild:task2];
            concurrent.failureLimit = 2;
            
            [[theValue([concurrent run:blackboard]) should] equal:theValue(AOResultSuccess)];
        });
        
        it(@"should return Pending if any child returns Pending", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [task1 stub:@selector(run:) andReturn:theValue(AOResultFailure)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [task2 stub:@selector(run:) andReturn:theValue(AOResultPending)];
            
            id task3 = [KWMock nullMockForProtocol:@protocol(AOTask)];
            [task3 stub:@selector(run:) andReturn:theValue(AOResultSuccess)];
            
            [concurrent addChildren:task1, task2, task3, nil];
            
            [[theValue([concurrent run:blackboard]) should] equal:theValue(AOResultPending)];
        });        
    });
});

SPEC_END