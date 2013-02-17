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
#import "AOAlwaysFail.h"

SPEC_BEGIN(AlwaysFailSpec)

describe(@"AlwaysFail", ^{
    __block AOAlwaysFail *task;
    __block id subtask;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        subtask = [KWMock nullMockForProtocol:@protocol(AOTask)];
        task = [[AOAlwaysFail alloc] initWithTask:subtask];
        blackboard = [NSMutableDictionary dictionary];
    });
    
    context(@"when run", ^{
        
        it(@"should return Failure when decorated task returns Success", ^{
            [[subtask should] receive:@selector(run:) andReturn:theValue(AOResultSuccess)];
            [[theValue([task run:blackboard]) should] equal:theValue(AOResultFailure)];
        });

        it(@"should return Failure when decorated task return Failure", ^{
            [[subtask should] receive:@selector(run:) andReturn:theValue(AOResultFailure)];
            [[theValue([task run:blackboard]) should] equal:theValue(AOResultFailure)];
        });
        
        it(@"should return Failure when decorated task return Pending", ^{
            [[subtask should] receive:@selector(run:) andReturn:theValue(AOResultPending)];
            [[theValue([task run:blackboard]) should] equal:theValue(AOResultFailure)];
        });
    });
        
});

SPEC_END