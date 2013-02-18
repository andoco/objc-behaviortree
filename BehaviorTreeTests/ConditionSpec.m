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

#import "AOCondition.h"
#import "AOTask.h"

SPEC_BEGIN(ConditionSpec)

describe(@"Condition", ^{
    __block AOCondition *condition;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        condition = [[AOCondition alloc] init];
    });
    
    it(@"should evaluate to YES by default", ^{
        [[theValue([condition evaluate:blackboard]) should] equal:theValue(YES)];
    });
        
    context(@"when run", ^{
        
        it(@"should call evaluate with blackboard", ^{
            [blackboard setObject:@"testVal" forKey:@"testKey"];
            [[condition should] receive:@selector(evaluate:) withArguments:blackboard];
            [condition run:blackboard];
        });
        
        context(@"condition in instant mode", ^{

            context(@"and evaluates to NO", ^{
                
                beforeEach(^{
                    [[condition should] receive:@selector(evaluate:) andReturn:theValue(NO)];
                });
                
                it(@"should return Failure", ^{
                    [[theValue([condition run:blackboard]) should] equal:theValue(AOResultFailure)];
                });
                
            });
            
            context(@"and evaluates to YES", ^{
                
                beforeEach(^{
                    [[condition should] receive:@selector(evaluate:) andReturn:theValue(YES)];
                });
                
                it(@"should return Success", ^{
                    [[theValue([condition run:blackboard]) should] equal:theValue(AOResultSuccess)];
                });
                
            });

        });
        
        context(@"condition in monitor mode", ^{
            
            beforeEach(^{
                condition.monitor = YES;
            });
            
            context(@"and evaluates to NO", ^{
                
                beforeEach(^{
                    [[condition should] receive:@selector(evaluate:) andReturn:theValue(NO)];
                });
                
                it(@"should return Failure", ^{
                    [[theValue([condition run:blackboard]) should] equal:theValue(AOResultFailure)];
                });
                
            });
            
            context(@"and evaluates to YES", ^{
                
                beforeEach(^{
                    [[condition should] receive:@selector(evaluate:) andReturn:theValue(YES)];
                });
                
                it(@"should return Pending", ^{
                    [[theValue([condition run:blackboard]) should] equal:theValue(AOResultPending)];
                });
                
            });

        });
        
        
    });
});

SPEC_END