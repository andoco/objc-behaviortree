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
#import "Selector.h"

SPEC_BEGIN(SelectorSpec)

describe(@"Selector", ^{
    __block Selector *selector;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        selector = [[Selector alloc] init];
        blackboard = [NSMutableDictionary dictionary];
    });
    
    context(@"when run", ^{
        
        it(@"should run children until child returns Success", ^{
            
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 shouldNot] receive:@selector(run:)];
            
            [selector addChild:task1];
            [selector addChild:task2];
            
            [selector run:blackboard];
        });
        
        it(@"should return Success if any child returns Success", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task1 stub:@selector(run:) andReturn:theValue(Failure)];

            id task2 = [Action mock];
            [task1 stub:@selector(run:) andReturn:theValue(Success)];
            
            [selector addChild:task1];
            [selector addChild:task2];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(Success)];
        });
        
        it(@"should return Failure if no child returns Success", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task1 stub:@selector(run:) andReturn:theValue(Failure)];
            
            [selector addChild:task1];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(Failure)];
        });
        
        it(@"should return Pending if any child returns Pending", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task1 stub:@selector(run:) andReturn:theValue(Failure)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task2 stub:@selector(run:) andReturn:theValue(Pending)];
            
            [selector addChild:task1];
            [selector addChild:task2];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(Pending)];
        });
                
        it(@"should stop running child if preceding child returns Success", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 stubAndReturn:theValue(Failure)] run:blackboard];

            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 stubAndReturn:theValue(Pending)] run:blackboard];

            [selector addChild:task1];
            [selector addChild:task2];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(Pending)];
            
            // second run setup
            [[task1 stubAndReturn:theValue(Success)] run:blackboard];
            [[task2 should] receive:@selector(stop:)];
            [[theValue([selector run:blackboard]) should] equal:theValue(Success)];
        });
        
        it(@"should stop running child if preceding child returns Pending", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 stubAndReturn:theValue(Failure)] run:blackboard];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 stubAndReturn:theValue(Pending)] run:blackboard];
            
            [selector addChild:task1];
            [selector addChild:task2];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(Pending)];
            
            // second run setup
            [[task1 stubAndReturn:theValue(Pending)] run:blackboard];
            [[task2 should] receive:@selector(stop:)];
            [[theValue([selector run:blackboard]) should] equal:theValue(Pending)];
        });
        
        context(@"a child is already Running", ^{
            
            __block id task1;
            __block id task2;
            
            beforeEach(^{
                task1 = [KWMock nullMockForProtocol:@protocol(Task)];
                task2 = [KWMock nullMockForProtocol:@protocol(Task)];
                
                [selector addChild:task1];
                [selector addChild:task2];
                
                [[task1 stubAndReturn:theValue(Failure)] run:blackboard];
                [[task2 stubAndReturn:theValue(Pending)] run:blackboard];
                [selector run:blackboard];
            });

            context(@"a child returns Pending", ^{
                
                it(@"should stop already running child if not same as child", ^{
                    [task1 clearStubs];
                    [task2 clearStubs];
                    
                    [[task1 should] receive:@selector(run:) andReturn:theValue(Pending)];
                    [[task2 should] receive:@selector(stop:)];
                    [[task2 should] receive:@selector(setStatus:) withArguments:theValue(Ready)];
                    
                    [selector run:blackboard];
                });
                
                it(@"should not stop already running child if same as child", ^{
                    [[task2 shouldNot] receive:@selector(stop:)];
                    [[task2 shouldNot] receive:@selector(setStatus:) withArguments:theValue(Ready)];
                    
                    [selector run:blackboard];
                });
            });
            
            context(@"a child returns Success", ^{
                
                it(@"should stop already running child if not same as child", ^{
                    [task1 clearStubs];
                    [task2 clearStubs];
                    
                    [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];
                    [[task2 should] receive:@selector(stop:)];
                    [[task2 should] receive:@selector(setStatus:) withArguments:theValue(Ready)];
                    
                    [selector run:blackboard];
                });
                
                it(@"should not stop already running child if same as child", ^{
                    [[task2 shouldNot] receive:@selector(stop:)];
                    [[task2 shouldNot] receive:@selector(setStatus:) withArguments:theValue(Ready)];
                    
                    [selector run:blackboard];
                });
            });

        });
    });
});

SPEC_END